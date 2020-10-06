#!/usr/bin/env bash

# print version and exit if wireguard module is already loaded
if lsmod | grep wireguard >/dev/null 2>&1
then
	echo -n "wireguard version: "
	cat /sys/module/wireguard/version
	exit 0
fi

set -ex

# read the current device type and version from balena env vars
BALENA_MACHINE_NAME="${BALENA_DEVICE_TYPE}"
# assume prod but allow override 
VERSION="$(echo "${BALENA_HOST_OS_VERSION}" | awk '{print $2}').${BALENA_HOST_OS_MODE:-prod}"

# install required compile tools
# https://www.balena.io/blog/how-to-run-wireguard-vpn-in-balenaos/
apt-get update
apt-get install -y --no-install-recommends curl build-essential libelf-dev libssl-dev pkg-config git flex bison bc python kmod
apt-get clean
rm -rf /var/lib/apt/lists/*

# recreate working directory
rm -rf /usr/src || true
mkdir -p /usr/src

(cd /usr/src || exit 1

# download kernel sources from balena
curl -L "https://files.balena-cloud.com/images/${BALENA_MACHINE_NAME}/${VERSION/+/%2B}/kernel_modules_headers.tar.gz" -O
tar xzf kernel_modules_headers.tar.gz

# compile wireguard.ko
make -C kernel_modules_headers -j"$(nproc)" modules_prepare

# compile wireguard tools
make -C kernel_modules_headers M=/app/wireguard-linux-compat/src -j"$(nproc)"

# modprobe dependencies
modprobe udp_tunnel
modprobe ip6_udp_tunnel

# dump module info to logs
modinfo "/app/wireguard-linux-compat/src/wireguard.ko"

# insert wireguard module and dump dmesg if it fails
if ! insmod "/app/wireguard-linux-compat/src/wireguard.ko"
then
	dmesg | grep wireguard
	sleep infinity
fi
)
