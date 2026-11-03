# media/

Put guest disks here. Git ignores everything except this file and `.gitkeep`.

Expected names after `./scripts/pull-media.sh`:

- `macos9.qcow2`, `macos-922-uni.iso`
- `macos921.qcow2`
- `macos91.qcow2`
- `macos904.toast`, `macos-rom.bin` (suitcase; OpenBIOS is used)
- `800.ROM`
- `vMac.ROM`, `Mac128K.ROM`
- `macos6.dsk`, `macos6-additions.dsk` (Apple System 6.0.8 freeware)
- `haiku-r1beta6-x86_64.qcow2`
- `haiku-r1beta6-x86_64-anyboot.iso` (backing file for the Haiku qcow2)

Operator-supplied later:

- `macos75.iso`, `macos76.iso` (Apple Legacy Recovery / 7.5 / 7.6 CDs)
- `macosx104.iso`, `macosx105.iso` (QemuMac `macos_x_tiger` / `macos_x_leopard`)
- `macosx100.iso` … `macosx103.iso` (Cheetah through Panther)
- `macosx106.iso` or a 10.6 installer qcow2 (`MACOSX106_INSTALLER`)
- `macos1.dsk` … `macos5.dsk` (System 1–5)

Copied from `local/LegacyOSXKVM` by `pull-media.sh`:

- `macosx106-oc.qcow2` (OpenCore EFI, not Apple OS)
