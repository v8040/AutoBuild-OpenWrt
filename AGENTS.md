# AGENTS.md

## No local build
All compilation runs on GitHub Actions (Ubuntu 24.04). No `make`, Docker, or local dev server.

## Workflow architecture
6 dispatch workflows under `.github/workflows/`:
- `build-armv8.yml`, `build-ramips.yml`, `build-mediatek.yml`, `package-armv8.yml`, `package-armbian.yml`, `build-all.yml`
- The first 5 are thin callers that delegate to **`build.yml`** — the core reusable `workflow_call` template.
- `package-armbian.yml` is a standalone workflow that uses `ophub/amlogic-s9xxx-armbian` directly (no OpenWrt compilation).
- `build-all.yml` uses a **Discover** job that calls `scripts/discover-builds.py` to dynamically generate the build matrix from `configs/manifest.yaml`.

## Config path convention
Configs use a layered fragment system driven by `configs/manifest.yaml`:

```
configs/
├── manifest.yaml              # Single source of truth: devices, fragments, branches, build matrix
├── fragments/                 # Reusable config blocks
│   ├── common.conf            # Shared tail block (all builds)
│   ├── router-base.conf       # Router rootfs/wpad/USB
│   ├── apps-full.conf         # Full-featured LUCI apps
│   ├── apps-light.conf        # Medium LUCI apps
│   ├── apps-nano.conf         # Minimal LUCI apps for low-memory devices
│   ├── rootfs-base.conf       # RootFS partition scheme & wireless drivers
│   └── mt798x.conf            # MT798x driver & property configs
├── devices/                   # Device-specific overrides (branch-independent)
│   ├── ax3000t.conf
│   ├── d2.conf
│   ├── r1cl.conf
│   ├── r1cm.conf
│   ├── rm2100.conf
│   ├── rootfs.conf
│   └── ax3000t-mt798x.conf
├── openwrt-depends         # OpenWrt build dependencies
└── armbian-depends          # Armbian build dependencies
```

### How it works
- **`configs/manifest.yaml`** defines devices, their fragment inheritance, branch metadata, and the build matrix
- **`scripts/assemble-config.py <manifest> <branch> <device> <out>`** concatenates fragments + branch config + branch_overrides + device config, deduplicating CONFIG_* keys (last wins)
- **`scripts/discover-builds.py <manifest>`** outputs GitHub Actions matrix JSON from the manifest's `matrix` section
- Both scripts use `yq` to convert YAML to JSON; `pyyaml` is installed via `python3-yaml` in `configs/openwrt-depends`

### Assembly priority (low → high)
```
fragments (inherits list) → branch config → branch_overrides → device config
```
Branch-specific device overrides (`branch_overrides` in manifest) apply only to the specific (branch, device) pair. Device configs are branch-independent — branch differences are declared in the manifest, not in device files.

### Device `board` alias
A device entry may set `board: <name>` to use a different board name than the device key.
`discover-builds.py` outputs this as the `board` field in the build matrix, and
`assemble-config.py` resolves it back to the device key at config assembly time.
Example: `ax3000t-mt798x` has `board: ax3000t` — different fragments for the
MT798x branch while sharing the same physical board name.

### To add a device
1. Create `configs/devices/<name>.conf` with target lines and device overrides
2. Add device entry to `manifest.yaml` (under `devices` with inherits + config)
3. Add the device to the branch list(s) in the `matrix` section

### To add a package to all builds
Edit the relevant fragment in `configs/fragments/`

`source_branch` is one of: `immortalwrt`, `lede`, `immortalwrt-mt798x`. The `branches` section in `configs/manifest.yaml` is the **single source of truth** for repo URLs and branch names — `build.yml` reads them at runtime via `yq`, so no duplicated hardcoded mappings exist:

| source_branch | repo (in manifest.yaml) | branch (in manifest.yaml) |
|---|---|---|
| immortalwrt | immortalwrt/immortalwrt | master |
| lede | coolsnowwolf/lede | master |
| immortalwrt-mt798x | hanwckf/immortalwrt-mt798x | openwrt-21.02 |

To add a new source branch, declare it in `branches` and `matrix` sections of `configs/manifest.yaml` — no additional code changes needed.

