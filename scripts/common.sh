#!/bin/bash

# 移除package
rm_package() {
    find ./ -maxdepth 4 -iname "$1" -type d | xargs rm -rf || echo -e "\e[31mNot found [$1]\e[0m"
}

rm_package "*adguardhome"
rm_package "*advanced"
rm_package "*alist"
rm_package "*amlogic"
rm_package "*argon-config"
rm_package "*bypass"
rm_package "*ddns-go"
rm_package "*ddnsto"
rm_package "*dockerman"
rm_package "*mosdns"
rm_package "*netdata"
rm_package "*netspeedtest"
rm_package "*nlbwmon*"
rm_package "*onliner"
rm_package "*openclash"
rm_package "*partexp"
rm_package "*passwall"
rm_package "*pushbot"
rm_package "*qbittorrent*"
rm_package "*shadowsocks*"
rm_package "*smartdns"
rm_package "*sqm*"
rm_package "*ssr*"
rm_package "*taskplan"
rm_package "*theme-argon"
rm_package "*transmission*"
rm_package "*trojan*"
rm_package "*v2ray*"
rm_package "*wechatpush"
rm_package "*xray*"
rm_package "dnsproxy"
rm_package "minidlna"
rm_package "miniupnpc"
rm_package "miniupnpd"

# 添加package
git clone -q --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
git clone -q --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone -q --depth=1 https://github.com/sbwml/luci-app-alist.git package/alist
git clone -q --depth=1 https://github.com/sbwml/luci-app-mosdns.git package/mosdns
git clone -q --depth=1 https://github.com/sbwml/v2ray-geodata.git package/v2ray-geodata
git clone -q --depth=1 https://github.com/sirpdboy/luci-app-advanced.git package/luci-app-advanced
git clone -q --depth=1 https://github.com/sirpdboy/luci-app-partexp.git package/luci-app-partexp
git clone -q --depth=1 https://github.com/sirpdboy/luci-app-taskplan.git package/luci-app-taskplan
git clone -q --depth=1 https://github.com/sirpdboy/netspeedtest.git package/luci-app-netspeedtest
git clone -q --depth=1 https://github.com/zzsj0928/luci-app-pushbot.git package/luci-app-pushbot

git_sparse_clone() {
    branch="$1" repourl="$2" repodir="$3"
    [[ -d "package/cache" ]] && rm -rf package/cache
    git clone -q --branch=$branch --depth=1 --filter=blob:none --sparse $repourl package/cache &&
    git -C package/cache sparse-checkout set $repodir &&
    mv -f package/cache/$repodir package &&
    rm -rf package/cache ||
    echo -e "\e[31mFailed to sparse clone $repodir from $repourl($branch).\e[0m"
}

git_sparse_clone main https://github.com/kiddin9/kwrt-packages.git luci-app-control-timewol
git_sparse_clone main https://github.com/kiddin9/kwrt-packages.git luci-app-onliner
git_sparse_clone main https://github.com/linkease/nas-packages-luci.git luci/luci-app-ddnsto
git_sparse_clone main https://github.com/ophub/luci-app-amlogic.git luci-app-amlogic
git_sparse_clone master https://github.com/linkease/nas-packages.git network/services/ddnsto
git_sparse_clone master https://github.com/vernesong/OpenClash.git luci-app-openclash

git_sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-ddns-go
git_sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-dockerman
git_sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-minidlna
git_sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-smartdns
git_sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-sqm
git_sparse_clone master https://github.com/immortalwrt/packages.git multimedia/minidlna
git_sparse_clone master https://github.com/immortalwrt/packages.git net/ddns-go
git_sparse_clone master https://github.com/immortalwrt/packages.git net/miniupnpc
git_sparse_clone master https://github.com/immortalwrt/packages.git net/miniupnpd
git_sparse_clone master https://github.com/immortalwrt/packages.git net/smartdns
git_sparse_clone master https://github.com/immortalwrt/packages.git net/sqm-scripts

# requires golang latest version
rm -rf feeds/packages/lang/golang
git clone -q --depth=1 https://github.com/sbwml/packages_lang_golang.git feeds/packages/lang/golang

# 更改默认主题背景
cp -f ${GITHUB_WORKSPACE}/images/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# samba解除root限制
sed -i 's/invalid users = root/#&/g' feeds/packages/net/samba4/files/smb.conf.template

# ttyd自动登录
sed -i "s?/bin/login?/usr/libexec/login.sh?g" feeds/packages/utils/ttyd/files/ttyd.config

# amlogic
sed -i "s|amlogic_firmware_repo.*|amlogic_firmware_repo 'https://github.com/v8040/AutoBuild-OpenWrt'|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|amlogic_kernel_path.*|amlogic_kernel_path 'https://github.com/ophub/kernel'|g" package/luci-app-amlogic/root/etc/config/amlogic

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# 调整菜单
sed -i 's/services/control/g' feeds/luci/applications/luci-app-eqos/root/usr/share/luci/menu.d/*.json
sed -i 's/services/control/g' feeds/luci/applications/luci-app-nft-qos/luasrc/controller/*.lua
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-ksmbd/root/usr/share/luci/menu.d/*.json
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/controller/*.lua
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/model/cbi/openclash/*.lua
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/view/openclash/*.htm
sed -i 's|admin/network|admin/control|g' package/luci-app-sqm/root/usr/share/luci/menu.d/*.json

# 修改默认IP和hostname固件信息
sed -i "s|192\.168\.[0-9]*\.[0-9]*|${OPENWRT_IP}|g" feeds/luci/modules/luci-mod-system/htdocs/luci-static/resources/view/system/flash.js
sed -i "s|192\.168\.[0-9]*\.[0-9]*|${OPENWRT_IP}|g" package/base-files/files/bin/config_generate
sed -i "s/hostname='.*'/hostname='OpenWrt'/g" package/base-files/files/bin/config_generate
sed -i 's/OPENWRT_RELEASE="[^"]*"/OPENWRT_RELEASE="OpenWrt"/' package/base-files/files/usr/lib/os-release
sed -i "s/DISTRIB_RELEASE='[^']*'/DISTRIB_RELEASE='OpenWrt'/" package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_DESCRIPTION='[^']*'/DISTRIB_DESCRIPTION='OpenWrt'/" package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='[^']*'/DISTRIB_REVISION='R$(TZ=UTC-8 date '+%-m.%-d')'/" package/base-files/files/etc/openwrt_release

# 修改插件名字
replace_text() {
  search_text="$1" new_text="$2"
  sed -i "s/$search_text/$new_text/g" $(grep "$search_text" -rl ./ 2>/dev/null) || echo -e "\e[31mNot found [$search_text]\e[0m"
}

replace_text "Argon 主题设置" "主题设置"
replace_text "DDNS-Go" "DDNSGO"
replace_text "DDNSTO 远程控制" "DDNSTO"
replace_text "KMS 服务器" "KMS激活"
replace_text "QoS Nftables 版" "QoS管理"
replace_text "SQM 队列管理" "SQM管理"
replace_text "动态 DNS" "动态DNS"
replace_text "网络存储" "NAS"
replace_text "解除网易云音乐播放限制" "音乐解锁"

echo -e "\e[32m$0 [DONE]\e[0m"