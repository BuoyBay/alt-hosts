#!/bin/sh
# Copy operator-owned guest disks from m4-casa Depot. Apple installers and
# the grok Haiku qcow2 are not published; this host keeps them under media/.
set -eu
root="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
host="${ALT_HOSTS_MEDIA_HOST:-m4-casa}"
dest="${ALT_HOSTS_MEDIA_DIR:-$root/media}"
mkdir -p "$dest"

os9_src="/Volumes/Depot/downloads/qemu-os9"
downloads="/Volumes/Depot/downloads"
haiku_src="/Volumes/Depot/grok/workspace/haiku"
rom_zip="$downloads/Old_World_Mac_Roms.zip"
rom_member="1MB ROMs/1993-02 - F1ACAD13 - Quadra, Centris 610,650,800.ROM"
plus_rom_member="128KB ROMs/1986-03 - 4D1F8172 - MacPlus v3.ROM"
mac128_rom_member="64KB ROMs/1984-01 - 28BA61CE - Macintosh 128.ROM"
ssw608_disk1_url="https://download.info.apple.com/Apple_Support_Area/Apple_Software_Updates/English-North_American/Macintosh/System/Older_System/System_6.0.x/SSW_6.0.8-1.4MB_Disk1of2.sea.bin"
ssw608_disk2_url="https://download.info.apple.com/Apple_Support_Area/Apple_Software_Updates/English-North_American/Macintosh/System/Older_System/System_6.0.x/SSW_6.0.8-1.4MB_Disk2of2.sea.bin"
ua608d_url="https://www.gryphel.com/d/minivmac/extras/ua608d/ua608d-1.00.src.tgz"
utm91="$downloads/Mac OS 9.1.utm/Data/1F1EC46C-ADFB-4BE4-A541-4FD295FB1767.qcow2"
utm921="$downloads/Mac OS 9.2.1.utm/Images/disk-0.qcow2"

echo "pulling Mac OS 9.x, Quadra/Plus/128K ROMs, System 6.0.8, and Haiku disks from $host into $dest" >&2
echo "Mac OS X installer ISOs are not on Depot; copy QemuMac iso/ or operator 10.6 media if present" >&2
echo "Windows 95–10 ISOs are not on Depot; place win95.iso … win10.iso in media/" >&2

rsync -aP --info=progress2 \
    "$host:$os9_src/macos-922-uni.iso" \
    "$host:$os9_src/macos9.qcow2" \
    "$host:$haiku_src/haiku-r1beta6-x86_64.qcow2" \
    "$host:$haiku_src/haiku-r1beta6-x86_64-anyboot.iso" \
    "$dest/"

rsync -aP --info=progress2 \
    "$host:$os9_src/Mac OS 9.0.4.toast" \
    "$dest/macos904.toast"
rsync -aP --info=progress2 \
    "$host:$os9_src/Mac OS ROM" \
    "$dest/macos-rom.bin"
rsync -aP --info=progress2 \
    "$host:$utm921" \
    "$dest/macos921.qcow2"
rsync -aP --info=progress2 \
    "$host:$utm91" \
    "$dest/macos91.qcow2"

if [ ! -f "$dest/800.ROM" ]; then
    echo "extracting Quadra 800 ROM from Old_World_Mac_Roms.zip" >&2
    ssh "$host" "unzip -p \"$rom_zip\" \"$rom_member\"" > "$dest/800.ROM"
fi
rom_md5=$(md5sum "$dest/800.ROM" | awk '{ print $1 }')
if [ "$rom_md5" != "69489153dde910a69d5ae6de5dd65323" ]; then
    echo "800.ROM md5 $rom_md5 does not match QemuMac 69489153dde910a69d5ae6de5dd65323" >&2
    exit 1
fi

if [ ! -f "$dest/vMac.ROM" ]; then
    echo "extracting Macintosh Plus v3 ROM" >&2
    ssh "$host" "unzip -p \"$rom_zip\" \"$plus_rom_member\"" > "$dest/vMac.ROM"
fi
plus_md5=$(md5sum "$dest/vMac.ROM" | awk '{ print $1 }')
if [ "$plus_md5" != "8a41e0754ffd1bb00d8183875c55164c" ]; then
    echo "vMac.ROM md5 $plus_md5 does not match Plus v3 8a41e0754ffd1bb00d8183875c55164c" >&2
    exit 1
fi
if [ ! -f "$dest/Mac128K.ROM" ]; then
    echo "extracting Macintosh 128K ROM" >&2
    ssh "$host" "unzip -p \"$rom_zip\" \"$mac128_rom_member\"" > "$dest/Mac128K.ROM"
fi
mac128_md5=$(md5sum "$dest/Mac128K.ROM" | awk '{ print $1 }')
if [ "$mac128_md5" != "1d7f52d2d490524954f6afce083d9593" ]; then
    echo "Mac128K.ROM md5 $mac128_md5 does not match 1d7f52d2d490524954f6afce083d9593" >&2
    exit 1
