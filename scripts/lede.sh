#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/functions.sh" &>/dev/null
success "[${0##*/}] init"

rm_pkg '*smartdns'

sparse_clone main https://github.com/v8040/openwrt-packages.git luci-app-smartdns
sparse_clone main https://github.com/v8040/openwrt-packages.git smartdns

sub_name 'Turbo ACC 网络加速' '网络加速'

success "[${0##*/}] done"
exit 0