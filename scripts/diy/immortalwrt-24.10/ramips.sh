#!/bin/bash

load_functions() {
  local MAX_PARENT_LEVEL=3
  local FUNCTIONS_FILE=""
  local FUNCTIONS_RESULT=""
  if [[ -v BASH_SOURCE[0] ]]; then
    local SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null)"
    for ((i = 0; i <= MAX_PARENT_LEVEL; i++)); do
      if [[ -f "${SCRIPT_DIR}/functions.sh" ]]; then
        FUNCTIONS_FILE="${SCRIPT_DIR}/functions.sh"
        break
      fi
      SCRIPT_DIR="$(realpath "${SCRIPT_DIR}/.." 2>/dev/null)"
      [[ -d "${SCRIPT_DIR}" ]] || break
    done
  fi
  if [[ -f "${FUNCTIONS_FILE}" ]]; then
    if source "${FUNCTIONS_FILE}" &>/dev/null; then
      FUNCTIONS_RESULT="local: ${FUNCTIONS_FILE}"
    else
      FUNCTIONS_RESULT="error: Failed to load from ${FUNCTIONS_FILE}"
    fi
  else
    local FUNCTIONS_URL='https://sink.v8040v.top/function-openwrt'
    if source <(curl -fsSL "${FUNCTIONS_URL}") &>/dev/null; then
      FUNCTIONS_RESULT="remote: ${FUNCTIONS_URL}"
    else
      FUNCTIONS_RESULT="error: Failed to load from ${FUNCTIONS_URL}"
    fi
  fi
  if [[ "${FUNCTIONS_RESULT}" == error:* ]]; then
    exit 1
  else
    info "${FUNCTIONS_RESULT}" || exit 1
  fi
}

load_functions
info "[$(basename ${0})] init"

# Modify opkg source
echo "src/gz openwrt_kiddin9 https://dl.openwrt.ai/latest/packages/mipsel_24kc/kiddin9" >> package/system/opkg/files/customfeeds.conf

# Add turboacc for firewall4
curl -fsSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh &>/dev/null

sub_name "UPnP IGD 和 PCP" "UPnP设置"
sub_name "Turbo ACC 网络加速" "网络加速"

success
exit 0