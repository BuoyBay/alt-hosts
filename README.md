# QEMU guests for Haiku and Classic Mac OS

Docker-wrapped QEMU guests used as build and test hosts for alternative
operating systems. The first guests are **Mac OS 9.2.2** (PowerPC) and
**Haiku R1/beta6** (x86_64). Mac OS 7.5–8.x (68k Quadra) follow next.

## Guests

| Guest | QEMU | Default media | UI |
| --- | --- | --- | --- |
| `macos9` | `qemu-system-ppc` `-M mac99,via=pmu` | `macos9.qcow2` + `macos-922-uni.iso` | VNC `5909`, noVNC `6099` |
| `haiku` | `qemu-system-x86_64` | `haiku-r1beta6-x86_64.qcow2` | VNC `5911`, noVNC `6111` |
| `macos75` | `qemu-system-m68k` `-M q800` | not wired yet | see [guests/macos75](guests/macos75/README.md) |

Classic Mac flags follow [QemuMac](https://github.com/matthewdeaves/QemuMac)
(`power_mac_g4_os9`: G4, sungem, USB via `pci-ohci`) and the
[unnamedd/openfirmware OS 9 gist](https://gist.github.com/unnamedd/1430410fb329bc3480359ef32e38f94a).
Haiku flags follow the existing grok-bot launcher on `m4-casa`
(`/Volumes/Depot/grok/workspace/haiku/start-haiku.sh`).

## Media

Apple installers, NewWorld ROMs and qcow2 disks are **not** in git. Put them
in `media/` (gitignored) or set `MEDIA_DIR`.

On `m4-casa` the operator already has:

- `/Volumes/Depot/downloads/qemu-os9/` — `macos-922-uni.iso`, `macos9.qcow2`, `Mac OS 9.0.4.toast`, `Mac OS ROM`
- `/Volumes/Depot/downloads/Mac OS 9.1.utm`, `Mac OS 9.2.1.utm`, `Mac OS 9.2.2.utm`
- `/Volumes/Depot/grok/workspace/haiku/` — `haiku-r1beta6-x86_64.qcow2`, `haiku-r1beta6-x86_64-anyboot.iso`

From this Linux host:

```sh
./scripts/pull-media.sh
```

That rsyncs the 9.2.2 disk/ISO and the Haiku qcow2 into `media/`. See
[docs/media.md](docs/media.md).

## Run

```sh
./scripts/alt-hosts.sh check
./scripts/alt-hosts.sh up macos9
./scripts/alt-hosts.sh up haiku
./scripts/alt-hosts.sh status
```

noVNC:

- Mac OS 9: http://127.0.0.1:6099/vnc.html
- Haiku: http://127.0.0.1:6111/vnc.html

Raw VNC is on `127.0.0.1:5909` (OS 9) and `127.0.0.1:5911` (Haiku). Host ports
avoid 6081, 2222 and 6010–6019 already used by other stacks on this workstation.

On macOS, QemuMac remains the native launcher (`local/QemuMac` after
`./scripts/bootstrap-qemumac.sh`). Docker on this Debian workstation uses
KVM for Haiku and TCG for PowerPC Mac OS 9.

## Layout

```
compose.yaml            macos9 + haiku services
guests/macos9/          PPC Mac OS 9.2.2 launcher
guests/haiku/           Haiku R1/beta6 launcher
guests/macos75/         68k System 7.5 notes (next)
scripts/                check, pull-media, compose wrapper
media/                  gitignored operator disks
```
