# Mac OS 9.x notes

Work newest-first: **9.2.2**, then 9.2.1 / 9.1 UTM bundles, then 9.0.4.

## QEMU

- Binary: `qemu-system-ppc`
- Machine: `mac99,via=pmu` for 9.1 and 9.2
- 9.0.x: `mac99` without PMU, NewWorld ROM 5.2.1+
- CPU: QemuMac uses `7400_v2.9`; the unnamedd gist uses `g4`
- NIC: `sungem`
- USB: `pci-ohci` + `usb-kbd` / `usb-mouse`
- Display: `-vga std -g 1024x768x32` and VNC

References:

- https://github.com/matthewdeaves/QemuMac (`vms/power_mac_g4_os9`)
- https://gist.github.com/unnamedd/1430410fb329bc3480359ef32e38f94a
- https://wiki.qemu.org/Documentation/Platforms/PowerPC
- https://github.com/erichelgeson/mac-os9-docker (older Ubuntu/QEMU 5.2 image)

Audio needs a Screamer-enabled QEMU build (`mcayland/qemu` `screamer` branch
or QemuMac's Radeon QEMU). Stock Debian `qemu-system-ppc` is enough for
headless build work.

## First install

If `macos9.qcow2` is empty, boot the Universal ISO (`MACOS9_BOOT=d`), run
Drive Setup / Disk Initializer (HFS Extended), then Apple System Restore
from the CD onto the virtual disk. Shut down and boot with `MACOS9_BOOT=c`.
