# PowerPC Mac OS 9 / OS X launcher

`qemu-macos-ppc.sh` is the shared `qemu-system-ppc` command line for 9.0.4,
9.1, 9.2.1, 9.2.2, and Mac OS X 10.0 through 10.5.

Environment:

| Variable | Role |
| --- | --- |
| `MACOS_DISK` | qcow2 under `/media` |
| `MACOS_CDROM` | optional ISO / toast |
| `MACOS_BIOS` | optional QEMU `-bios` image (OpenBIOS is the default; the Depot `Mac OS ROM` suitcase is not one) |
| `MACOS_MACHINE` | `mac99,via=pmu` (9.1/9.2, OS X 10.2–10.5) or `mac99` (9.0.4, 10.0/10.1) |
| `MACOS_BOOT` | `c` disk, `d` CD |
| `MACOS_CPU` | default `7400_v2.9` |
| `MACOS_MEM` | MiB (OS X guests use 2048) |
| `MACOS_SSH_PORT` | optional hostfwd to guest sshd (OS X Remote Login) |
| `DISPLAY_RES` | default `1024x768x32` |

Compose services `macos921`, `macos91`, `macos904`, `macosx105`,
`macosx104`, `macosx103`, `macosx102`, `macosx101` and `macosx100` call
this binary directly. `macos9` goes through
`guests/macos9/qemu-macos9.sh` so existing `MACOS9_*` variables keep
working.

Notes: [docs/macos9.md](../../docs/macos9.md), [docs/macosx.md](../../docs/macosx.md).
