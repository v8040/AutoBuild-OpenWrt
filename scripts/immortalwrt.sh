#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/functions.sh" &>/dev/null
success "[${0##*/}] init"

# Add turboacc for firewall4
curl -fsSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh &>/dev/null

sub_name 'Turbo ACC 网络加速' '网络加速'
sub_name 'UPnP IGD 和 PCP' 'UPnP设置'

success "[${0##*/}] done"
exit 0