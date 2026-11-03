#!/bin/sh
# PowerPC Mac OS 9.x and Mac OS X (Tiger / Leopard) on qemu-system-ppc.
# 9.1/9.2 and OS X: -M mac99,via=pmu (QemuMac power_mac_g4_*).
# 9.0.4:            -M mac99 without PMU (QEMU wiki).
set -eu

media="${MEDIA_DIR:-/media}"
name="${GUEST_NAME:-macos9}"
disk_name="${MACOS_DISK:-macos9.qcow2}"
cdrom_name="${MACOS_CDROM:-}"
bios_name="${MACOS_BIOS:-}"
boot="${MACOS_BOOT:-c}"
mem="${MACOS_MEM:-512}"
cpu="${MACOS_CPU:-7400_v2.9}"
machine="${MACOS_MACHINE:-mac99,via=pmu}"
display_res="${DISPLAY_RES:-1024x768x32}"
mac_addr="${MACOS_MAC:-08:00:07:09:22:01}"
disk_size="${MACOS_DISK_SIZE:-10G}"
ssh_port="${MACOS_SSH_PORT:-}"

disk="$media/$disk_name"
cdrom=""
if [ -n "$cdrom_name" ] && [ -e "$media/$cdrom_name" ]; then
    cdrom="$media/$cdrom_name"
fi
bios=""
if [ -n "$bios_name" ] && [ -e "$media/$bios_name" ]; then
    bios="$media/$bios_name"
fi

if [ ! -e "$disk" ]; then
    echo "creating empty $disk ($disk_size qcow2); boot from CD to install" >&2
    qemu-img create -f qcow2 "$disk" "$disk_size" >/dev/null
    if [ -z "$cdrom" ]; then
        echo "no $disk_name or $cdrom_name under $media" >&2
        echo "see docs/media.md" >&2
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
    -name "$name" \
    -M "$machine" \
    -cpu "$cpu" \
    -m "$mem" \
    -accel tcg \
    -vga std \
    -g "$display_res" \
    -display vnc=0.0.0.0:0
if [ -n "$bios" ]; then
    set -- "$@" -bios "$bios"
fi

netdev="user,id=net0,hostfwd=tcp::548-:548"
if [ -n "$ssh_port" ]; then
    netdev="${netdev},hostfwd=tcp::${ssh_port}-:22"
fi

set -- "$@" \
    -prom-env "auto-boot?=true" \
    -prom-env "boot-args=-v" \
    -prom-env "vga-ndrv?=true" \
    -netdev "$netdev" \
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

echo "$name QEMU disk=$disk cdrom=${cdrom:-none} bios=${bios:-openbios} machine=$machine boot=$boot ssh=${ssh_port:-none} vnc=:0" >&2
exec "$@"
