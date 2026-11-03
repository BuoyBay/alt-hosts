# QEMU and Mini vMac guests for Haiku, Classic Mac OS, and Mac OS X

Docker-wrapped QEMU guests used as build and test hosts for alternative
operating systems. Guests are Mac OS 9.2.2 through 9.0.4 (PowerPC),
Mac OS X 10.6 Snow Leopard (Intel), 10.5.6 / 10.4 (PowerPC G4), 10.3–10.0
(PowerPC), Mac OS 7.6.1 / 7.5.3 (68k Quadra 800), Macintosh System 6.0.8
through 1.0 (Mini vMac Plus / 128K), and Haiku R1/beta6 (x86_64).

## Guests

| Guest | QEMU | Default media | UI |
| --- | --- | --- | --- |
| `macos9` | `qemu-system-ppc` `-M mac99,via=pmu` | `macos9.qcow2` + `macos-922-uni.iso` | VNC `5909`, noVNC `6099` |
| `macos921` | `qemu-system-ppc` `-M mac99,via=pmu` | `macos921.qcow2` (UTM 9.2.1) | VNC `5902`, noVNC `6092` |
| `macos91` | `qemu-system-ppc` `-M mac99,via=pmu` | `macos91.qcow2` (UTM 9.1) | VNC `5901`, noVNC `6091` |
| `macos904` | `qemu-system-ppc` `-M mac99` | empty qcow2 + `macos904.toast` | VNC `5904`, noVNC `6094` |
| `macosx106` | `qemu-system-x86_64` q35 + OpenCore | `macosx106-oc.qcow2` + empty 16G | VNC `5908`, noVNC `6098` |
| `macosx105` | `qemu-system-ppc` `-M mac99,via=pmu` | `macosx105.qcow2` + `macosx105.iso` | VNC `5907`, noVNC `6097` |
| `macosx104` | `qemu-system-ppc` `-M mac99,via=pmu` | `macosx104.qcow2` + `macosx104.iso` | VNC `5903`, noVNC `6093` |
| `macosx103` | `qemu-system-ppc` `-M mac99,via=pmu` | empty `macosx103.qcow2` | VNC `5923`, noVNC `6123` |
| `macosx102` | `qemu-system-ppc` `-M mac99,via=pmu` | empty `macosx102.qcow2` | VNC `5922`, noVNC `6122` |
| `macosx101` | `qemu-system-ppc` `-M mac99` | empty `macosx101.qcow2` | VNC `5921`, noVNC `6121` |
| `macosx100` | `qemu-system-ppc` `-M mac99` | empty `macosx100.qcow2` | VNC `5920`, noVNC `6120` |
| `macos76` | `qemu-system-m68k` `-M q800` | `800.ROM` + `macos76.qcow2` | VNC `5906`, noVNC `6096` |
| `macos75` | `qemu-system-m68k` `-M q800` | `800.ROM` + `macos75.qcow2` | VNC `5905`, noVNC `6095` |
| `macos6` | Mini vMac Plus | `vMac.ROM` + `macos6.dsk` | VNC `5916`, noVNC `6116` |
| `macos5` | Mini vMac Plus | `vMac.ROM` + `macos5.dsk` | VNC `5915`, noVNC `6115` |
| `macos4` | Mini vMac Plus | `vMac.ROM` + `macos4.dsk` | VNC `5914`, noVNC `6114` |
| `macos3` | Mini vMac Plus | `vMac.ROM` + `macos3.dsk` | VNC `5913`, noVNC `6113` |
| `macos2` | Mini vMac Plus | `vMac.ROM` + `macos2.dsk` | VNC `5912`, noVNC `6112` |
| `macos1` | Mini vMac 128K | `Mac128K.ROM` + `macos1.dsk` | VNC `5910`, noVNC `6110` |
| `haiku` | `qemu-system-x86_64` | `haiku-r1beta6-x86_64.qcow2` | VNC `5911`, noVNC `6111` |

