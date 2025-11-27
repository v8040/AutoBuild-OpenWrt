#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/functions.sh" &>/dev/null
success "[${0##*/}] init"

rm_pkg '*smartdns'
rm_pkg '*theme-argon'
rm_pkg 'zerotier'

sparse_clone main https://github.com/v8040/openwrt-packages.git luci-app-smartdns
sparse_clone main https://github.com/v8040/openwrt-packages.git luci-theme-argon
sparse_clone main https://github.com/v8040/openwrt-packages.git smartdns
sparse_clone main https://github.com/v8040/openwrt-packages.git zerotier

sed -i 's|admin/network|admin/control|g' package/mtk/applications/luci-app-eqos-mtk/root/usr/share/luci/menu.d/*.json

success "[${0##*/}] done"
exit 0