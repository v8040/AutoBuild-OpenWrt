#!/bin/bash

uci -q get system.@imm_init[0] > "/dev/null" || uci -q add system imm_init > "/dev/null"

uci set luci.main.lang=zh_cn
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci

uci -q batch <<-EOF
    set system.@system[0].timezone='CST-8'
    set system.@system[0].zonename='Asia/Shanghai'

    delete system.ntp.server
    add_list system.ntp.server='time.cloudflare.com'
    add_list system.ntp.server='ntp.tencent.com'
    add_list system.ntp.server='ntp.aliyun.com'
    add_list system.ntp.server='time.apple.com'
    add_list system.ntp.server='cn.pool.ntp.org'

EOF
uci commit system

uci set fstab.@global[0].anon_mount=1
uci commit fstab

uci set nlbwmon.@nlbwmon[0].refresh_interval=2s
uci commit nlbwmon

sed -i 's/^src/#&/' /etc/opkg/distfeeds.conf
sed -i 's/^option check_signature/#&/' /etc/opkg.conf

# sed -i 's/OPENWRT_RELEASE="[^"]*"/OPENWRT_RELEASE="OpenWrt"/' /etc/os-release
# sed -i "s/DISTRIB_RELEASE='[^']*'/DISTRIB_RELEASE='OpenWrt'/" /etc/openwrt_release
# sed -i "s/DISTRIB_DESCRIPTION='[^']*'/DISTRIB_DESCRIPTION='OpenWrt'/" /etc/openwrt_release
# sed -i "s/DISTRIB_REVISION='[^']*'/DISTRIB_REVISION='R$(TZ=UTC-8 date '+%-m.%-d')'/" /etc/openwrt_release

sed -i '/log-facility/d' /etc/dnsmasq.conf
echo "log-facility=/dev/null" >> /etc/dnsmasq.conf

rm -rf /tmp/luci-modulecache
rm -rf /tmp/luci-indexcache

exit 0