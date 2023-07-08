#!/bin/bash

# 修改默认IP和hostname
sed -i 's/192.168.1.1/10.10.11.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/D2/g' package/base-files/files/bin/config_generate

# 修改opkg源
echo "src/gz openwrt_kiddin9 https://op.supes.top/packages/mipsel_24kc" >> package/system/opkg/files/customfeeds.conf

# 18.06package
find . -maxdepth 4 -iname "*serverchan" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*wechatpush" -type d | xargs rm -rf
find . -maxdepth 4 -iname "luci*argon*" -type d | xargs rm -rf
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush.git package/luci-app-wechatpush
sed -i 's/"Argon 主题设置"/"主题设置"/g' `grep "Argon 主题设置" -rl ./`
