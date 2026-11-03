# Mac OS 9.x notes

Work newest-first: **9.2.2**, then **9.2.1**, **9.1**, then **9.0.4**.

## QEMU

- Binary: `qemu-system-ppc` (`guests/macos-ppc/qemu-macos-ppc.sh`)
- 9.1 / 9.2: `-M mac99,via=pmu` (QemuMac `power_mac_g4_os9`, UTM bundles)
- 9.0.4: `-M mac99` without PMU and OpenBIOS (the Depot `Mac OS ROM` file is a Mac OS ROM suitcase, not a QEMU `-bios` image)
- CPU: `7400_v2.9`
- NIC: `sungem`
- USB: `pci-ohci` + `usb-kbd` / `usb-mouse`
- Display: `-vga std -g 1024x768x32` and VNC

| Service | Disk | CD / ROM | Boot default | Ports |
| --- | --- | --- | --- | --- |
| `macos9` | `macos9.qcow2` | `macos-922-uni.iso` | `c` | 5909 / 6099 |
| `macos921` | `macos921.qcow2` | none | `c` | 5902 / 6092 |
| `macos91` | `macos91.qcow2` | none | `c` | 5901 / 6091 |
| `macos904` | `macos904.qcow2` (created empty) | `macos904.toast` | `d` | 5904 / 6094 |

References:

- https://github.com/matthewdeaves/QemuMac (`vms/power_mac_g4_os9`)
- https://gist.github.com/unnamedd/1430410fb329bc3480359ef32e38f94a
- https://wiki.qemu.org/Documentation/Platforms/PowerPC
- https://github.com/erichelgeson/mac-os9-docker (older Ubuntu/QEMU 5.2 image)

Audio needs a Screamer-enabled QEMU build (`mcayland/qemu` `screamer` branch
or QemuMac's Radeon QEMU). Stock Debian `qemu-system-ppc` is enough for
headless build work.

## First install

9.2.2: if `macos9.qcow2` is empty, boot the Universal ISO (`MACOS9_BOOT=d`),
run Drive Setup / Disk Initializer (HFS Extended), then Apple System Restore
from the CD onto the virtual disk. Shut down and boot with `MACOS9_BOOT=c`.

9.0.4: `macos904` already boots the toast (`MACOS904_BOOT=d`). Initialize the
new qcow2, restore, then set `MACOS904_BOOT=c` in `.env` for later runs.
