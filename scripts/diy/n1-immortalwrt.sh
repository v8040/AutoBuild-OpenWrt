#!/bin/bash

# 修改默认IP和hostname
sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/N1/g' package/base-files/files/bin/config_generate

# 修改opkg源
echo "src/gz openwrt_kiddin9 https://op.supes.top/packages/aarch64_cortex-a53" >> package/system/opkg/files/customfeeds.conf

# argon主题
find . -maxdepth 4 -iname "*argon*" -path "*/luci/*" -type d | xargs rm -rf
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
sed -i 's/"Argon 主题设置"/"主题设置"/g' `grep "Argon 主题设置" -rl ./`

