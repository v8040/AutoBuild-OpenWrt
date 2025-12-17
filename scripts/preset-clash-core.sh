#!/usr/bin/env bash

ARCH="${1:-arm64}"
VERSION="${2:-meta}"
CORE_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/${VERSION}/clash-linux-${ARCH}.tar.gz"
GEODATA_URL='https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest'
MODEL_URL='https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/Model-large.bin'

mkdir -p files/etc/openclash/core

curl -fsSL "${CORE_URL}" | tar xOz > files/etc/openclash/core/clash_meta
curl -fsSL "${MODEL_URL}" > files/etc/openclash/Model.bin
curl -fsSL "${GEODATA_URL}/geoip.dat" > files/etc/openclash/GeoIP.dat
curl -fsSL "${GEODATA_URL}/geosite.dat" > files/etc/openclash/GeoSite.dat

chmod +x files/etc/openclash/core/clash*

printf '[ \e[32mSUCCESS\e[0m ] %s\n' "[${0##*/}] done"
exit 0