Classic Mac and PowerPC OS X flags follow [QemuMac](https://github.com/matthewdeaves/QemuMac)
(`power_mac_g4_os9`, `power_mac_g4_tiger`, `power_mac_g4_leopard`,
`68k_quadra_800*`) and the
[unnamedd/openfirmware OS 9 gist](https://gist.github.com/unnamedd/1430410fb329bc3480359ef32e38f94a).
Snow Leopard 10.6 is Intel-only retail; flags follow
[royalgraphx/LegacyOSXKVM](https://github.com/royalgraphx/LegacyOSXKVM)
`SLeopard-Boot.sh` plus OSX-KVM pflash OVMF. Haiku flags follow the grok-bot
launcher on `m4-casa` (`/Volumes/Depot/grok/workspace/haiku/start-haiku.sh`).
QemuMac's Radeon 9700 Tiger 3D guest stays native; stock Debian QEMU has
no Radeon device.

System 1–6 cannot use Quadra 800 QEMU; they run on Mini vMac (Plus / 128K)
compiled into the image. Mac OS 8.1 is the last 68k System and reuses the
Quadra 800 launcher once an installer is in `media/`. 8.0–8.6 do not run on
`qemu-system-ppc`. Intel 10.7–10.12 (LegacyOSXKVM) and 10.13+ (kholia/OSX-KVM
/ DarwinKVM) are later guests. See [docs/macosx.md](docs/macosx.md) and
[docs/macos-system.md](docs/macos-system.md).

## Media

Apple installers, NewWorld ROMs, Quadra ROMs and qcow2 disks are **not** in
git. Put them in `media/` (gitignored) or set `MEDIA_DIR`.

On `m4-casa` the operator already has:

- `/Volumes/Depot/downloads/qemu-os9/` — `macos-922-uni.iso`, `macos9.qcow2`, `Mac OS 9.0.4.toast`, `Mac OS ROM`
- `/Volumes/Depot/downloads/Mac OS 9.1.utm`, `Mac OS 9.2.1.utm`, `Mac OS 9.2.2.utm`
- `/Volumes/Depot/downloads/Old_World_Mac_Roms.zip` — Quadra 800 (`800.ROM`), Plus v3 (`vMac.ROM`), Macintosh 128K (`Mac128K.ROM`)
- `/Volumes/Depot/grok/workspace/haiku/` — `haiku-r1beta6-x86_64.qcow2`, `haiku-r1beta6-x86_64-anyboot.iso`

From this Linux host:

```sh
./scripts/pull-media.sh
```

That rsyncs the 9.x disks/ISOs, extracts `800.ROM` / Plus / 128K ROMs,
downloads Apple System 6.0.8 freeware, rebases the Haiku overlay, and
copies OpenCore from `local/LegacyOSXKVM` when a clone is present. 7.5/7.6,
System 1–5 disks, and Apple OS X installer ISOs are operator-supplied.
See [docs/media.md](docs/media.md).

## Run

```sh
./scripts/alt-hosts.sh check
./scripts/alt-hosts.sh up macos9
./scripts/alt-hosts.sh up macos921
./scripts/alt-hosts.sh up macos91
./scripts/alt-hosts.sh up macos904
./scripts/alt-hosts.sh up macosx106
./scripts/alt-hosts.sh up macosx105
./scripts/alt-hosts.sh up macosx104
./scripts/alt-hosts.sh up macos6
./scripts/alt-hosts.sh up haiku
./scripts/alt-hosts.sh status
```

noVNC:

- Mac OS 9.2.2: http://127.0.0.1:6099/vnc.html
- Mac OS 9.2.1: http://127.0.0.1:6092/vnc.html
- Mac OS 9.1: http://127.0.0.1:6091/vnc.html
- Mac OS 9.0.4: http://127.0.0.1:6094/vnc.html
- Mac OS X 10.6: http://127.0.0.1:6098/vnc.html
- Mac OS X 10.5.6: http://127.0.0.1:6097/vnc.html
- Mac OS X 10.4: http://127.0.0.1:6093/vnc.html
- Mac OS X 10.3–10.0: http://127.0.0.1:6123/vnc.html through `6120`
- Mac OS 7.6.1: http://127.0.0.1:6096/vnc.html
- Mac OS 7.5.3: http://127.0.0.1:6095/vnc.html
- System 6.0.8: http://127.0.0.1:6116/vnc.html
- System 1.0: http://127.0.0.1:6110/vnc.html
- Haiku: http://127.0.0.1:6111/vnc.html

Raw VNC is on `127.0.0.1:5909` (9.2.2) through `5901`–`5908`, `5916`–`5912`
and `5910` (System 6–1), `5920`–`5923` (10.0–10.3), and `5911` (Haiku). Host
ports avoid 6081, 2222 and 6010–6019 already used by other stacks on this
workstation. OS X SSH is `2214` (Tiger), `2215` (Leopard), and `2216`
(Snow Leopard).

On macOS, QemuMac remains the native launcher (`local/QemuMac` after
`./scripts/bootstrap-qemumac.sh`). Intel 10.6 OpenCore comes from
`./scripts/bootstrap-legacyosxkvm.sh`. Docker on this Debian workstation
uses KVM for Haiku and Snow Leopard, and TCG for PowerPC and 68k Mac OS.

## Layout

```
compose.yaml            all guest services
guests/macos-ppc/       shared qemu-system-ppc launcher (OS 9 and PPC OS X)
guests/macos-m68k/      shared qemu-system-m68k Quadra 800 launcher
guests/macos9/          9.2.2 wrapper (MACOS9_* env)
guests/macosx-intel/    Snow Leopard 10.6 OpenCore launcher
guests/macosx/          PPC OS X notes
guests/minivmac/        System 1–6 Mini vMac launcher
guests/haiku/           Haiku R1/beta6 launcher
guests/macos75/         7.5.3 notes
scripts/                check, pull-media, QemuMac / LegacyOSXKVM bootstrap
media/                  gitignored operator disks
```
