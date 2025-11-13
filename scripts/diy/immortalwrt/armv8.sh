#!/usr/bin/env bash

SCRIPT_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null)
FUNCTIONS_FILE=$(realpath "${SCRIPT_DIR}/../../functions.sh" 2>/dev/null)
. "${FUNCTIONS_FILE}" &>/dev/null
info "[$(basename "${0}")] init"

# Modify opkg source
echo "src/gz openwrt_kiddin9 https://dl.openwrt.ai/latest/packages/aarch64_cortex-a53/kiddin9" >> package/system/opkg/files/customfeeds.conf

# Add turboacc for firewall4
curl -fsSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh &>/dev/null

sub_name "Turbo ACC 网络加速" "网络加速"
sub_name "UPnP IGD 和 PCP" "UPnP设置"

success "[$(basename "${0}")] done"
exit 0