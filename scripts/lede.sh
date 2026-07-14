#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/functions.sh" &>/dev/null
success "[${0##*/}] init"

sub_name 'Turbo ACC 网络加速' '网络加速'

success "[${0##*/}] done"
exit 0
