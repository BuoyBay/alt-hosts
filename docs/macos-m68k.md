# Mac OS 7.5 / 7.6 notes (68k Quadra 800)

QEMU 8.2+ `qemu-system-m68k -M q800 -cpu m68040` with a Quadra 800 ROM.
Flags follow QemuMac `vms/68k_quadra_800` (7.6.1) and
`vms/68k_quadra_800_os753` (7.5.3).

## QEMU

- Binary: `qemu-system-m68k` (`guests/macos-m68k/qemu-macos-m68k.sh`)
- Machine: `q800,audiodev=audio0` with `-audiodev none` (headless Debian;
  QemuMac notes the Apple Sound Chip can crash QEMU when no card is present)
- BIOS: `800.ROM` (md5 `69489153dde910a69d5ae6de5dd65323`)
- SCSI HD id 6, CD id 3
- NIC: `dp83932`
- PRAM: 256-byte MTD image; boot RefNum `~(SCSI_ID+32)` at offset 120
- Display: `1152x870x8` (q800 framebuffer; 24-bit only at 640x480 / 800x600)

| Service | Disk | CD | Ports |
| --- | --- | --- | --- |
| `macos76` | `macos76.qcow2` | `macos76.iso` | 5906 / 6096 |
| `macos75` | `macos75.qcow2` | `macos75.iso` | 5905 / 6095 |

## Media

`pull-media.sh` extracts `800.ROM` from `Old_World_Mac_Roms.zip` on Depot.
Installer ISOs are not on Depot. Copy Apple Legacy Recovery (or a 7.5.3 /
7.6.1 CD) to `media/macos75.iso` and `media/macos76.iso`. Until then the
launcher creates an empty 2G qcow2 and exits with a message to add the CD.

Mac OS 8.1 is the last 68k release and uses this same launcher. 8.0–8.6 are
not supported on `qemu-system-ppc`. System 1–6 use Mini vMac; see
[macos-system.md](macos-system.md).

## Native launcher

On macOS, [QemuMac](https://github.com/matthewdeaves/QemuMac) is the host-side
equivalent. `./scripts/bootstrap-qemumac.sh` clones it into `local/QemuMac`.
