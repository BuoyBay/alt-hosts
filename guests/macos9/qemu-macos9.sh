#!/bin/sh
# Mac OS 9.2.2 on QEMU PowerMac G4 (mac99 + PMU).
# Flags follow matthewdeaves/QemuMac power_mac_g4_os9 and the
# unnamedd OS 9 gist (cpu/machine/display). Apple media is bind-mounted
# at /media; this script never downloads it.
set -eu

media="${MEDIA_DIR:-/media}"
disk_name="${MACOS9_DISK:-macos9.qcow2}"
cdrom_name="${MACOS9_CDROM:-macos-922-uni.iso}"
boot="${MACOS9_BOOT:-c}"
mem="${MACOS9_MEM:-512}"
cpu="${MACOS9_CPU:-7400_v2.9}"
machine="${MACOS9_MACHINE:-mac99,via=pmu}"
display_res="${DISPLAY_RES:-1024x768x32}"
mac_addr="${MACOS9_MAC:-08:00:07:09:22:01}"

disk="$media/$disk_name"
cdrom=""
if [ -n "$cdrom_name" ] && [ -e "$media/$cdrom_name" ]; then
    cdrom="$media/$cdrom_name"
fi

if [ ! -e "$disk" ]; then
    echo "creating empty $disk (10G qcow2); boot from CD to install" >&2
    qemu-img create -f qcow2 "$disk" 10G >/dev/null
    if [ -z "$cdrom" ]; then
        echo "no $disk_name or $cdrom_name under $media" >&2
        echo "copy macos9.qcow2 and macos-922-uni.iso into media/ (see docs/media.md)" >&2
        exit 1
    fi
    boot=d
fi

hd_i=1
cd_i=2
if [ "$boot" = "d" ]; then
    hd_i=2
    cd_i=1
fi

set -- \
    qemu-system-ppc \
    -name macos9 \
    -M "$machine" \
    -cpu "$cpu" \
    -m "$mem" \
    -accel tcg \
    -vga std \
    -g "$display_res" \
    -display vnc=0.0.0.0:0 \
    -prom-env "auto-boot?=true" \
    -prom-env "boot-args=-v" \
    -prom-env "vga-ndrv?=true" \
    -netdev "user,id=net0,hostfwd=tcp::548-:548" \
    -device "sungem,netdev=net0,mac=$mac_addr" \
    -device "pci-ohci,id=ohci" \
    -device "usb-mouse,bus=ohci.0" \
    -device "usb-kbd,bus=ohci.0" \
    -drive "file=$disk,format=qcow2,cache=writeback,aio=threads,detect-zeroes=on,if=none,id=hd0" \
    -device "ide-hd,bus=ide.0,unit=0,drive=hd0,bootindex=$hd_i"

if [ -n "$cdrom" ]; then
    set -- "$@" \
        -drive "file=$cdrom,format=raw,cache=writeback,if=none,id=cd0,media=cdrom" \
        -device "ide-cd,bus=ide.0,unit=1,drive=cd0,bootindex=$cd_i"
fi

echo "Mac OS 9 QEMU disk=$disk cdrom=${cdrom:-none} boot=$boot vnc=:0" >&2
exec "$@"
