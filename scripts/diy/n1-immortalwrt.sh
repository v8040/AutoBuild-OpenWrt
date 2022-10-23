#!/bin/bash

# 修改默认IP和hostname
sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/N1/g' package/base-files/files/bin/config_generate

# 修改99-default-settings-chinese
# wget https://raw.githubusercontent.com/v8040/diy/main/immortalwrt-settings -O package/emortal/default-settings/files/99-default-settings-chinese

# 修改opkg源
echo "src/gz openwrt_kiddin9 https://op.supes.top/packages/aarch64_cortex-a53" >> package/system/opkg/files/customfeeds.conf

./scripts/feeds update -a
./scripts/feeds install -a
