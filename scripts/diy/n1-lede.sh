#!/bin/bash

# 修改默认IP和hostname
sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/N1/g' package/base-files/files/bin/config_generate

# 修改zzz-default-settings
wget https://raw.githubusercontent.com/v8040/diy/main/lede-settings -O package/lean/default-settings/files/lede-settings
orig_version=$(echo "$(cat package/lean/default-settings/files/zzz-default-settings)" | grep -Po "DISTRIB_REVISION=\'\K[^\']*")
sed -i "s/${orig_version}/R$(TZ=UTC-8 date "+%-m.%-d")/g" package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/d' package/lean/default-settings/files/zzz-default-settings
cat package/lean/default-settings/files/lede-settings >> package/lean/default-settings/files/zzz-default-settings

# 修改opkg源
echo "src/gz openwrt_kiddin9 https://op.supes.top/packages/aarch64_cortex-a53" >> package/system/opkg/files/customfeeds.conf

./scripts/feeds update -a
./scripts/feeds install -a
