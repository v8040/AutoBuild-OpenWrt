#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/functions.sh" &>/dev/null
success "[${0##*/}] init"

# Remove packages
rm_pkg '*adguardhome'
rm_pkg '*amlogic'
rm_pkg '*argon-config'
rm_pkg '*bypass'
rm_pkg '*ddns-go'
rm_pkg '*ddnsto'
rm_pkg '*dockerman'
rm_pkg '*mosdns'
rm_pkg '*nlbwmon*'
rm_pkg '*onliner'
rm_pkg '*openclash'
rm_pkg '*passwall*'
rm_pkg '*pushbot'
rm_pkg '*qbittorrent*'
rm_pkg '*shadowsocks*'
rm_pkg '*ssr*'
rm_pkg '*theme-argon'
rm_pkg '*transmission*'
rm_pkg '*trojan*'
rm_pkg '*v2ray*'
rm_pkg '*xray*'
rm_pkg 'dnsproxy'

# Add packages
git clone -q --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
git clone -q --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone -q --depth=1 https://github.com/sbwml/luci-app-mosdns.git package/mosdns
git clone -q --depth=1 https://github.com/sbwml/v2ray-geodata.git package/v2ray-geodata
git clone -q --depth=1 https://github.com/zzsj0928/luci-app-pushbot.git package/luci-app-pushbot

sparse_clone main https://github.com/kiddin9/kwrt-packages.git luci-app-control-timewol
sparse_clone main https://github.com/kiddin9/kwrt-packages.git luci-app-onliner
sparse_clone main https://github.com/linkease/nas-packages-luci.git luci/luci-app-ddnsto
sparse_clone main https://github.com/ophub/luci-app-amlogic.git luci-app-amlogic
sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-ddns-go
sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-dockerman
sparse_clone master https://github.com/immortalwrt/packages.git net/ddns-go
sparse_clone master https://github.com/linkease/nas-packages.git network/services/ddnsto
sparse_clone master https://github.com/vernesong/OpenClash.git luci-app-openclash

# Requires golang latest version
rm -rf feeds/packages/lang/golang
git clone -q --depth=1 https://github.com/sbwml/packages_lang_golang.git feeds/packages/lang/golang

# Change default theme background
[[ -f "${GITHUB_WORKSPACE}/images/bg1.jpg" ]] && cp -f "${GITHUB_WORKSPACE}/images/bg1.jpg" package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# Samba root restriction removal & Remove auto-share configuration
sed -i 's/invalid users = root/#&/g' feeds/packages/net/samba4/files/smb.conf.template
rm -f feeds/packages/net/samba4/files/{smb.auto,uci_defaults_samba}
sed -i '/hotplug.d/d; /uci-defaults/d' feeds/packages/net/samba4/Makefile

# Modify bash configuration
echo "HISTFILE='/dev/null'" >> feeds/packages/utils/bash/files/etc/bash.bashrc

# Modify ttyd auto login
sed -i 's|/bin/login|/usr/libexec/login.sh|g' feeds/packages/utils/ttyd/files/ttyd.config

# Modify amlogic
sed -i "s|amlogic_firmware_repo.*|amlogic_firmware_repo 'https://github.com/v8040/AutoBuild-OpenWrt'|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|amlogic_kernel_path.*|amlogic_kernel_path 'https://github.com/ophub/kernel'|g" package/luci-app-amlogic/root/etc/config/amlogic

# Adjust menu
sed -i 's|admin/network|admin/control|g' feeds/luci/applications/luci-app-sqm/root/usr/share/luci/menu.d/*.json
sed -i 's|admin/services|admin/nas|g' feeds/luci/applications/luci-app-hd-idle/root/usr/share/luci/menu.d/*.json
sed -i 's|admin/services|admin/nas|g' feeds/luci/applications/luci-app-ksmbd/root/usr/share/luci/menu.d/*.json
sed -i 's|admin/services|admin/nas|g' feeds/luci/applications/luci-app-minidlna/root/usr/share/luci/menu.d/*.json
sed -i 's|admin/services|admin/nas|g' feeds/luci/applications/luci-app-samba4/root/usr/share/luci/menu.d/*.json
sed -i 's|admin/services|admin/system|g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/*.json
sed -i 's|"admin", "services"|"admin", "vpn"|g' package/luci-app-openclash/luasrc/controller/*.lua
sed -i 's|"admin", "services"|"admin", "vpn"|g' package/luci-app-openclash/luasrc/model/cbi/openclash/*.lua
sed -i 's|"admin", "services"|"admin", "vpn"|g' package/luci-app-openclash/luasrc/view/openclash/*.htm

# Modify default IP and hostname
sed -i "s|192\.168\.[0-9]*\.[0-9]*|${OPENWRT_IP}|g" package/base-files/files/bin/config_generate
sed -i "s/hostname='.*'/hostname='OpenWrt'/g" package/base-files/files/bin/config_generate
sed -i 's/NAME="[^"]*"/NAME="OpenWrt"/' package/base-files/files/usr/lib/os-release
sed -i "s/VERSION=\"[^\"]*\"/VERSION=\"R$(date '+%m.%d' | sed 's|^0||; s|\.0|.|g')\"/" package/base-files/files/usr/lib/os-release
sed -i 's/OPENWRT_RELEASE="[^"]*"/OPENWRT_RELEASE="OpenWrt"/' package/base-files/files/usr/lib/os-release
sed -i "s/DISTRIB_RELEASE='[^']*'/DISTRIB_RELEASE='OpenWrt'/" package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_DESCRIPTION='[^']*'/DISTRIB_DESCRIPTION='OpenWrt '/" package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='[^']*'/DISTRIB_REVISION='R$(date '+%m.%d' | sed 's|^0||; s|\.0|.|g')'/" package/base-files/files/etc/openwrt_release

# Modify plugin names
sub_name 'Argon 主题设置' '主题设置'
sub_name 'DDNS-Go' 'DDNSGO'
sub_name 'DDNSTO 远程控制' 'DDNSTO'
sub_name 'KMS 服务器' 'KMS激活'
sub_name 'SQM 队列管理' 'SQM管理'
sub_name '动态 DNS' '动态DNS'
sub_name '解除网易云音乐播放限制' '音乐解锁'

success "[${0##*/}] done"
exit 0