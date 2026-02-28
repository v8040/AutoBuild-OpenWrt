#!/usr/bin/env bash

ARCH="${1:-aarch64}"
REPO='v8040/AutoBuild-SmartDNS'
DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/smartdns-${ARCH}"
FILES_DIR='files/usr/sbin'
TARGET_FILE="${FILES_DIR}/smartdns"

mkdir -p "${FILES_DIR}"
curl -fsSLo  "${TARGET_FILE}" "${DOWNLOAD_URL}"

if [ ! -s "${TARGET_FILE}" ]; then
    exit 1
fi

chmod +x "${TARGET_FILE}"

printf '[ \e[32mSUCCESS\e[0m ] %s\n' "[${0##*/}] done"
exit 0