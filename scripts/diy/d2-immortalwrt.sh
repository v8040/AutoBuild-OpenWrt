#!/bin/bash

# 修改默认IP和hostname
sed -i 's/192.168.1.1/10.10.11.1/g' package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/D2/g' package/base-files/files/bin/config_generate

# 修改opkg源
echo "src/gz openwrt_kiddin9 https://op.supes.top/packages/mipsel_24kc" >> package/system/opkg/files/customfeeds.conf

# argon主题
find . -maxdepth 4 -iname "*argon*" -type d | xargs rm -rf
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

./scripts/feeds update -a
./scripts/feeds install -a
