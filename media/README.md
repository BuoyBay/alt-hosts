# media/

Put guest disks here. Git ignores everything except this file and `.gitkeep`.

Expected names after `./scripts/pull-media.sh`:

- `macos9.qcow2`, `macos-922-uni.iso`
- `macos921.qcow2`
- `macos91.qcow2`
- `macos904.toast`, `macos-rom.bin` (suitcase; OpenBIOS is used)
- `800.ROM`
- `haiku-r1beta6-x86_64.qcow2`
- `haiku-r1beta6-x86_64-anyboot.iso` (backing file for the Haiku qcow2)

Operator-supplied later:

- `macos75.iso`, `macos76.iso` (Apple Legacy Recovery / 7.5 / 7.6 CDs)
- `macosx104.iso`, `macosx105.iso` (QemuMac `macos_x_tiger` / `macos_x_leopard`)
