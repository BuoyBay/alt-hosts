#!/bin/sh
# Windows 95 through 10 on qemu-system-i386 / qemu-system-x86_64.
# 9x/NT4 stay on TCG with era CPUs. 2000 and later use KVM when /dev/kvm
# is readable. Microsoft installers are operator-supplied.
set -eu

media="${MEDIA_DIR:-/media}"
name="${GUEST_NAME:-win95}"
disk_name="${WIN_DISK:-${name}.qcow2}"
cdrom_name="${WIN_CDROM:-}"
floppy_name="${WIN_FLOPPY:-}"
qemu_bin="${WIN_QEMU:-qemu-system-i386}"
cpu="${WIN_CPU:-pentium}"
machine="${WIN_MACHINE:-pc}"
mem="${WIN_MEM:-64}"
smp="${WIN_SMP:-1}"
vga="${WIN_VGA:-cirrus}"
nic="${WIN_NIC:-ne2k_isa}"
sound="${WIN_SOUND:-sb16}"
accel_pref="${WIN_ACCEL:-tcg}"
disk_size="${WIN_DISK_SIZE:-2G}"
mac_addr="${WIN_MAC:-52:54:00:12:95:01}"
rdp_port="${WIN_RDP_PORT:-}"
tablet="${WIN_TABLET:-0}"

disk="$media/$disk_name"

if [ ! -e "$disk" ]; then
    echo "creating empty $disk ($disk_size qcow2); boot from CD/floppy to install" >&2
    qemu-img create -f qcow2 "$disk" "$disk_size" >/dev/null
fi

cdrom=""
if [ -n "$cdrom_name" ] && [ -e "$media/$cdrom_name" ]; then
    cdrom="$media/$cdrom_name"
fi
floppy=""
if [ -n "$floppy_name" ] && [ -e "$media/$floppy_name" ]; then
    floppy="$media/$floppy_name"
fi
if [ -z "$cdrom" ] && [ -z "$floppy" ]; then
    echo "no installer under $media; SeaBIOS until ${cdrom_name:-${name}.iso} is added" >&2
fi

accel=tcg
if [ "$accel_pref" = "kvm" ] || [ "$accel_pref" = "auto" ]; then
    if [ -c /dev/kvm ] && [ -r /dev/kvm ]; then
        accel=kvm
    elif [ "$accel_pref" = "kvm" ]; then
        echo "WIN_ACCEL=kvm but /dev/kvm is unreadable; using tcg" >&2
    fi
fi
if [ "$accel" = "tcg" ] && [ "$cpu" = "host" ]; then
    cpu=qemu64
    echo "WIN_CPU=host needs KVM; using qemu64 under tcg" >&2
fi

case "$machine" in
    *hpet=*) ;;
    *) machine="${machine},hpet=off" ;;
esac
machine="${machine},accel=${accel}"

netdev="user,id=net0"
if [ -n "$rdp_port" ]; then
    netdev="${netdev},hostfwd=tcp::${rdp_port}-:3389"
fi

set -- \
    "$qemu_bin" \
    -name "$name" \
    -machine "$machine" \
    -cpu "$cpu" \
    -smp "$smp" \
    -m "$mem" \
    -vga "$vga" \
    -display vnc=0.0.0.0:0 \
    -rtc base=localtime \
    -boot order=cda,menu=on \
    -audiodev none,id=audio0 \
    -drive "file=$disk,format=qcow2,if=ide,index=0,media=disk,cache=writeback,detect-zeroes=on"

if [ -n "$cdrom" ]; then
    cd_fmt=raw
    case "$cdrom" in
        *.qcow2) cd_fmt=qcow2 ;;
    esac
    set -- "$@" -drive "file=$cdrom,format=$cd_fmt,if=ide,index=1,media=cdrom,readonly=on"
fi
if [ -n "$floppy" ]; then
    set -- "$@" -drive "file=$floppy,format=raw,if=floppy,index=0"
fi

case "$nic" in
    ne2k_isa)
        set -- "$@" -netdev "$netdev" -device "ne2k_isa,netdev=net0,irq=10,mac=$mac_addr"
        ;;
    none|"")
        ;;
    *)
        set -- "$@" -netdev "$netdev" -device "$nic,netdev=net0,mac=$mac_addr"
        ;;
esac

case "$sound" in
    sb16)
        set -- "$@" -device "sb16,audiodev=audio0"
        ;;
    ac97|AC97)
        set -- "$@" -device "AC97,audiodev=audio0"
        ;;
    hda)
        set -- "$@" -device intel-hda -device "hda-duplex,audiodev=audio0"
        ;;
    none|"")
        ;;
    *)
        echo "unknown WIN_SOUND=$sound (sb16|ac97|hda|none)" >&2
        exit 2
        ;;
esac

if [ "$tablet" = "1" ] || [ "$tablet" = "true" ]; then
    set -- "$@" -usb -device usb-tablet
fi

echo "$name QEMU bin=$qemu_bin disk=$disk cdrom=${cdrom:-none} floppy=${floppy:-none} cpu=$cpu machine=$machine accel=$accel vnc=:0" >&2
exec "$@"
