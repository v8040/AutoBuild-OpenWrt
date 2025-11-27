#!/usr/bin/env bash

mkdir -p files/etc/openclash/core

CORE_VERSION="$(curl -fsSL https://raw.githubusercontent.com/vernesong/OpenClash/core/master/core_version | grep '^[0-9].*')"
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-${1}.tar.gz"
GEOIP_URL='https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat'
GEOSITE_URL='https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat'

curl -fsSL "${CLASH_META_URL}" | tar xOz > files/etc/openclash/core/clash_meta
curl -fsSL "${GEOIP_URL}" > files/etc/openclash/GeoIP.dat
curl -fsSL "${GEOSITE_URL}" > files/etc/openclash/GeoSite.dat

chmod +x files/etc/openclash/core/clash*

printf "\e[32m[SUCCESS]\e[0m \e[37m%s\e[0m\n" "[${0##*/}] done"
exit 0