#!/usr/bin/env bash

ARCH="${1:-arm64}"
REPO='AdguardTeam/dnsproxy'
LATEST_VERSION="$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)"
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

printf '[ \e[32mSUCCESS\e[0m ] %s\n' "[${0##*/}] done"
exit 0