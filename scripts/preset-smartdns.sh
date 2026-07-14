#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/functions.sh" &>/dev/null

ARCH="${1:-aarch64}"
REPO='v8040/AutoBuild-SmartDNS'
DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/smartdns-${ARCH}"
FILES_DIR='files/usr/sbin'
TARGET_FILE="${FILES_DIR}/smartdns"

mkdir -p "${FILES_DIR}"
curl -fsSLo  "${TARGET_FILE}" "${DOWNLOAD_URL}"
chmod +x "${TARGET_FILE}"

success "[${0##*/}] done"
exit 0
