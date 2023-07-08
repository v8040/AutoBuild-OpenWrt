#!/bin/bash

# 修改默认IP和hostname
sed -i 's/192.168.1.1/10.10.11.1/g' package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/D2/g' package/base-files/files/bin/config_generate

# 修改opkg源
echo "src/gz openwrt_kiddin9 https://op.supes.top/packages/mipsel_24kc" >> package/system/opkg/files/customfeeds.conf
