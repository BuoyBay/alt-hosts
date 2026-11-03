# Mac OS X notes (PowerPC)

QemuMac ships two PowerPC OS X guests. This repo wraps the same flags in
Docker. The Radeon 9700 Tiger 3D VM stays native QemuMac; stock Debian
`qemu-system-ppc` has no Radeon device.

| Service | OS | QemuMac VM | Ports |
| --- | --- | --- | --- |
| `macosx105` | 10.5.6 Leopard | `power_mac_g4_leopard` | VNC 5907, noVNC 6097, SSH 2215 |
| `macosx104` | 10.4 Tiger | `power_mac_g4_tiger` | VNC 5903, noVNC 6093, SSH 2214 |

## QEMU

- Binary: `qemu-system-ppc` (`guests/macos-ppc/qemu-macos-ppc.sh`)
- Machine: `mac99,via=pmu`
- CPU: `7400_v2.9`, 2048 MiB
- NIC: `sungem`, USB `pci-ohci`
- SSH: container `2222` → guest `22` (turn on Remote Login after install)

## Installers

QemuMac `iso/software-database.json`:

| Guest | File | md5 | QemuMac key |
| --- | --- | --- | --- |
| Tiger | `macosx104.iso` (`MacOSX.4.iso`) | `4764d50fecb9f9370b626fc146f09954` | `macos_x_tiger` |
| Leopard | `macosx105.iso` (`MacOSXLeopard10.5.iso`) | `39131217782d060d72c9cb7688b2b26d` | `macos_x_leopard` |

Those CDs are Apple copyrighted and are not on Depot. Fetch them with
QemuMac, then copy into `media/`:

```sh
./scripts/bootstrap-qemumac.sh
( cd local/QemuMac && ./iso-downloader.sh )
./scripts/pull-media.sh
MACOSX104_BOOT=d ./scripts/alt-hosts.sh up macosx104
MACOSX105_BOOT=d ./scripts/alt-hosts.sh up macosx105
```

Empty 10G qcow2 disks are created on first boot. With no ISO attached the
guest reaches Open Firmware; boot `d` once the installer is in `media/`.

Intel macOS (kholia/OSX-KVM on Depot) is a separate `qemu-system-x86_64`
OpenCore stack, not these G4 guests.
