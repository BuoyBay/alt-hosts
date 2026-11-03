#!/bin/sh
# Macintosh System 1–6 on Mini vMac (stock QEMU has no Mac 128K/Plus).
# Xvfb + x11vnc feed the same noVNC port as the QEMU guests.
set -eu

media="${MEDIA_DIR:-/media}"
name="${GUEST_NAME:-macos6}"
model="${MACOS_MVM_MODEL:-plus}"
rom_name="${MACOS_ROM:-vMac.ROM}"
disk_name="${MACOS_DISK:-}"
disk2_name="${MACOS_DISK2:-}"
display="${MVMAC_DISPLAY:-:99}"
screen="${MVMAC_SCREEN:-1024x684x24}"

bin=/usr/local/bin/minivmac-plus
if [ "$model" = "128k" ]; then
    bin=/usr/local/bin/minivmac-128k
fi
if [ ! -x "$bin" ]; then
    echo "missing Mini vMac $bin" >&2
    exit 1
fi

rom="$media/$rom_name"
if [ ! -e "$rom" ]; then
    echo "missing Macintosh ROM $rom" >&2
    echo "run scripts/pull-media.sh (Plus v3 and 128K ROMs from Old_World_Mac_Roms.zip)" >&2
    exit 1
fi

disk=""
if [ -n "$disk_name" ] && [ -e "$media/$disk_name" ]; then
    disk="$media/$disk_name"
fi
disk2=""
if [ -n "$disk2_name" ] && [ -e "$media/$disk2_name" ]; then
    disk2="$media/$disk2_name"
fi

Xvfb "$display" -screen 0 "$screen" -ac >/tmp/xvfb.log 2>&1 &
xvfb_pid=$!
sleep 0.4
if ! kill -0 "$xvfb_pid" 2>/dev/null; then
    echo "Xvfb failed:" >&2
    cat /tmp/xvfb.log >&2 || true
    exit 1
fi

export DISPLAY="$display"
set -- "$bin" -r "$rom"
if [ -n "$disk" ]; then
    set -- "$@" "$disk"
fi
if [ -n "$disk2" ]; then
    set -- "$@" "$disk2"
fi
"$@" >/tmp/minivmac.log 2>&1 &
mac_pid=$!
sleep 0.6
if ! kill -0 "$mac_pid" 2>/dev/null; then
    echo "Mini vMac exited:" >&2
    cat /tmp/minivmac.log >&2 || true
    kill "$xvfb_pid" 2>/dev/null || true
    exit 1
fi

x11vnc -display "$display" -rfbport 5900 -forever -shared -nopw -noxdamage -repeat -quiet >/tmp/x11vnc.log 2>&1 &
vnc_pid=$!
sleep 0.3
if ! kill -0 "$vnc_pid" 2>/dev/null; then
    echo "x11vnc failed:" >&2
    cat /tmp/x11vnc.log >&2 || true
    kill "$mac_pid" "$xvfb_pid" 2>/dev/null || true
    exit 1
fi

term() {
    kill -TERM "$mac_pid" "$vnc_pid" "$xvfb_pid" 2>/dev/null || true
    wait "$mac_pid" 2>/dev/null || true
}
trap term EXIT INT TERM

echo "$name Mini vMac model=$model rom=$rom disk=${disk:-none} disk2=${disk2:-none} vnc=:0" >&2
if [ -z "$disk" ]; then
    echo "no boot disk under $media; blinking floppy until ${disk_name:-macosN.dsk} is added" >&2
fi
wait "$mac_pid"
