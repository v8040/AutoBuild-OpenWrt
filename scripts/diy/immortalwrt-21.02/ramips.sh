#!/bin/bash

load_functions() {
  local MAX_PARENT_LEVEL=3
  local FUNCTIONS_FILE=""
  local FUNCTIONS_RESULT=""

  if [[ -v "BASH_SOURCE[0]" ]]; then
    local SCRIPT_DIR
    SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null)"

    for ((i = 0; i <= MAX_PARENT_LEVEL; i++)); do
      if [[ -f "${SCRIPT_DIR}/functions.sh" ]]; then
        FUNCTIONS_FILE="${SCRIPT_DIR}/functions.sh"
        break
      fi
      SCRIPT_DIR="$(realpath "${SCRIPT_DIR}/.." 2>/dev/null)"
      [[ -d "${SCRIPT_DIR}" ]] || break
    done
  fi

  if [[ -n "${FUNCTIONS_FILE}" ]]; then
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
    echo "${FUNCTIONS_RESULT}" || exit 1
  fi
}

load_functions
info "[${FUNCTIONS_RESULT}]"
info "[$(basename ${0})] init"

# Modify opkg source
echo "src/gz openwrt_kiddin9 https://dl.openwrt.ai/latest/packages/mipsel_24kc/kiddin9" >> package/system/opkg/files/customfeeds.conf

rm_pkg "*ddns-go"
rm_pkg "zerotier"

sparse_clone openwrt-21.02 https://github.com/immortalwrt/luci.git applications/luci-app-ddns-go
sparse_clone openwrt-21.02 https://github.com/immortalwrt/packages.git net/ddns-go
sparse_clone main https://github.com/v8040/openwrt-packages.git zerotier

sub_makefiles "../../luci.mk" "\$(TOPDIR)/feeds/luci/luci.mk"
sub_makefiles "../../lang/golang/golang-package.mk" "\$(TOPDIR)/feeds/packages/lang/golang/golang-package.mk"
sub_makefiles "PKG_SOURCE_URL:=@GHREPO" "PKG_SOURCE_URL:=https://github.com"
sub_makefiles "PKG_SOURCE_URL:=@GHCODELOAD" "PKG_SOURCE_URL:=https://codeload.github.com"

sub_name "DDNS-Go" "DDNSGO"

success
exit 0