#!/bin/sh
# Clone matthewdeaves/QemuMac for native (non-Docker) Classic Mac launches.
# QemuMac is GPL-2.0-only; it stays under local/ and is not vendored.
set -eu
root="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
dest="${1:-$root/local/QemuMac}"
url="${QEMUMAC_URL:-https://github.com/matthewdeaves/QemuMac.git}"
mkdir -p "$(dirname "$dest")"
if [ -d "$dest/.git" ]; then
    git -C "$dest" pull --ff-only
else
    git clone --depth 1 "$url" "$dest"
fi
echo "QemuMac at $dest (GPL-2.0-only). OS 9 VM: $dest/vms/power_mac_g4_os9/"
