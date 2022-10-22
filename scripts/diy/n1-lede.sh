#!/bin/bash

# 修改默认IP和hostname
sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/N1/g' package/base-files/files/bin/config_generate

# 修改zzz-default-settings
date_version=$(date +"%Y.%m.%d")
orig_version=$(echo "$(cat package/lean/default-settings/files/zzz-default-settings)" | grep -Po "DISTRIB_REVISION=\'\K[^\']*")
sed -i "s/${orig_version}/v8040 Build ${date_version} @ LEDE /g" package/lean/default-settings/files/zzz-default-settings
sed -i '/bin\/sh/a\uci set nlbwmon.@nlbwmon[0].refresh_interval=2s' package/lean/default-settings/files/zzz-default-settings
sed -i '/nlbwmon/a\uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings

# 修改opkg源
echo "src/gz openwrt_kiddin9 https://op.supes.top/packages/aarch64_cortex-a53" >> package/system/opkg/files/customfeeds.conf

# 移除重复软件包
rm -rf feeds/luci/applications/luci-app-eqos
rm -rf feeds/packages/net/v2ray-geodata

# 添加额外软件包
svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-eqos package/luci-app-eqos
svn co https://github.com/kiddin9/openwrt-packages/trunk/v2ray-geodata package/v2ray-geodata

./scripts/feeds update -a
./scripts/feeds install -a
