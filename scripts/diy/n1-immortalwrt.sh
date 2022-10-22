#!/bin/bash

# 修改默认IP和hostname
sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/N1/g' package/base-files/files/bin/config_generate

# 修改99-default-settings-chinese
wget https://raw.githubusercontent.com/v8040/diy/main/diy-settings -O package/emortal/default-settings/files/99-default-settings-chinese

# 修改opkg源
echo "src/gz openwrt_kiddin9 https://op.supes.top/packages/aarch64_cortex-a53" >> package/system/opkg/files/customfeeds.conf

# 移除重复软件包
rm -rf feeds/luci/applications/luci-app-aliyundrive-fuse
rm -rf feeds/luci/applications/luci-app-minidlna
rm -rf feeds/luci/applications/luci-app-turboacc

# 添加额外软件包
svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-minidlna package/luci-app-minidlna
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-turboacc package/luci-app-turboacc
svn co https://github.com/messense/aliyundrive-fuse/trunk/openwrt/aliyundrive-fuse package/aliyundrive-fuses
svn co https://github.com/messense/aliyundrive-fuse/trunk/openwrt/luci-app-aliyundrive-fuse package/luci-app-aliyundrive-fuse

./scripts/feeds update -a
./scripts/feeds install -a
