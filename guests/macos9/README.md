# Mac OS 9.2.2 guest

PowerPC Mac OS 9 on `qemu-system-ppc`, machine `mac99,via=pmu`, CPU
`7400_v2.9` (G4). Shared launcher: `guests/macos-ppc/qemu-macos-ppc.sh`.
This wrapper maps `MACOS9_*` environment variables for the original guest.

Sibling services: `macos921`, `macos91`, `macos904`. See [docs/macos9.md](../../docs/macos9.md).

## Media

| File | Role |
| --- | --- |
| `macos9.qcow2` | Installed 5 GiB disk from `m4-casa:/Volumes/Depot/downloads/qemu-os9/` |
| `macos-922-uni.iso` | Mac OS 9.2.2 Universal installer |

Apple media stays on the operator's machine. `scripts/pull-media.sh` copies
the 9.2.2 disk and ISO into `media/`.

## Boot

Default `MACOS9_BOOT=c` boots the hard disk. To run Apple System Restore
from the Universal ISO:

```sh
MACOS9_BOOT=d ./scripts/alt-hosts.sh up macos9
```

Inside the guest: initialize the disk as HFS Extended, restore from the
CD, shut down, then boot with `MACOS9_BOOT=c`.

## Access

- noVNC: http://127.0.0.1:6099/vnc.html
- VNC: `127.0.0.1:5909`

## Native launcher

On macOS, [QemuMac](https://github.com/matthewdeaves/QemuMac) `power_mac_g4_os9`
is the host-side equivalent. `./scripts/bootstrap-qemumac.sh` clones it into
`local/QemuMac`.