## DIY script execution order
1. `scripts/common.sh` — runs for ALL branches (package removal, cloning, theme/menu/IP/VERSION changes)
2. `scripts/<source_branch>.sh` — branch-specific overrides
3. `scripts/init-settings.sh` — copied to default-settings files during Custom Config step (sets LuCI language/theme, timezone, NTP, disables tailscale, etc.)
4. For armv8/mediatek targets, `scripts/preset-smartdns.sh aarch64` also runs

All scripts source `scripts/functions.sh` which provides helper utilities and colored logging. Preset scripts (`preset-dnsproxy.sh`, `preset-clash-core.sh`, `preset-smartdns.sh`) follow the same `source` + `success()` pattern for consistent CI output.

## `functions.sh` utilities
- `info <msg>` / `success <msg>` / `warning <msg>` / `error <msg>` — colored log output with tput/ANSI fallback for consistent CI logging. Adopted by ALL scripts including preset scripts.
- `sparse_clone <branch> <repo-url> <path>` — sparse-clone a single directory from a repo AND fix relative Makefile include paths to absolute `$(TOPDIR)/feeds/...` paths. Uses 10 verified sed rules (7 from the original validated set + 3 rust rules). The `../`-level luci.mk rule was intentionally excluded to avoid partial-match collisions with `../../luci.mk`.
- `rm_pkg <pattern>` — find and remove packages matching pattern
- `rm_dep <pattern>` — strip matching dependency references from all Makefiles
- `sub_name <search> <replace>` — replace display text in luci `.htm/.js/.json/.lua/.po` files

## Caching
Two-layer caching to reduce CI build time:
- **Cache Toolchain** (`stupidloud/cachewrtbuild@main`): caches compiled toolchain
  (`staging_dir/host*`, `staging_dir/tool*`) keyed by `source_branch-target` with
  automatic git-hash versioning. Branch-specific, cannot be shared across branches.
- **Cache DL Packages** (`actions/cache@main`): caches downloaded source packages
  (`dl/`) keyed by `dl-source_branch-target`, with `restore-keys` falling back
  to `dl-target` (same target, any branch) then `dl-` (any cache). `make download`
  verifies checksums, so mismatched files are safely re-downloaded.

## package_mode flag
When `package_mode=true` (in `package-armv8.yml`), the workflow skips cloning/compilation and uses `gh release download` (authenticated via `GITHUB_TOKEN`) to fetch a previously-built `rootfs.tar.gz` from the repo's own releases. Enables repackaging with a different kernel.

## Custom actions
- `init-system/` — installs build deps from `configs/openwrt-depends` (with retry), sets up LVM on `/builder` for extra disk space
- `flippy-openwrt-wrapper/` — clones and runs `ophub/flippy-openwrt-actions`
- `release/` — wraps `gh release create / edit / upload / delete-asset` with retry logic; used by both `build.yml` and `package-armbian.yml`

## Tool conventions
The GitHub Actions Ubuntu 24.04 runner ships with several preinstalled tools the build relies on:

| Tool | Used for |
|---|---|
| `gh` | All GitHub API interactions (`release view`, `release download`). Replaces raw `curl`+`grep` API calls. Authenticated via `GITHUB_TOKEN`. |
| `yq` | Reads `configs/manifest.yaml` at runtime for branch→repo resolution in `build.yml`. |
| `jq` | JSON parsing when inline queries are needed outside `gh`'s `--jq` context. |

These tools eliminate fragile string-based JSON/YAML parsing (`grep`, `cut`, case statements) and unauthenticated GitHub API calls.

## Optional repo-root overlays
- `feeds.conf.default` — if present at repo root, replaces the default feeds config
- `files/` — if present, overlays custom files into the firmware root

## Release conventions
- Tag per target: `armv8`, `ramips`, `mediatek`, `package`, `armbian`
- Armv8 releases marked `latest`, all others `prerelease`
- Firmware filenames: `immortalwrt`/`openwrt` replaced with the source branch name
- Auto-cleanup (runs on `always()`): keeps 5 latest releases, 2 days of workflow runs

## Target defaults
- Armv8 IP: `10.10.10.1`, others: `10.10.11.1`
- Credentials: `root` / `password`
