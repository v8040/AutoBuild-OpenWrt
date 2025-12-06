#!/bin/sh

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

sed -i 's/^option check_signature/#&/' /etc/opkg.conf
sed -i 's/^src/#&/' /etc/opkg/distfeeds.conf
sed -i 's/^/#/' /etc/apk/repositories.d/distfeeds.list

sed -i '/log-facility/d' /etc/dnsmasq.conf
echo "log-facility=/dev/null" >> /etc/dnsmasq.conf

rm -rf /tmp/luci-modulecache
rm -rf /tmp/luci-indexcache

exit 0