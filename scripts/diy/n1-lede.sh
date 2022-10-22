#!/bin/bash

# 修改默认IP和hostname
sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/N1/g' package/base-files/files/bin/config_generate

# 修改zzz-default-settings
wget https://raw.githubusercontent.com/v8040/diy/main/lede-settings -O package/lean/default-settings/files/lede-settings
orig_version=$(echo "$(cat package/lean/default-settings/files/zzz-default-settings)" | grep -Po "DISTRIB_REVISION=\'\K[^\']*")
sed -i "s/${orig_version}/R$(TZ=UTC-8 date "+%-m.%-d")/g" package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/d' package/lean/default-settings/files/zzz-default-settings
cat lede-settings >> zzz-default-settings

# 修改opkg源
echo "src/gz openwrt_kiddin9 https://op.supes.top/packages/aarch64_cortex-a53" >> package/system/opkg/files/customfeeds.conf

# 移除重复package
rm -rf feeds/luci/applications/luci-app-eqos
rm -rf feeds/packages/net/v2ray-geodata

# 添加package
svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-eqos package/luci-app-eqos
svn co https://github.com/kiddin9/openwrt-packages/trunk/v2ray-geodata package/v2ray-geodata

# 调整菜单
sed -i 's/network/control/g' package/luci-app-eqos/luasrc/controller/*.lua
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-fuse/luasrc/controller/*.lua
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-fuse/luasrc/model/cbi/aliyundrive-fuse/*.lua
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-fuse/luasrc/view/aliyundrive-fuse/*.htm

./scripts/feeds update -a
./scripts/feeds install -a
