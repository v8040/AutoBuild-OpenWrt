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

# Remove packages
rm_pkg "*adguardhome"
rm_pkg "*advanced"
rm_pkg "*alist"
rm_pkg "*amlogic"
rm_pkg "*argon-config"
rm_pkg "*bypass"
rm_pkg "*ddns-go"
rm_pkg "*ddnsto"
rm_pkg "*dockerman"
rm_pkg "*mosdns"
rm_pkg "*netdata"
rm_pkg "*netspeedtest"
rm_pkg "*nlbwmon*"
rm_pkg "*onliner"
rm_pkg "*openclash"
rm_pkg "*partexp"
rm_pkg "*passwall"
rm_pkg "*pushbot"
rm_pkg "*qbittorrent*"
rm_pkg "*shadowsocks*"
rm_pkg "*smartdns"
rm_pkg "*sqm*"
rm_pkg "*ssr*"
rm_pkg "*taskplan"
rm_pkg "*theme-argon"
rm_pkg "*transmission*"
rm_pkg "*trojan*"
rm_pkg "*v2ray*"
rm_pkg "*wechatpush"
rm_pkg "*xray*"
rm_pkg "dnsproxy"
rm_pkg "minidlna"
rm_pkg "miniupnpc"
rm_pkg "miniupnpd"

# Add packages
git clone -q --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
git clone -q --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone -q --depth=1 https://github.com/sbwml/luci-app-alist.git package/alist
git clone -q --depth=1 https://github.com/sbwml/luci-app-mosdns.git package/mosdns
git clone -q --depth=1 https://github.com/sbwml/v2ray-geodata.git package/v2ray-geodata
git clone -q --depth=1 https://github.com/sirpdboy/luci-app-advanced.git package/luci-app-advanced
git clone -q --depth=1 https://github.com/sirpdboy/luci-app-partexp.git package/luci-app-partexp
git clone -q --depth=1 https://github.com/sirpdboy/luci-app-taskplan.git package/luci-app-taskplan
git clone -q --depth=1 https://github.com/sirpdboy/netspeedtest.git package/luci-app-netspeedtest
git clone -q --depth=1 https://github.com/zzsj0928/luci-app-pushbot.git package/luci-app-pushbot

sparse_clone main https://github.com/kiddin9/kwrt-packages.git luci-app-control-timewol
sparse_clone main https://github.com/kiddin9/kwrt-packages.git luci-app-onliner
sparse_clone main https://github.com/linkease/nas-packages-luci.git luci/luci-app-ddnsto
sparse_clone main https://github.com/ophub/luci-app-amlogic.git luci-app-amlogic
sparse_clone master https://github.com/linkease/nas-packages.git network/services/ddnsto
sparse_clone master https://github.com/vernesong/OpenClash.git luci-app-openclash

sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-ddns-go
sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-dockerman
sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-minidlna
sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-smartdns
sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-sqm
sparse_clone master https://github.com/immortalwrt/packages.git multimedia/minidlna
sparse_clone master https://github.com/immortalwrt/packages.git net/ddns-go
sparse_clone master https://github.com/immortalwrt/packages.git net/miniupnpc
sparse_clone master https://github.com/immortalwrt/packages.git net/miniupnpd
sparse_clone master https://github.com/immortalwrt/packages.git net/smartdns
sparse_clone master https://github.com/immortalwrt/packages.git net/sqm-scripts

# Requires golang latest version
rm -rf feeds/packages/lang/golang
git clone -q --depth=1 https://github.com/sbwml/packages_lang_golang.git feeds/packages/lang/golang

# Change default theme background
[[ -f "${GITHUB_WORKSPACE}/images/bg1.jpg" ]] && cp -f ${GITHUB_WORKSPACE}/images/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# Samba root restriction removal
sub_file "invalid users = root" "#&" "feeds/packages/net/samba4/files/smb.conf.template"

# Modify ttyd auto login
sub_file "/bin/login" "/usr/libexec/login.sh" "feeds/packages/utils/ttyd/files/ttyd.config"

# Modify amlogic
sub_file "amlogic_firmware_repo.*" "amlogic_firmware_repo 'https://github.com/v8040/AutoBuild-OpenWrt'" "package/luci-app-amlogic/root/etc/config/amlogic"
sub_file "amlogic_kernel_path.*" "amlogic_kernel_path 'https://github.com/ophub/kernel'" "package/luci-app-amlogic/root/etc/config/amlogic"

# Modify makefiles
sub_makefiles "../../luci.mk" "\$(TOPDIR)/feeds/luci/luci.mk"
sub_makefiles "../../lang/golang/golang-package.mk" "\$(TOPDIR)/feeds/packages/lang/golang/golang-package.mk"
sub_makefiles "PKG_SOURCE_URL:=@GHREPO" "PKG_SOURCE_URL:=https://github.com"
sub_makefiles "PKG_SOURCE_URL:=@GHCODELOAD" "PKG_SOURCE_URL:=https://codeload.github.com"

# Adjust menu
sub_file "services" "control" "feeds/luci/applications/luci-app-eqos/root/usr/share/luci/menu.d/*.json"
sub_file "services" "control" "feeds/luci/applications/luci-app-nft-qos/luasrc/controller/*.lua"
sub_file "services" "nas" "feeds/luci/applications/luci-app-ksmbd/root/usr/share/luci/menu.d/*.json"
sub_file "services" "vpn" "package/luci-app-openclash/luasrc/controller/*.lua"
sub_file "services" "vpn" "package/luci-app-openclash/luasrc/model/cbi/openclash/*.lua"
sub_file "services" "vpn" "package/luci-app-openclash/luasrc/view/openclash/*.htm"
sub_file "admin/network" "admin/control" "package/luci-app-sqm/root/usr/share/luci/menu.d/*.json"

# Modify default IP and hostname
sub_file "192\.168\.[0-9]*\.[0-9]*" "${OPENWRT_IP}" "feeds/luci/modules/luci-mod-system/htdocs/luci-static/resources/view/system/flash.js"
sub_file "192\.168\.[0-9]*\.[0-9]*" "${OPENWRT_IP}" "package/base-files/files/bin/config_generate"
sub_file "hostname='.*'" "hostname='OpenWrt'" "package/base-files/files/bin/config_generate"
sub_file "OPENWRT_RELEASE=\"[^\"]*\"" "OPENWRT_RELEASE=\"OpenWrt\"" "package/base-files/files/usr/lib/os-release"
sub_file "DISTRIB_RELEASE='[^']*'" "DISTRIB_RELEASE='OpenWrt'" "package/base-files/files/etc/openwrt_release"
sub_file "DISTRIB_DESCRIPTION='[^']*'" "DISTRIB_DESCRIPTION='OpenWrt'" "package/base-files/files/etc/openwrt_release"
sub_file "DISTRIB_REVISION='[^']*'" "DISTRIB_REVISION='R$(TZ=UTC-8 date '+%-m.%-d')'" "package/base-files/files/etc/openwrt_release"

# Modify plugin names
sub_name "Argon 主题设置" "主题设置"
sub_name "DDNS-Go" "DDNSGO"
sub_name "DDNSTO 远程控制" "DDNSTO"
sub_name "KMS 服务器" "KMS激活"
sub_name "QoS Nftables 版" "QoS管理"
sub_name "SQM 队列管理" "SQM管理"
sub_name "动态 DNS" "动态DNS"
sub_name "网络存储" "NAS"
sub_name "解除网易云音乐播放限制" "音乐解锁"

success
exit 0