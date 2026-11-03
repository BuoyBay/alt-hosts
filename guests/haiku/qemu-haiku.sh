#!/bin/sh
# Haiku R1/beta6 x86_64. Command line follows the grok-bot launcher on
# m4-casa (/Volumes/Depot/grok/workspace/haiku/start-haiku.sh): IDE disk,
# rtl8139 user-net, USB tablet, VNC. KVM is used when /dev/kvm is present
# (this Debian workstation); TCG otherwise.
set -eu

media="${MEDIA_DIR:-/media}"
disk_name="${HAIKU_DISK:-haiku-r1beta6-x86_64.qcow2}"
cdrom_name="${HAIKU_CDROM:-}"
mem="${HAIKU_MEM:-2048}"
smp="${HAIKU_SMP:-2}"
disk="$media/$disk_name"

if [ ! -e "$disk" ]; then
    echo "missing $disk" >&2
    echo "rsync haiku-r1beta6-x86_64.qcow2 into media/ (see docs/media.md)" >&2
    exit 1
fi

accel=tcg
cpu=qemu64
machine="type=pc,accel=tcg"
if [ -c /dev/kvm ] && [ -r /dev/kvm ]; then
    accel=kvm
    cpu=host
    machine="type=pc,accel=kvm"
fi

netdev="user,id=net0"
if [ -n "${HAIKU_SSH_PORT:-}" ]; then
    netdev="$netdev,hostfwd=tcp::${HAIKU_SSH_PORT}-:22"
fi

set -- \
    qemu-system-x86_64 \
    -name haiku-r1beta6 \
    -machine "$machine" \
    -cpu "$cpu" \
    -m "$mem" \
    -smp "$smp" \
    -drive "file=$disk,format=qcow2,if=ide,index=0,media=disk" \
    -netdev "$netdev" \
    -device "rtl8139,netdev=net0" \
    -usb \
    -device usb-tablet \
    -vga std \
    -display vnc=0.0.0.0:0 \
    -serial stdio

if [ -n "$cdrom_name" ] && [ -e "$media/$cdrom_name" ]; then
    set -- "$@" -drive "file=$media/$cdrom_name,format=raw,if=ide,index=1,media=cdrom"
fi

echo "Haiku QEMU disk=$disk accel=$accel vnc=:0" >&2
exec "$@"