fi

ensure_ua608d() {
    ua_bin="${root}/local/ua608d/ua608d"
    if [ -x "$ua_bin" ]; then
        echo "$ua_bin"
        return 0
    fi
    if ! command -v gcc >/dev/null 2>&1; then
        echo "gcc missing; cannot build ua608d to unpack System 6.0.8" >&2
        return 1
    fi
    echo "building ua608d from Gryphel source" >&2
    mkdir -p "${root}/local/ua608d"
    ua_tgz="${root}/local/ua608d/ua608d-1.00.src.tgz"
    curl -fsSL -o "$ua_tgz" "$ua608d_url"
    tar -xzf "$ua_tgz" -C "${root}/local/ua608d"
    gcc -O2 -x c \
        -include stdio.h -include stdlib.h -include string.h -include errno.h \
        -o "$ua_bin" "${root}/local/ua608d/ua608d/source/AAAATOOL.h"
    echo "$ua_bin"
}

unpack_ssw608() {
    sea="$1"
    out="$2"
    expect_sea="$3"
    expect_dsk="$4"
    url="$5"
    if [ -f "$out" ]; then
        return 0
    fi
    if [ ! -f "$sea" ]; then
        echo "downloading Apple System 6.0.8 $(basename "$sea")" >&2
        curl -fsSL -o "$sea" "$url"
    fi
    sea_md5=$(md5sum "$sea" | awk '{ print $1 }')
    if [ "$sea_md5" != "$expect_sea" ]; then
        echo "$(basename "$sea") md5 $sea_md5 does not match $expect_sea" >&2
        exit 1
    fi
    ua_bin=$(ensure_ua608d)
    "$ua_bin" "$sea" "$out"
    dsk_md5=$(md5sum "$out" | awk '{ print $1 }')
    if [ "$dsk_md5" != "$expect_dsk" ]; then
        echo "$(basename "$out") md5 $dsk_md5 does not match $expect_dsk" >&2
        exit 1
    fi
}

unpack_ssw608 \
    "$dest/SSW_6.0.8-1.4MB_Disk1of2.sea.bin" \
    "$dest/macos6.dsk" \
    "f696b2261b222e927b17ed7afb5d7b53" \
    "fe9edabb078a73b6d3f11c35425a7fc5" \
    "$ssw608_disk1_url"
unpack_ssw608 \
    "$dest/SSW_6.0.8-1.4MB_Disk2of2.sea.bin" \
    "$dest/macos6-additions.dsk" \
    "75dd09f521ecfe2f037affbdcf138c85" \
    "fe5bd1240958b35c18bc02c8bed87c73" \
    "$ssw608_disk2_url"

# QemuMac iso-downloader writes these names. Copy if a clone is present.
qemumac_iso="${root}/local/QemuMac/iso"
if [ -f "$qemumac_iso/MacOSX.4.iso" ] && [ ! -f "$dest/macosx104.iso" ]; then
    cp -n "$qemumac_iso/MacOSX.4.iso" "$dest/macosx104.iso"
fi
if [ -f "$qemumac_iso/MacOSXLeopard10.5.iso" ] && [ ! -f "$dest/macosx105.iso" ]; then
    cp -n "$qemumac_iso/MacOSXLeopard10.5.iso" "$dest/macosx105.iso"
fi
# Same files under the original archive.org names.
if [ -f "$qemumac_iso/Mac OS X Leopard Install DVD Version 10.5 (2Z691-6037-A) (Apple, Inc.)(2007).iso" ] && [ ! -f "$dest/macosx105.iso" ]; then
    cp -n "$qemumac_iso/Mac OS X Leopard Install DVD Version 10.5 (2Z691-6037-A) (Apple, Inc.)(2007).iso" "$dest/macosx105.iso"
fi

# OpenCore EFI disk from royalgraphx/LegacyOSXKVM (not Apple OS). Clone first.
legacy_oc="${root}/local/LegacyOSXKVM/opencore/opencore-SLeopard.qcow2"
if [ -f "$legacy_oc" ] && [ ! -f "$dest/macosx106-oc.qcow2" ]; then
    cp -n "$legacy_oc" "$dest/macosx106-oc.qcow2"
fi

haiku_disk="$dest/haiku-r1beta6-x86_64.qcow2"
haiku_iso="$dest/haiku-r1beta6-x86_64-anyboot.iso"
if [ -f "$haiku_disk" ] && [ -f "$haiku_iso" ]; then
    # Overlay was created at /workspace/haiku/... on the grok VM.
    qemu-img rebase -u -b "haiku-r1beta6-x86_64-anyboot.iso" -F raw "$haiku_disk"
fi

ls -lh "$dest"
