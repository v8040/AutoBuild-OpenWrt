#!/bin/bash

# 移除重复package
find . -maxdepth 4 -iname "*advanced*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*aliyundrive*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*amlogic*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*autotimeset*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*ddnsto*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*dockerman*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*music*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*onliner*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*pushbot*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*serverchan*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*speedtest*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*wrtbwmon*" -type d | xargs rm -rf

# 添加package
git clone https://github.com/kenzok8/openwrt-packages.git package/kenzok-package
git clone https://github.com/kenzok8/small-package.git package/small-package
cp -rf package/kenzok-package/* package && rm -rf package/kenzok-package
cp -rf package/small-package/* package && rm -rf package/small-package

# 替换package
find . -maxdepth 4 -iname "*argon*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*dnsproxy*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*eqos*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*minidlna*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*netdata*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*openclash*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*turboacc*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*verysync*" -type d | xargs rm -rf

git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-minidlna package/luci-app-minidlna
svn co https://github.com/coolsnowwolf/packages/trunk/multimedia/minidlna package/minidlna
svn co https://github.com/kiddin9/openwrt-packages/trunk/dnsproxy package/dnsproxy
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-eqos package/luci-app-eqos
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-netdata package/luci-app-netdata
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-turboacc package/luci-app-turboacc
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-verysync package/luci-app-verysync
svn co https://github.com/kiddin9/openwrt-packages/trunk/netdata package/netdata
svn co https://github.com/kiddin9/openwrt-packages/trunk/verysync package/verysync
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash

# 移除多余package
find . -maxdepth 4 -iname "*adguardhome*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*bypass*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*mosdns*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*passwall*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*shadowsocks*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*ssr*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*trojan*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*v2ray*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*vssr*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*wizard*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*xray*" -type d | xargs rm -rf

# samba解除root限制
sed -i 's/invalid users = root/#&/g' feeds/packages/net/samba4/files/smb.conf.template

# ttyd自动登录
sed -i "s?/bin/login?/usr/libexec/login.sh?g" feeds/packages/utils/ttyd/files/ttyd.config

# amlogic
sed -i "s|https.*/OpenWrt|https://github.com/v8040/AutoBuild-OpenWrt|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|opt/kernel|https://github.com/ophub/kernel/tree/main/pub/stable|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8_N1|g" package/luci-app-amlogic/root/etc/config/amlogic

# unblockneteasemusic
NAME=$"package/luci-app-unblockneteasemusic/root/usr/share/unblockneteasemusic" && mkdir -p $NAME/core
curl 'https://api.github.com/repos/UnblockNeteaseMusic/server/commits?sha=enhanced&path=precompiled' -o commits.json
echo "$(grep sha commits.json | sed -n "1,1p" | cut -c 13-52)">"$NAME/core_local_ver"
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/app.js -o $NAME/core/app.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/bridge.js -o $NAME/core/bridge.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/ca.crt -o $NAME/core/ca.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.crt -o $NAME/core/server.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.key -o $NAME/core/server.key

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}

# 调整菜单
sed -i 's/network/control/g' feeds/luci/applications/luci-app-sqm/luasrc/controller/*.lua
sed -i 's/network/control/g' package/luci-app-eqos/luasrc/controller/*.lua
sed -i 's/services/nas/g' package/luci-app-aliyundrive-fuse/luasrc/controller/*.lua
sed -i 's/services/nas/g' package/luci-app-aliyundrive-fuse/luasrc/model/cbi/aliyundrive-fuse/*.lua
sed -i 's/services/nas/g' package/luci-app-aliyundrive-fuse/luasrc/view/aliyundrive-fuse/*.htm
sed -i 's/services/nas/g' package/luci-app-minidlna/luasrc/controller/*.lua
sed -i 's/services/nas/g' package/luci-app-minidlna/luasrc/view/*.htm
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/*.lua
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/controller/*.lua
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/model/cbi/openclash/*.lua
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/view/openclash/*.htm

# 修改插件名字
sed -i 's/"Argon 主题设置"/"主题设置"/g' `grep "Argon 主题设置" -rl ./`
sed -i 's/"Aria2 配置"/"Aria2下载"/g' `grep "Aria2 配置" -rl ./`
sed -i 's/"ChinaDNS-NG"/"ChinaDNS"/g' `grep "ChinaDNS-NG" -rl ./`
sed -i 's/"DDNSTO 远程控制"/"DDNSTO"/g' `grep "DDNSTO 远程控制" -rl ./`
sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
sed -i 's/"NFS 管理"/"NFS管理"/g' `grep "NFS 管理" -rl ./`
sed -i 's/"Rclone"/"网盘挂载"/g' `grep "Rclone" -rl ./`
sed -i 's/"SQM QoS"/"流量控制"/g' `grep "SQM QoS" -rl ./`
sed -i 's/"SoftEther VPN 服务器"/"SoftEther"/g' `grep "SoftEther VPN 服务器" -rl ./`
sed -i 's/"TTYD 终端"/"终端"/g' `grep "TTYD 终端" -rl ./`
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' `grep "Turbo ACC 网络加速" -rl ./`
sed -i 's/"UPnP"/"UPnP服务"/g' `grep "UPnP" -rl ./`
sed -i 's/"USB 打印服务器"/"USB打印"/g' `grep "USB 打印服务器" -rl ./`
sed -i 's/"Web 管理"/"Web"/g' `grep "Web 管理" -rl ./`
sed -i 's/"WireGuard 状态"/"WiGd状态"/g' `grep "WireGuard 状态" -rl ./`
sed -i 's/"iKoolProxy 滤广告"/"广告过滤"/g' `grep "iKoolProxy 滤广告" -rl ./`
sed -i 's/"miniDLNA"/"DLNA服务"/g' `grep "miniDLNA" -rl ./`
sed -i 's/"上网时间控制"/"上网控制"/g' `grep "上网时间控制" -rl ./`
sed -i 's/"动态 DNS"/"动态DNS"/g' `grep "动态 DNS" -rl ./`
sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./`
sed -i 's/"挂载 SMB 网络共享"/"挂载共享"/g' `grep "挂载 SMB 网络共享" -rl ./`
sed -i 's/"易有云文件管理器"/"易有云"/g' `grep "易有云文件管理器" -rl ./`
sed -i 's/"网络共享 (KSMBD 内核)"/"KSMBD共享"/g' `grep "网络共享 (KSMBD 内核)" -rl ./`
sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
sed -i 's/"联机用户"/"在线用户"/g' `grep "联机用户" -rl ./`
sed -i 's/"解除网易云音乐播放限制"/"音乐解锁"/g' `grep "解除网易云音乐播放限制" -rl ./`
sed -i 's/"阿里云盘 FUSE"/"阿里云盘"/g' `grep "阿里云盘 FUSE" -rl ./`