# PowerPC Mac OS 9 launcher

`qemu-macos-ppc.sh` is the shared `qemu-system-ppc` command line for 9.0.4,
9.1, 9.2.1 and 9.2.2.

Environment:

| Variable | Role |
| --- | --- |
| `MACOS_DISK` | qcow2 under `/media` |
| `MACOS_CDROM` | optional ISO / toast |
| `MACOS_BIOS` | optional QEMU `-bios` image (OpenBIOS is the default; the Depot `Mac OS ROM` suitcase is not one) |
| `MACOS_MACHINE` | `mac99,via=pmu` (9.1/9.2) or `mac99` (9.0.4) |
| `MACOS_BOOT` | `c` disk, `d` CD |
| `MACOS_CPU` | default `7400_v2.9` |
| `MACOS_MEM` | MiB |
| `DISPLAY_RES` | default `1024x768x32` |

Compose services `macos921`, `macos91` and `macos904` call this binary
directly. `macos9` goes through `guests/macos9/qemu-macos9.sh` so existing
`MACOS9_*` variables keep working.

Notes: [docs/macos9.md](../../docs/macos9.md).
