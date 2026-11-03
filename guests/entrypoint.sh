#!/bin/sh
set -eu

guest="${1:-macos9}"
if [ "$#" -gt 0 ]; then
    shift
fi

novnc_root=/usr/share/novnc
if [ ! -d "$novnc_root" ]; then
    echo "novnc files missing under $novnc_root" >&2
    exit 1
fi

# Bind noVNC to all interfaces so published Docker ports work. Stay PID 1
# so SIGTERM reaches QEMU through this shell.
websockify --web "$novnc_root" 0.0.0.0:6080 127.0.0.1:5900 &
novnc_pid=$!
qemu_pid=""
term() {
    if [ -n "$qemu_pid" ]; then
        kill -TERM "$qemu_pid" 2>/dev/null || true
        wait "$qemu_pid" 2>/dev/null || true
    fi
    kill "$novnc_pid" 2>/dev/null || true
}
trap term EXIT INT TERM

case "$guest" in
    macos9|os9|classic)
        /usr/local/bin/qemu-macos9 "$@" &
        qemu_pid=$!
        ;;
    macos921|macos91|macos904)
        export GUEST_NAME="${GUEST_NAME:-$guest}"
        /usr/local/bin/qemu-macos-ppc "$@" &
        qemu_pid=$!
        ;;
    macos75|os75|macos76|os76)
        export GUEST_NAME="${GUEST_NAME:-$guest}"
        /usr/local/bin/qemu-macos-m68k "$@" &
        qemu_pid=$!
        ;;
    haiku)
        /usr/local/bin/qemu-haiku "$@" &
        qemu_pid=$!
        ;;
    *)
        echo "unknown guest: $guest (macos9|macos921|macos91|macos904|macos76|macos75|haiku)" >&2
        exit 2
        ;;
esac

wait "$qemu_pid"
