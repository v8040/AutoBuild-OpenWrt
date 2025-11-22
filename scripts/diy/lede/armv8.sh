#!/usr/bin/env bash

SCRIPT_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null)
FUNCTIONS_FILE=$(realpath "${SCRIPT_DIR}/../../functions.sh" 2>/dev/null)
. "${FUNCTIONS_FILE}" &>/dev/null
info "[$(basename "${0}")] init"

# Modify opkg source
echo "src/gz openwrt_kiddin9 https://dl.openwrt.ai/latest/packages/aarch64_cortex-a53/kiddin9" >> package/system/opkg/files/customfeeds.conf

rm_pkg "*smartdns"

sparse_clone main https://github.com/v8040/openwrt-packages.git luci-app-smartdns
sparse_clone main https://github.com/v8040/openwrt-packages.git smartdns

sub_name "Turbo ACC 网络加速" "网络加速"

success "[$(basename "${0}")] done"
exit 0