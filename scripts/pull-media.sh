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
utm91="$downloads/Mac OS 9.1.utm/Data/1F1EC46C-ADFB-4BE4-A541-4FD295FB1767.qcow2"
utm921="$downloads/Mac OS 9.2.1.utm/Images/disk-0.qcow2"

echo "pulling Mac OS 9.x, Quadra ROM, and Haiku disks from $host into $dest" >&2
echo "Mac OS X installer ISOs are not on Depot; copy QemuMac iso/ or operator 10.6 media if present" >&2

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
