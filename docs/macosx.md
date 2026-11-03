# Mac OS X notes

PowerPC 10.0–10.5 share `qemu-system-ppc`. Retail Snow Leopard 10.6 is
Intel-only and uses `qemu-system-x86_64` plus OpenCore.

| Service | OS | Machine | Ports |
| --- | --- | --- | --- |
| `macosx106` | 10.6 Snow Leopard (Intel) | `pc-q35-6.1` + OpenCore | VNC 5908, noVNC 6098, SSH 2216 |
| `macosx105` | 10.5.6 Leopard | `mac99,via=pmu` | VNC 5907, noVNC 6097, SSH 2215 |
| `macosx104` | 10.4 Tiger | `mac99,via=pmu` | VNC 5903, noVNC 6093, SSH 2214 |
| `macosx103` | 10.3 Panther | `mac99,via=pmu` | VNC 5923, noVNC 6123 |
| `macosx102` | 10.2 Jaguar | `mac99,via=pmu` | VNC 5922, noVNC 6122 |
| `macosx101` | 10.1 Puma | `mac99` | VNC 5921, noVNC 6121 |
| `macosx100` | 10.0 Cheetah | `mac99` | VNC 5920, noVNC 6120 |

QemuMac covers Tiger and Leopard (`power_mac_g4_tiger`,
`power_mac_g4_leopard`). Cheetah through Panther follow
[royalgraphx/LegacyOSXKVM](https://github.com/royalgraphx/LegacyOSXKVM)
(`Cheetah-Boot.sh` uses `-M mac99` without PMU). The Radeon 9700 Tiger 3D
VM stays native QemuMac; stock Debian `qemu-system-ppc` has no Radeon
device.

## PowerPC QEMU

- Binary: `qemu-system-ppc` (`guests/macos-ppc/qemu-macos-ppc.sh`)
- CPU: `7400_v2.9`
- RAM: 2048 MiB (Tiger/Leopard), 1024 MiB (Jaguar/Panther), 512 MiB (Cheetah/Puma)
- NIC: `sungem`, USB `pci-ohci`
- SSH (Tiger/Leopard): container `2222` → guest `22` (turn on Remote Login after install)

Empty qcow2 disks are created on first boot. With no ISO attached the guest
reaches Open Firmware; boot `d` once the installer is in `media/`.

## Intel Snow Leopard QEMU

- Binary: `qemu-system-x86_64` (`guests/macosx-intel/qemu-macosx-intel.sh`)
- Machine: `pc-q35-6.1,vmport=off`
- Firmware: OVMF `pflash` (`OVMF_CODE_4M.fd` + a copy of `OVMF_VARS_4M.fd`)
- CPU: Penryn with SSE4.1/4.2/SSSE3, `isa-applesmc`
- Boot: OpenCore qcow2 on `ide.0` (`bootindex=0`), empty 16G HDD on `ide.2`
- NIC: `e1000-82545em`, display `vmware-svga`
- Accel: KVM when `/dev/kvm` is readable, otherwise TCG
- SSH: container `2222` → guest `22` (Remote Login after install)

Flags follow LegacyOSXKVM `SLeopard-Boot.sh` plus OSX-KVM pflash and
`e1000-82545em`. OpenCore is third-party EFI, not Apple OS. Clone it with
`./scripts/bootstrap-legacyosxkvm.sh`; `pull-media.sh` copies
`opencore/opencore-SLeopard.qcow2` to `media/macosx106-oc.qcow2`.

With OpenCore present and no installer, the guest reaches the OpenCore
picker. Attach an operator-owned 10.6 DVD as `macosx106.iso` (`ide-cd` on
`ide.1`) or a restored installer disk as `MACOSX106_INSTALLER` (qcow2 on
`ide.1`, LegacyOSXKVM `sl_utm.qcow2` layout). This repo does not fetch
Apple 10.6 media.

## Installers

QemuMac `iso/software-database.json` (PowerPC):

| Guest | File | md5 | QemuMac key |
| --- | --- | --- | --- |
| Tiger | `macosx104.iso` (`MacOSX.4.iso`) | `4764d50fecb9f9370b626fc146f09954` | `macos_x_tiger` |
| Leopard | `macosx105.iso` (`MacOSXLeopard10.5.iso`) | `39131217782d060d72c9cb7688b2b26d` | `macos_x_leopard` |

Those CDs are Apple copyrighted and are not on Depot. Fetch Tiger/Leopard
with QemuMac, then copy into `media/`:

```sh
./scripts/bootstrap-qemumac.sh
( cd local/QemuMac && ./iso-downloader.sh )
./scripts/pull-media.sh
MACOSX104_BOOT=d ./scripts/alt-hosts.sh up macosx104
MACOSX105_BOOT=d ./scripts/alt-hosts.sh up macosx105
```

10.0–10.3 installer CDs are operator-supplied (`macosx100.iso` …
`macosx103.iso`). Jaguar and Panther each need two disks; attach disk 1
first.

Snow Leopard:

```sh
./scripts/bootstrap-legacyosxkvm.sh
./scripts/pull-media.sh
./scripts/alt-hosts.sh up macosx106
```

Place `macosx106.iso` or set `MACOSX106_INSTALLER` to a qcow2 installer
when you have one. Depot has no 10.6 ISO.

## Later guests

Sourced, not wired in this image:

| Guest | Why it waits |
| --- | --- |
| Mac OS 8.1 (68k) | Same `qemu-macos-m68k` launcher; no installer on Depot |
| Intel 10.5 Leopard | LegacyOSXKVM `Leopard-Intel-Boot.sh`; PPC 10.5 is already a guest |
| 10.6 PPC DP | `SLeopardPPC-Boot.sh`; retail 10.6 dropped PowerPC |
| 10.6 Server (Xserve) | LegacyOSXKVM `xserve_boot.sh` |
| 10.7 Lion | LegacyOSXKVM marks it untested |
| 10.8 Mountain Lion | `opencore-MLion.qcow2` is in the clone; next Intel guest after 10.6 |
| 10.9–10.12 | LegacyOSXKVM scripts exist; several untested |
| 10.13+ | [kholia/OSX-KVM](https://github.com/kholia/OSX-KVM) / DarwinKVM; Depot clone is this stack |
| Rhapsody / Darwin 1.x | Cheetah-era PPC; no first-party launcher yet |
