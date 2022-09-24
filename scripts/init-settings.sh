#!/bin/bash

# Set default theme to luci-theme-argon
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci

# Disable opkg signature check
# sed -i 's/option check_signature/# option check_signature/g' /etc/opkg.conf

# Disable IPV6 ula prefix
# sed -i 's/^[^#].*option ula/#&/' /etc/config/network

# Check file system during boot
uci set fstab.@global[0].check_fs=1
uci commit fstab

exit 0
