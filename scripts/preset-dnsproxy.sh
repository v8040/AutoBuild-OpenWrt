#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/functions.sh" &>/dev/null

ARCH="${1:-arm64}"
REPO='AdguardTeam/dnsproxy'
LATEST_VERSION="$(gh release view --repo "${REPO}" --json tagName -q '.tagName')"
URL="https://github.com/${REPO}/releases/latest/download/dnsproxy-linux-${ARCH}-${LATEST_VERSION}.tar.gz"
curl -fsSL "${URL}" | tar xz
mkdir -p files/usr/bin
mv -f ./linux*/dnsproxy files/usr/bin/dnsproxy
chmod +x files/usr/bin/dnsproxy

mkdir -p files/etc/init.d
cat << 'EOF' > files/etc/init.d/dnsproxy
#!/bin/sh /etc/rc.common

USE_PROCD=1
START=99

PROG='/usr/bin/dnsproxy'
CONF='/etc/dnsproxy/config.yaml'

start_service() {
    procd_open_instance
    if [ -f "${CONF}" ]; then
        procd_set_param command "${PROG}" --config-path="${CONF}"
    else
        procd_set_param command "${PROG}" \
            -l 127.0.0.1 \
            -p 5353 \
            -u quic://223.5.5.5 \
            -f https://1.12.12.12/dns-query \
            --refuse-any \
            --cache \
            --cache-optimistic
        logger -t dnsproxy -s "Warning: Config ${CONF} not found. Using built-in defaults."
    fi
    procd_set_param respawn
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_close_instance
}
EOF
chmod +x files/etc/init.d/dnsproxy

success "[${0##*/}] done"
exit 0
