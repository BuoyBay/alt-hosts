# Mac OS 7.5.3 guest

68k Quadra 800 on `qemu-system-m68k` `-M q800 -cpu m68040`. Shared launcher:
`guests/macos-m68k/qemu-macos-m68k.sh`. Sibling service `macos76` is 7.6.1.

## Media

| File | Role |
| --- | --- |
| `800.ROM` | Quadra 800 ROM from `Old_World_Mac_Roms.zip` |
| `macos75.qcow2` | empty 2G disk until install |
| `macos75.iso` | Apple Legacy Recovery or 7.5.3 CD (operator-supplied) |

`scripts/pull-media.sh` extracts the ROM. Depot does not have a 7.5 installer;
the guest exits until `macos75.iso` is present.

## Access

- noVNC: http://127.0.0.1:6095/vnc.html
- VNC: `127.0.0.1:5905`

`macos76` uses 6096 / 5906 and `macos76.iso`.

## Native launcher

On macOS, [QemuMac](https://github.com/matthewdeaves/QemuMac)
`vms/68k_quadra_800_os753` (7.5.3) and `vms/68k_quadra_800` (7.6.1).
