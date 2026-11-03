# Mac OS 9.2.2 guest

PowerPC Mac OS 9 on `qemu-system-ppc`, machine `mac99,via=pmu`, CPU
`7400_v2.9` (G4). This is the first Classic Mac guest; 9.1 / 9.0.4 and
then 68k 7.5–8.x come next.

## Media

| File | Role |
| --- | --- |
| `macos9.qcow2` | Installed 5 GiB disk from `m4-casa:/Volumes/Depot/downloads/qemu-os9/` |
| `macos-922-uni.iso` | Mac OS 9.2.2 Universal installer |
| `Mac OS 9.0.4.toast` | 9.0.4 restore (not the default boot) |
| `Mac OS ROM` | NewWorld ROM kept beside the disks; OpenBIOS is used instead |

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

9.0.4 on QEMU wants `-M mac99` without `via=pmu` and a NewWorld ROM 5.2.1+.
Keep that for a later `macos904` service.

## Native launcher

On macOS, [QemuMac](https://github.com/matthewdeaves/QemuMac) `power_mac_g4_os9`
is the host-side equivalent. `./scripts/bootstrap-qemumac.sh` clones it into
`local/QemuMac`.
