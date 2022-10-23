#!/bin/bash

uci set luci.main.lang=zh_cn
uci commit luci

uci -q batch <<-EOF
	set system.@system[0].timezone='CST-8'
	set system.@system[0].zonename='Asia/Shanghai'

	delete system.ntp.server
	add_list system.ntp.server='ntp.ntsc.ac.cn'
	add_list system.ntp.server='cn.ntp.org.cn'
	add_list system.ntp.server='cn.pool.ntp.org'
	add_list system.ntp.server='pool.ntp.org'

EOF
uci commit system

uci set nlbwmon.@nlbwmon[0].refresh_interval=2s
uci commit nlbwmon

uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci

sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

sed -i 's/^src/#&/' /etc/opkg/distfeeds.conf
sed -i 's/^option check_signature/#&/' /etc/opkg.conf

sed -i '/DISTRIB_REVISION/d' /etc/openwrt_release
echo "DISTRIB_REVISION='R$(TZ=UTC-8 date "+%-m.%-d")'" >> /etc/openwrt_release
sed -i '/DISTRIB_RELEASE/d' /etc/openwrt_release
echo "DISTRIB_RELEASE='$(TZ=UTC-8 date "+%Y.%-m.%-d")'" >> /etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' /etc/openwrt_release
echo "DISTRIB_DESCRIPTION='OpenWrt '" >> /etc/openwrt_release

sed -i 's/LuCI Master/v8040/g' /usr/lib/lua/luci/version.lua
sed -i 's/LuCI openwrt-18.06 branch/v8040/g' /usr/lib/lua/luci/version.lua
sed -i 's/LuCI openwrt-18.06-k5.4 branch/v8040/g' /usr/lib/lua/luci/version.lua
sed -i 's/LuCI 17.01 Lienol/v8040/g' /usr/lib/lua/luci/version.lua
sed -i 's/LuCI openwrt-21.02 branch/v8040/g' /usr/lib/lua/luci/version.lua
sed -i '/luciversion/d' /usr/lib/lua/luci/version.lua
echo "luciversion = '$(TZ=UTC-8 date "+%Y.%-m.%-d")'" >> /usr/lib/lua/luci/version.lua

exit 0
