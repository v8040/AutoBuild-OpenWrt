#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/functions.sh" &>/dev/null
success "[${0##*/}] init"

sub_name 'UPnP IGD 和 PCP' 'UPnP设置'

success "[${0##*/}] done"
exit 0