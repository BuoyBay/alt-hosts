# Quadra 800 (68k) launcher

`qemu-macos-m68k.sh` runs Mac OS 7.5.3 and 7.6.1 on `qemu-system-m68k`
`-M q800`. It matches QemuMac `68k_quadra_800*` plus `-audiodev none` so
stock Debian QEMU does not crash without a sound card.

Requires `800.ROM` (md5 `69489153dde910a69d5ae6de5dd65323`). Creates a 2G
qcow2 when the disk is missing, patches a 256-byte PRAM, and boots SCSI
id 6 (disk) or id 3 (CD).

Compose services: `macos75`, `macos76`. Notes: [docs/macos-m68k.md](../../docs/macos-m68k.md).
