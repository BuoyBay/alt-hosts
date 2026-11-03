# QEMU guests for Haiku and Classic Mac OS

Docker-wrapped QEMU guests used as build and test hosts for alternative
operating systems. Guests are Mac OS 9.2.2 through 9.0.4 (PowerPC),
Mac OS 7.6.1 / 7.5.3 (68k Quadra 800), and Haiku R1/beta6 (x86_64).

## Guests

| Guest | QEMU | Default media | UI |
| --- | --- | --- | --- |
| `macos9` | `qemu-system-ppc` `-M mac99,via=pmu` | `macos9.qcow2` + `macos-922-uni.iso` | VNC `5909`, noVNC `6099` |
| `macos921` | `qemu-system-ppc` `-M mac99,via=pmu` | `macos921.qcow2` (UTM 9.2.1) | VNC `5902`, noVNC `6092` |
| `macos91` | `qemu-system-ppc` `-M mac99,via=pmu` | `macos91.qcow2` (UTM 9.1) | VNC `5901`, noVNC `6091` |
| `macos904` | `qemu-system-ppc` `-M mac99` | empty qcow2 + `macos904.toast` | VNC `5904`, noVNC `6094` |
| `macos76` | `qemu-system-m68k` `-M q800` | `800.ROM` + `macos76.qcow2` | VNC `5906`, noVNC `6096` |
| `macos75` | `qemu-system-m68k` `-M q800` | `800.ROM` + `macos75.qcow2` | VNC `5905`, noVNC `6095` |
| `haiku` | `qemu-system-x86_64` | `haiku-r1beta6-x86_64.qcow2` | VNC `5911`, noVNC `6111` |

Classic Mac flags follow [QemuMac](https://github.com/matthewdeaves/QemuMac)
(`power_mac_g4_os9`, `68k_quadra_800*`) and the
[unnamedd/openfirmware OS 9 gist](https://gist.github.com/unnamedd/1430410fb329bc3480359ef32e38f94a).
Haiku flags follow the existing grok-bot launcher on `m4-casa`
(`/Volumes/Depot/grok/workspace/haiku/start-haiku.sh`).

Mac OS 8.0–8.6 is not a `qemu-system-ppc` guest. 8.1 is the last 68k release
and uses the same Quadra 800 launcher as 7.5/7.6 once an installer ISO is
in `media/`.

## Media

Apple installers, NewWorld ROMs, Quadra ROMs and qcow2 disks are **not** in
git. Put them in `media/` (gitignored) or set `MEDIA_DIR`.

On `m4-casa` the operator already has:

- `/Volumes/Depot/downloads/qemu-os9/` — `macos-922-uni.iso`, `macos9.qcow2`, `Mac OS 9.0.4.toast`, `Mac OS ROM`
- `/Volumes/Depot/downloads/Mac OS 9.1.utm`, `Mac OS 9.2.1.utm`, `Mac OS 9.2.2.utm`
- `/Volumes/Depot/downloads/Old_World_Mac_Roms.zip` — Quadra 800 ROM (`800.ROM`)
- `/Volumes/Depot/grok/workspace/haiku/` — `haiku-r1beta6-x86_64.qcow2`, `haiku-r1beta6-x86_64-anyboot.iso`

From this Linux host:

```sh
./scripts/pull-media.sh
```

That rsyncs the 9.x disks/ISOs, extracts `800.ROM`, and rebases the Haiku
overlay. 7.5/7.6 installer ISOs are operator-supplied (Apple Legacy Recovery);
the launchers create empty 2G disks and exit until those CDs are present.
See [docs/media.md](docs/media.md).

## Run

```sh
./scripts/alt-hosts.sh check
./scripts/alt-hosts.sh up macos9
./scripts/alt-hosts.sh up macos921
./scripts/alt-hosts.sh up macos91
./scripts/alt-hosts.sh up macos904
./scripts/alt-hosts.sh up haiku
./scripts/alt-hosts.sh status
```

noVNC:

- Mac OS 9.2.2: http://127.0.0.1:6099/vnc.html
- Mac OS 9.2.1: http://127.0.0.1:6092/vnc.html
- Mac OS 9.1: http://127.0.0.1:6091/vnc.html
- Mac OS 9.0.4: http://127.0.0.1:6094/vnc.html
- Mac OS 7.6.1: http://127.0.0.1:6096/vnc.html
- Mac OS 7.5.3: http://127.0.0.1:6095/vnc.html
- Haiku: http://127.0.0.1:6111/vnc.html

Raw VNC is on `127.0.0.1:5909` (9.2.2) through `5901`/`5902`/`5904`/`5905`/`5906`
and `5911` (Haiku). Host ports avoid 6081, 2222 and 6010–6019 already used by
other stacks on this workstation.

On macOS, QemuMac remains the native launcher (`local/QemuMac` after
`./scripts/bootstrap-qemumac.sh`). Docker on this Debian workstation uses
KVM for Haiku and TCG for PowerPC and 68k Mac OS.

## Layout

```
compose.yaml            all guest services
guests/macos-ppc/       shared qemu-system-ppc launcher
guests/macos-m68k/      shared qemu-system-m68k Quadra 800 launcher
guests/macos9/          9.2.2 wrapper (MACOS9_* env)
guests/haiku/           Haiku R1/beta6 launcher
guests/macos75/         7.5.3 notes
scripts/                check, pull-media, compose wrapper
media/                  gitignored operator disks
```
