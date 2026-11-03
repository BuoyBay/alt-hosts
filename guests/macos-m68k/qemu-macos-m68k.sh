#!/bin/sh
# 68k Quadra 800 (Mac OS 7.5.3 / 7.6.1) on qemu-system-m68k.
# Flags follow matthewdeaves/QemuMac vms/68k_quadra_800*.
set -eu

media="${MEDIA_DIR:-/media}"
name="${GUEST_NAME:-macos75}"
disk_name="${MACOS_DISK:-macos75.qcow2}"
cdrom_name="${MACOS_CDROM:-}"
rom_name="${MACOS_ROM:-800.ROM}"
pram_name="${MACOS_PRAM:-${name}.pram}"
boot="${MACOS_BOOT:-c}"
mem="${MACOS_MEM:-128}"
cpu="${MACOS_CPU:-m68040}"
display_res="${DISPLAY_RES:-1152x870x8}"
mac_addr="${MACOS_MAC:-08:00:07:12:34:56}"
hd_scsi="${HD_SCSI_ID:-6}"
cd_scsi="${CD_SCSI_ID:-3}"
disk_size="${MACOS_DISK_SIZE:-2G}"

rom="$media/$rom_name"
disk="$media/$disk_name"
pram="$media/$pram_name"

if [ ! -e "$rom" ]; then
    echo "missing Quadra 800 ROM $rom (md5 69489153dde910a69d5ae6de5dd65323)" >&2
    echo "pull-media.sh extracts it from Old_World_Mac_Roms.zip on m4-casa" >&2
    exit 1
fi

if [ ! -e "$disk" ]; then
    echo "creating empty $disk ($disk_size qcow2)" >&2
    qemu-img create -f qcow2 "$disk" "$disk_size" >/dev/null
    boot=d
fi

cdrom=""
if [ -n "$cdrom_name" ] && [ -e "$media/$cdrom_name" ]; then
    cdrom="$media/$cdrom_name"
fi

if [ "$boot" = "d" ] && [ -z "$cdrom" ]; then
    echo "$name has an empty disk and no installer ISO under $media" >&2
    echo "place Apple Legacy Recovery or a 7.5/7.6 CD as $cdrom_name (see guests/macos75/README.md)" >&2
    exit 1
fi

if [ ! -e "$pram" ]; then
    dd if=/dev/zero of="$pram" bs=256 count=1 status=none
fi

if [ "$boot" = "d" ]; then
    scsi_id="$cd_scsi"
else
    scsi_id="$hd_scsi"
fi
# QemuMac set_boot_m68k: RefNum = ~(SCSI_ID + 32) at offset 120.
refnum=$(( ~(scsi_id + 32) & 65535 ))
hi=$(( (refnum >> 8) & 255 ))
lo=$(( refnum & 255 ))
hi_oct=$(printf '%03o' "$hi")
lo_oct=$(printf '%03o' "$lo")
# shellcheck disable=SC2059
printf "\\377\\377\\${hi_oct}\\${lo_oct}" | dd of="$pram" bs=1 seek=120 count=4 conv=notrunc status=none

set -- \
    qemu-system-m68k \
    -name "$name" \
    -M q800,audiodev=audio0 \
    -audiodev none,id=audio0 \
    -cpu "$cpu" \
    -m "$mem" \
    -accel tcg \
    -bios "$rom" \
    -g "$display_res" \
    -display vnc=0.0.0.0:0 \
    -nic "user,model=dp83932,mac=$mac_addr" \
    -drive "file=$pram,format=raw,if=mtd" \
    -drive "file=$disk,format=qcow2,cache=writeback,aio=threads,detect-zeroes=on,if=none,id=hd0" \
    -device "scsi-hd,scsi-id=$hd_scsi,drive=hd0"

if [ -n "$cdrom" ]; then
    set -- "$@" \
        -drive "file=$cdrom,format=raw,cache=writeback,if=none,media=cdrom,id=cd0" \
        -device "scsi-cd,scsi-id=$cd_scsi,drive=cd0"
fi

echo "$name QEMU disk=$disk cdrom=${cdrom:-none} rom=$rom boot=$boot vnc=:0" >&2
exec "$@"
