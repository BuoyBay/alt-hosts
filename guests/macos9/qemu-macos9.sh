#!/bin/sh
# Back-compat wrapper for the 9.2.2 guest.
export GUEST_NAME="${GUEST_NAME:-macos9}"
export MACOS_DISK="${MACOS_DISK:-${MACOS9_DISK:-macos9.qcow2}}"
export MACOS_CDROM="${MACOS_CDROM:-${MACOS9_CDROM:-macos-922-uni.iso}}"
export MACOS_BOOT="${MACOS_BOOT:-${MACOS9_BOOT:-c}}"
export MACOS_MEM="${MACOS_MEM:-${MACOS9_MEM:-512}}"
export MACOS_CPU="${MACOS_CPU:-${MACOS9_CPU:-7400_v2.9}}"
export MACOS_MACHINE="${MACOS_MACHINE:-${MACOS9_MACHINE:-mac99,via=pmu}}"
export DISPLAY_RES="${DISPLAY_RES:-1024x768x32}"
export MACOS_MAC="${MACOS_MAC:-08:00:07:09:22:01}"
export MACOS_BIOS="${MACOS_BIOS:-${MACOS9_BIOS:-}}"
exec /usr/local/bin/qemu-macos-ppc
