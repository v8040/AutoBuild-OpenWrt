#!/bin/bash

# 移除package
find . -maxdepth 4 -iname "*adguardhome*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*advanced*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*aliyundrive*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*amlogic*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*autotimeset*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*bypass*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*ddnsto*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*dnsproxy*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*dockerman*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*eqos*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*miniupnpd*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*mosdns*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*music*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*netdata*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*onliner*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*openclash*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*passwall*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*pushbot*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*qbittorrent*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*serverchan*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*shadowsocks*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*speedtest*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*ssr*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*trojan*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*turboacc*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*v2ray*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*verysync*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*vssr*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*wizard*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*wrtbwmon*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*xray*" -type d | xargs rm -rf

# 添加package
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic
git clone https://github.com/sbwml/luci-app-mosdns.git package/mosdns
git clone https://github.com/sbwml/v2ray-geodata.git package/geodata
git clone https://github.com/sirpdboy/luci-app-advanced.git package/luci-app-advanced
git clone https://github.com/sirpdboy/luci-app-autotimeset.git package/luci-app-autotimeset
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan
git clone https://github.com/zzsj0928/luci-app-pushbot.git package/luci-app-pushbot
svn co https://github.com/coolsnowwolf/packages/trunk/net/miniupnpd package/miniupnpd
svn co https://github.com/kenzok8/small-package/trunk/luci-app-onliner package/luci-app-onliner
svn co https://github.com/kenzok8/small-package/trunk/luci-app-wrtbwmon package/luci-app-wrtbwmon
svn co https://github.com/kenzok8/small-package/trunk/wrtbwmon package/wrtbwmon
svn co https://github.com/kiddin9/openwrt-packages/trunk/ddnsgo package/ddnsgo
svn co https://github.com/kiddin9/openwrt-packages/trunk/dnsproxy package/dnsproxy
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-speedlimit package/luci-app-control-speedlimit
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-timewol package/luci-app-control-timewol
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-webrestriction package/luci-app-control-webrestriction
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-weburl package/luci-app-control-weburl
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ddns-go package/luci-app-ddns-go
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-eqos package/luci-app-eqos
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-netdata package/luci-app-netdata
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-turboacc package/luci-app-turboacc
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-verysync package/luci-app-verysync
svn co https://github.com/kiddin9/openwrt-packages/trunk/netdata package/netdata
svn co https://github.com/kiddin9/openwrt-packages/trunk/verysync package/verysync
svn co https://github.com/linkease/nas-packages-luci/trunk/luci/luci-app-ddnsto package/luci-app-ddnsto
svn co https://github.com/linkease/nas-packages/trunk/network/services/ddnsto package/ddnsto
svn co https://github.com/lisaac/luci-app-dockerman/trunk/applications/luci-app-dockerman package/luci-app-dockerman
svn co https://github.com/messense/aliyundrive-fuse/trunk/openwrt/aliyundrive-fuse package/aliyundrive-fuse
svn co https://github.com/messense/aliyundrive-fuse/trunk/openwrt/luci-app-aliyundrive-fuse package/luci-app-aliyundrive-fuse
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash

# samba解除root限制
sed -i 's/invalid users = root/#&/g' feeds/packages/net/samba4/files/smb.conf.template

# ttyd自动登录
sed -i "s?/bin/login?/usr/libexec/login.sh?g" feeds/packages/utils/ttyd/files/ttyd.config

# turboacc start_dnsproxy
sed -i 's|tls://9.9.9.9|https://1.12.12.12/dns-query|g' package/luci-app-turboacc/root/etc/init.d/turboacc
sed -i 's|tls://8.8.8.8|https://1.0.0.1/dns-query|g' package/luci-app-turboacc/root/etc/init.d/turboacc
sed -i 's|--cache --cache-min-ttl=3600|--http3|g' package/luci-app-turboacc/root/etc/init.d/turboacc

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

