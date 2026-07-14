#!/usr/bin/env python3
"""Discover build matrix from configs/manifest.yaml.
Usage: discover-builds.py [manifest.yaml]
Outputs JSON suitable for GitHub Actions strategy.matrix.fromJson().
For each (branch, device) in the manifest's matrix section, it:
1. Reads the device config to find the kconfig target (CONFIG_TARGET_*=y)
2. Maps it to the workflow target name via branch's target_map
3. Outputs {"include": [...]}
"""

import json
import os
import re
import subprocess
import sys


def load_manifest(manifest_path):
    result = subprocess.run(
        ["yq", "-o", "json", manifest_path],
        capture_output=True, text=True, check=True,
    )
    return json.loads(result.stdout)


CONFIG_TARGET_RE = re.compile(r"^CONFIG_TARGET_([a-zA-Z0-9_]+)=y$")


def discover_target(manifest_dir, device_entry, branch_entry):
    device_conf = os.path.join(manifest_dir, device_entry["config"])
    if not os.path.isfile(device_conf):
        sys.exit(f"ERROR: Device config not found: {device_conf}")
    with open(device_conf) as f:
        for line in f:
            m = CONFIG_TARGET_RE.match(line.strip())
            if m:
                kconfig_target = m.group(1)
                target_map = branch_entry.get("target_map", {})
                if kconfig_target in target_map:
                    return target_map[kconfig_target]
                return kconfig_target
    sys.exit(f"ERROR: No CONFIG_TARGET_*=y found in {device_conf}")


def discover_matrix(manifest_path):
    manifest_dir = os.path.dirname(os.path.abspath(manifest_path))
    manifest = load_manifest(manifest_path)
    matrix = manifest.get("matrix", {})
    branches = manifest.get("branches", {})
    devices = manifest.get("devices", {})
    include = []
    for branch_key, device_list in matrix.items():
        if branch_key not in branches:
            sys.exit(
                f"ERROR: Branch '{branch_key}' in matrix not found in branches section"
            )
        branch_entry = branches[branch_key]
        for device_key in device_list:
            device_entry = devices.get(device_key)
            if not device_entry:
                sys.exit(
                    f"ERROR: Device '{device_key}' in matrix for branch '{branch_key}' not found in devices section"
                )
            target = discover_target(manifest_dir, device_entry, branch_entry)
            include.append(
                {
                    "source_branch": branch_key,
                    "target": target,
                    "board": device_entry.get("board", device_key),
                }
            )
    return {"include": include}


def main():
    manifest_path = sys.argv[1] if len(sys.argv) > 1 else "configs/manifest.yaml"
    if not os.path.isfile(manifest_path):
        sys.exit(f"ERROR: Manifest not found: {manifest_path}")
    result = discover_matrix(manifest_path)
    print(json.dumps(result))


if __name__ == "__main__":
    main()
