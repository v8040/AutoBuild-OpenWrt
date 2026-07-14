#!/usr/bin/env python3
"""Assemble a merged OpenWrt .config from fragments and device config.
Usage: assemble-config.py <manifest> <branch> <device> [output_file]
The script:
1. Reads manifest.yaml to find the device's fragment inheritance list
2. Reads the branch's override fragment (if any)
3. Reads branch_overrides from the manifest for the specific (branch, device)
4. Concatenates all fragments + branch_overrides + device config, deduplicating
   CONFIG_* keys (last occurrence wins - highest priority later in the list)
5. Outputs the assembled config to stdout or the specified file
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


CONFIG_LINE_RE = re.compile(r"^(CONFIG_[A-Za-z0-9_-]+)=(.+)$")


def resolve_device_key(manifest, branch_key, board_name):
    """Resolve the internal device key from a board name and branch.
    First tries direct match (board name IS the device key).
    If not found in the branch's matrix, searches for a device with a matching
    'board' alias that is listed in the branch's matrix section.
    """
    devices = manifest.get("devices", {})
    matrix = manifest.get("matrix", {})
    branch_devices = matrix.get(branch_key, [])
    if board_name in devices and board_name in branch_devices:
        return board_name
    for device_key in branch_devices:
        device = devices.get(device_key, {})
        if device.get("board") == board_name:
            return device_key
    if board_name in devices:
        return board_name
    sys.exit(
        f"ERROR: Board '{board_name}' not found in devices or matrix for branch '{branch_key}'"
    )


def resolve_sources(manifest, branch_key, board_name, manifest_dir):
    device_key = resolve_device_key(manifest, branch_key, board_name)
    device = manifest["devices"].get(device_key)
    if not device:
        sys.exit(f"ERROR: Device '{device_key}' not found in manifest")
    branch = manifest["branches"].get(branch_key)
    if not branch:
        sys.exit(f"ERROR: Branch '{branch_key}' not found in manifest")
    fragments_dir = os.path.join(
        manifest_dir, manifest.get("fragments_dir", "fragments")
    )
    fragment_defs = manifest.get("fragments", {})
    sources = []
    for name in device.get("inherits", []):
        frag = fragment_defs.get(name)
        if not frag:
            sys.exit(
                f"ERROR: Fragment '{name}' referenced by device '{device_key}' not found in manifest"
            )
        frag_file = os.path.join(fragments_dir, frag["file"])
        if not os.path.isfile(frag_file):
            sys.exit(f"ERROR: Fragment file not found: {frag_file}")
        sources.append(frag_file)
    branch_config = branch.get("config")
    if isinstance(branch_config, list):
        sources.append(branch_config)

    branch_overrides = device.get("branch_overrides", {})
    if isinstance(branch_overrides, dict):
        override_lines = branch_overrides.get(branch_key, [])
        if override_lines:
            sources.append(override_lines)
    device_conf = os.path.join(manifest_dir, device["config"])
    if not os.path.isfile(device_conf):
        sys.exit(f"ERROR: Device config file not found: {device_conf}")
    sources.append(device_conf)
    return sources


def assemble(sources):
    config = {}
    non_config = []

    for source in sources:
        if isinstance(source, str):
            with open(source) as f:
                lines = f.read().splitlines()
        elif isinstance(source, list):
            lines = source
        else:
            continue

        for stripped in lines:
            stripped = stripped.rstrip("\n").rstrip("\r")
            m = CONFIG_LINE_RE.match(stripped)
            if m:
                config[m.group(1)] = stripped
            else:
                non_config.append(stripped)

    return "\n".join(config.values()) + "\n" + "\n".join(non_config) + "\n"


def main():
    if len(sys.argv) < 3:
        print(
            f"Usage: {sys.argv[0]} <manifest.yaml> <branch> <device> [output_file]",
            file=sys.stderr,
        )
        sys.exit(1)
    manifest_path = sys.argv[1]
    branch = sys.argv[2]
    device = sys.argv[3]
    output_file = sys.argv[4] if len(sys.argv) > 4 else None
    if not os.path.isfile(manifest_path):
        sys.exit(f"ERROR: Manifest not found: {manifest_path}")
    manifest_dir = os.path.dirname(os.path.abspath(manifest_path))
    manifest = load_manifest(manifest_path)
    sources = resolve_sources(manifest, branch, device, manifest_dir)
    config_content = assemble(sources)
    if output_file:
        with open(output_file, "w") as f:
            f.write(config_content)
    else:
        sys.stdout.write(config_content)


if __name__ == "__main__":
    main()
