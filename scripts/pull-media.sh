#!/bin/sh
# Copy operator-owned guest disks from m4-casa Depot. Apple installers and
# the grok Haiku qcow2 are not published; this host keeps them under media/.
set -eu
root="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
host="${ALT_HOSTS_MEDIA_HOST:-m4-casa}"
dest="${ALT_HOSTS_MEDIA_DIR:-$root/media}"
mkdir -p "$dest"

os9_src="/Volumes/Depot/downloads/qemu-os9"
haiku_src="/Volumes/Depot/grok/workspace/haiku"

echo "pulling Mac OS 9.2.2 and Haiku disks from $host into $dest" >&2
# The grok qcow2 is an overlay on the anyboot ISO; both files are required.
rsync -aP --info=progress2 \
    "$host:$os9_src/macos-922-uni.iso" \
    "$host:$os9_src/macos9.qcow2" \
    "$host:$haiku_src/haiku-r1beta6-x86_64.qcow2" \
    "$host:$haiku_src/haiku-r1beta6-x86_64-anyboot.iso" \
    "$dest/"

haiku_disk="$dest/haiku-r1beta6-x86_64.qcow2"
haiku_iso="$dest/haiku-r1beta6-x86_64-anyboot.iso"
if [ -f "$haiku_disk" ] && [ -f "$haiku_iso" ]; then
    # Overlay was created at /workspace/haiku/... on the grok VM.
    qemu-img rebase -u -b "haiku-r1beta6-x86_64-anyboot.iso" -F raw "$haiku_disk"
fi

# Optional extras (9.0.4 toast, NewWorld ROM) stay on Depot unless asked.
if [ "${ALT_HOSTS_PULL_EXTRAS:-0}" = "1" ]; then
    rsync -aP --info=progress2 \
        "$host:$os9_src/Mac OS 9.0.4.toast" \
        "$host:$os9_src/Mac OS ROM" \
        "$dest/"
fi

ls -lh "$dest"
