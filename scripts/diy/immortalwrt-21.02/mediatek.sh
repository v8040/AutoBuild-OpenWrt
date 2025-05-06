#!/bin/bash

MAX_PARENT_LEVEL=3
if [[ -v "BASH_SOURCE[0]" ]]; then
  SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null)"
  FUNCTIONS_FILE=""
  for ((i = 0; i <= MAX_PARENT_LEVEL; i++)); do
    if [[ -f "${SCRIPT_DIR}/functions.sh" ]]; then
      FUNCTIONS_FILE="${SCRIPT_DIR}/functions.sh"
      break
    fi
    SCRIPT_DIR="$(realpath "${SCRIPT_DIR}/.." 2>/dev/null)"
    if [[ ! -d "$SCRIPT_DIR" ]]; then
      break
    fi
  done
else
  FUNCTIONS_FILE=""
fi

FUNCTIONS_URL='https://sink.v8040v.top/function-openwrt'
if ! [[ -z "${FUNCTIONS_FILE}" ]]; then
  source "${FUNCTIONS_FILE}" || {
    echo "Error: Failed to load local functions.sh" >&2
    exit 1
  }
else
  source <(curl -fsSL ${FUNCTIONS_URL}) || {
    echo "Error: Failed to load remote functions.sh" >&2
    exit 1
  }
fi

TARGET_DIR="${OPENWRT_PATH}"
WORK_DIR="${PWD}"
if [ "${WORK_DIR}" != "${TARGET_DIR}" ]; then
  error "This script must be executed in the '${TARGET_DIR}' directory !"
fi

info "[$(basename ${0})]"

# 修改opkg源
echo "src/gz openwrt_kiddin9 https://dl.openwrt.ai/latest/packages/aarch64_cortex-a53/kiddin9" >> package/system/opkg/files/customfeeds.conf

rm_pkg "zerotier"

sparse_clone main https://github.com/v8040/openwrt-packages.git zerotier

sub_file "services" "control" "package/mtk/applications/luci-app-eqos-mtk/root/usr/share/luci/menu.d/*.json"

success