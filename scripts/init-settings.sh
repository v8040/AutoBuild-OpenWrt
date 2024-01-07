#!/bin/bash

uci set luci.main.lang=zh_cn
uci set luci.main.mediaurlbase='/luci-static/argon'
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

sed -i 's/^src/#&/' /etc/opkg/distfeeds.conf
sed -i 's/^option check_signature/#&/' /etc/opkg.conf

sed -i '/DISTRIB_REVISION/d' /etc/openwrt_release
echo "DISTRIB_REVISION='R$(TZ=UTC-8 date "+%-m.%-d")'" >> /etc/openwrt_release
sed -i '/DISTRIB_RELEASE/d' /etc/openwrt_release
echo "DISTRIB_RELEASE='$(TZ=UTC-8 date "+%Y.%-m.%-d")'" >> /etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' /etc/openwrt_release
echo "DISTRIB_DESCRIPTION='OpenWrt '" >> /etc/openwrt_release

exit 0
