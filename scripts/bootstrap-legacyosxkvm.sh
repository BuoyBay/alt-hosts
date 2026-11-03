#!/bin/sh
# Clone royalgraphx/LegacyOSXKVM for OpenCore disks used by Intel OS X
# guests (Snow Leopard). The clone stays under local/ and is not vendored.
set -eu
root="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
dest="${1:-$root/local/LegacyOSXKVM}"
url="${LEGACYOSXKVM_URL:-https://github.com/royalgraphx/LegacyOSXKVM.git}"
mkdir -p "$(dirname "$dest")"
if [ -d "$dest/.git" ]; then
    git -C "$dest" pull --ff-only
else
    git clone --depth 1 "$url" "$dest"
fi
echo "LegacyOSXKVM at $dest. OpenCore: $dest/opencore/opencore-SLeopard.qcow2"
echo "copy into media/ with ./scripts/pull-media.sh"