# 编译 po2lmo (如果有po2lmo可跳过)
pushd luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# 调整菜单
sed -i 's/network/control/g' feeds/luci/applications/luci-app-sqm/luasrc/controller/*.lua
sed -i 's/network/control/g' package/luci-app-eqos/luasrc/controller/*.lua
sed -i 's/services/nas/g' package/luci-app-aliyundrive-fuse/luasrc/controller/*.lua
sed -i 's/services/nas/g' package/luci-app-aliyundrive-fuse/luasrc/model/cbi/aliyundrive-fuse/*.lua
sed -i 's/services/nas/g' package/luci-app-aliyundrive-fuse/luasrc/view/aliyundrive-fuse/*.htm
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/*.lua
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/controller/*.lua
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/model/cbi/openclash/*.lua
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/view/openclash/*.htm
sed -i 's|admin/network|admin/control|g' feeds/luci/applications/luci-app-sqm/root/usr/share/luci/menu.d/*.json
sed -i 's|admin/network|admin/nlbw|g' package/luci-app-wrtbwmon/root/usr/share/luci/menu.d/*.json
sed -i 's|admin/services|admin/|g' feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/*.json

# 修改插件名字
sed -i 's/"Argon 主题设置"/"主题设置"/g' `grep "Argon 主题设置" -rl ./`
sed -i 's/"Aria2 配置"/"Aria2设置"/g' `grep "Aria2 配置" -rl ./`
sed -i 's/"Aria2"/"Aria2设置"/g' `grep "Aria2" -rl ./`
sed -i 's/"ChinaDNS-NG"/"ChinaDNS"/g' `grep "ChinaDNS-NG" -rl ./`
sed -i 's/"DDNS-GO"/"DDNSGO"/g' `grep "DDNS-GO" -rl ./`
sed -i 's/"DDNSTO 远程控制"/"DDNSTO"/g' `grep "DDNSTO 远程控制" -rl ./`
sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
sed -i 's/"NFS 管理"/"NFS管理"/g' `grep "NFS 管理" -rl ./`
sed -i 's/"Rclone"/"网盘挂载"/g' `grep "Rclone" -rl ./`
sed -i 's/"SQM QoS"/"SQM管理"/g' `grep "SQM QoS" -rl ./`
sed -i 's/"SQM 队列管理"/"SQM管理"/g' `grep "SQM 队列管理" -rl ./`
sed -i 's/"SoftEther VPN 服务器"/"SoftEther"/g' `grep "SoftEther VPN 服务器" -rl ./`
sed -i 's/"TTYD 终端"/"终端"/g' `grep "TTYD 终端" -rl ./`
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' `grep "Turbo ACC 网络加速" -rl ./`
sed -i 's/"UPnP"/"UPnP设置"/g' `grep "UPnP" -rl ./`
sed -i 's/"USB 打印服务器"/"USB打印"/g' `grep "USB 打印服务器" -rl ./`
sed -i 's/"Web 管理"/"Web"/g' `grep "Web 管理" -rl ./`
sed -i 's/"WireGuard 状态"/"WiGd状态"/g' `grep "WireGuard 状态" -rl ./`
sed -i 's/"WireGuard"/"WiGd状态"/g' `grep "WireGuard" -rl ./`
sed -i 's/"iKoolProxy 滤广告"/"广告过滤"/g' `grep "iKoolProxy 滤广告" -rl ./`
sed -i 's/"miniDLNA"/"DLNA设置"/g' `grep "miniDLNA" -rl ./`
sed -i 's/"迷你DLNA"/"DLNA设置"/g' `grep "迷你DLNA" -rl ./`
sed -i 's/"上网时间控制"/"上网控制"/g' `grep "上网时间控制" -rl ./`
sed -i 's/"动态 DNS"/"动态DNS"/g' `grep "动态 DNS" -rl ./`
sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./`
sed -i 's/"挂载 SMB 网络共享"/"挂载共享"/g' `grep "挂载 SMB 网络共享" -rl ./`
sed -i 's/"易有云文件管理器"/"易有云"/g' `grep "易有云文件管理器" -rl ./`
sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
sed -i 's/"联机用户"/"在线用户"/g' `grep "联机用户" -rl ./`
sed -i 's/"解除网易云音乐播放限制"/"音乐解锁"/g' `grep "解除网易云音乐播放限制" -rl ./`
sed -i 's/"阿里云盘 FUSE"/"阿里云盘"/g' `grep "阿里云盘 FUSE" -rl ./`