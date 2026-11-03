#!/bin/sh
# Intel Mac OS X (Snow Leopard 10.6) on qemu-system-x86_64.
# Flags follow royalgraphx/LegacyOSXKVM SLeopard-Boot.sh plus OSX-KVM
# pflash OVMF and e1000-82545em. OpenCore is operator-supplied.
set -eu

media="${MEDIA_DIR:-/media}"
name="${GUEST_NAME:-macosx106}"
disk_name="${MACOS_DISK:-macosx106.qcow2}"
oc_name="${MACOS_OC:-macosx106-oc.qcow2}"
cdrom_name="${MACOS_CDROM:-}"
installer_name="${MACOS_INSTALLER:-}"
ovmf_code="${OVMF_CODE:-/usr/share/OVMF/OVMF_CODE_4M.fd}"
ovmf_vars_src="${OVMF_VARS_SRC:-/usr/share/OVMF/OVMF_VARS_4M.fd}"
vars_name="${MACOS_VARS:-${name}-vars.fd}"
mem="${MACOS_MEM:-2048}"
smp="${MACOS_SMP:-1}"
cpu="${MACOS_CPU:-Penryn,vendor=GenuineIntel,+sse4.1,+sse4.2,+ssse3}"
machine="${MACOS_MACHINE:-pc-q35-6.1,vmport=off}"
mac_addr="${MACOS_MAC:-08:00:07:10:06:01}"
ssh_port="${MACOS_SSH_PORT:-}"
disk_size="${MACOS_DISK_SIZE:-16G}"
# Standard isa-applesmc value used by OSX-KVM and LegacyOSXKVM.
osk="${MACOS_OSK:-ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc}"

disk="$media/$disk_name"
oc="$media/$oc_name"
vars="$media/$vars_name"

if [ ! -e "$oc" ]; then
    echo "missing OpenCore disk $oc" >&2
    echo "run scripts/bootstrap-legacyosxkvm.sh then scripts/pull-media.sh" >&2
    exit 1
fi
if [ ! -e "$ovmf_code" ]; then
    echo "missing OVMF $ovmf_code (install ovmf in the guest image)" >&2
    exit 1
fi
if [ ! -e "$vars" ]; then
    if [ ! -e "$ovmf_vars_src" ]; then
        echo "missing OVMF VARS template $ovmf_vars_src" >&2
        exit 1
    fi
    cp "$ovmf_vars_src" "$vars"
fi
if [ ! -e "$disk" ]; then
    echo "creating empty $disk ($disk_size qcow2)" >&2
    qemu-img create -f qcow2 "$disk" "$disk_size" >/dev/null
fi

cdrom=""
if [ -n "$cdrom_name" ] && [ -e "$media/$cdrom_name" ]; then
    cdrom="$media/$cdrom_name"
fi
installer=""
if [ -n "$installer_name" ] && [ -e "$media/$installer_name" ]; then
    installer="$media/$installer_name"
fi

accel=tcg
if [ -c /dev/kvm ] && [ -r /dev/kvm ]; then
    accel=kvm
fi

netdev="user,id=net0"
if [ -n "$ssh_port" ]; then
    netdev="${netdev},hostfwd=tcp::${ssh_port}-:22"
fi

set -- \
    qemu-system-x86_64 \
    -name "$name" \
    -machine "$machine,accel=$accel" \
    -cpu "$cpu" \
    -smp "$smp" \
    -m "$mem" \
    -global ICH9-LPC.disable_s3=1 \
    -drive "if=pflash,format=raw,readonly=on,file=$ovmf_code" \
    -drive "if=pflash,format=raw,file=$vars" \
    -device "isa-applesmc,osk=$osk" \
    -vga none \
    -device vmware-svga \
    -display vnc=0.0.0.0:0 \
    -usb \
    -device usb-kbd \
    -device usb-tablet \
    -netdev "$netdev" \
    -device "e1000-82545em,netdev=net0,mac=$mac_addr" \
    -drive "if=none,media=disk,id=OpenCore,file=$oc,discard=unmap,detect-zeroes=on" \
    -device "ide-hd,bus=ide.0,drive=OpenCore,bootindex=0" \
    -drive "if=none,format=qcow2,media=disk,id=HardDrives,file=$disk,cache=writeback,discard=unmap,detect-zeroes=on" \
    -device "ide-hd,bus=ide.2,drive=HardDrives,bootindex=2"

if [ -n "$installer" ]; then
    set -- "$@" \
        -drive "if=none,media=disk,id=OSXInstaller,file=$installer,discard=unmap,detect-zeroes=on" \
        -device "ide-hd,bus=ide.1,drive=OSXInstaller,bootindex=1"
elif [ -n "$cdrom" ]; then
    set -- "$@" \
        -drive "if=none,format=raw,media=cdrom,id=OSXInstaller,file=$cdrom" \
        -device "ide-cd,bus=ide.1,drive=OSXInstaller,bootindex=1"
fi

echo "$name QEMU disk=$disk oc=$oc cdrom=${cdrom:-none} installer=${installer:-none} accel=$accel vnc=:0" >&2
exec "$@"
