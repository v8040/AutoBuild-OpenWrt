#!/usr/bin/env bash

load_functions() {
  local FUNCTIONS_FILE=""
  local FUNCTIONS_RESULT=""
  local FUNCTIONS_URL='https://sink.v8040v.top/function-openwrt'
  local SCRIPT_DIR PARENT_DIR
  if [[ -v BASH_SOURCE[0] ]]; then
    SCRIPT_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null)
    if [[ -d "${SCRIPT_DIR}" ]]; then
      local CURRENT_LEVEL=0
      while : ; do
        if [[ -f "${SCRIPT_DIR}/functions.sh" ]]; then
          FUNCTIONS_FILE=$(realpath "${SCRIPT_DIR}/functions.sh")
          if [[ -e "${FUNCTIONS_FILE}" ]]; then
            if source "${FUNCTIONS_FILE}" &>/dev/null; then
              FUNCTIONS_RESULT="local: [$(basename "${FUNCTIONS_FILE}")]"
              break
            fi
          fi
        fi
        [[ "${SCRIPT_DIR}" == "/" ]] && break
        PARENT_DIR=$(realpath "${SCRIPT_DIR}/.." 2>/dev/null)
        if [[ -z "${PARENT_DIR}" || "${PARENT_DIR}" == "${SCRIPT_DIR}" || ! -d "${PARENT_DIR}" ]]; then
          break
        fi
        SCRIPT_DIR="${PARENT_DIR}"
        (( CURRENT_LEVEL++ >= 10 )) && break
      done
    fi
  fi
  if [[ -z "${FUNCTIONS_RESULT}" ]]; then
    if source <(curl -fsSL "${FUNCTIONS_URL}") &>/dev/null; then
      FUNCTIONS_RESULT="remote: [$(basename "${FUNCTIONS_URL}")]"
    fi
  fi
  if [[ "${FUNCTIONS_RESULT}" =~ ^(local:|remote:) ]]; then
    info "${FUNCTIONS_RESULT}" || exit 1
  else
    exit 1
  fi
}

load_functions
info "[$(basename "${0}")] init"

# Modify opkg source
echo "src/gz openwrt_kiddin9 https://dl.openwrt.ai/latest/packages/aarch64_cortex-a53/kiddin9" >> package/system/opkg/files/customfeeds.conf

rm_pkg "zerotier"

sparse_clone main https://github.com/v8040/openwrt-packages.git zerotier

sub_name "迷你DLNA" "miniDLNA"

success "[$(basename "${0}")] done"
exit 0