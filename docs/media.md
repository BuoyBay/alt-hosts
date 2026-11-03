# Guest media

This repository ships launchers, not operating systems.

## Mac OS 9 (Apple, PowerPC)

Apple installers, NewWorld ROMs and restored disks are copyrighted. Keep them
on the operator's machine. Do not commit them, and do not publish them to
GitHub.

Known copies on `m4-casa`:

| Path | What |
| --- | --- |
| `/Volumes/Depot/downloads/qemu-os9/macos-922-uni.iso` | Mac OS 9.2.2 Universal |
| `/Volumes/Depot/downloads/qemu-os9/macos9.qcow2` | Installed 9.2 disk (5 GiB qcow2) |
| `/Volumes/Depot/downloads/qemu-os9/Mac OS 9.0.4.toast` | 9.0.4 restore → `macos904.toast` |
| `/Volumes/Depot/downloads/qemu-os9/Mac OS ROM` | NewWorld ROM → `macos-rom.bin` |
| `/Volumes/Depot/downloads/Mac OS 9.1.utm` | UTM bundle → `macos91.qcow2` |
| `/Volumes/Depot/downloads/Mac OS 9.2.1.utm` | UTM bundle → `macos921.qcow2` |
| `/Volumes/Depot/downloads/Mac OS 9.2.2.utm` | UTM bundle (same era as `macos9.qcow2`) |

`~/Downloads` on that Mac is a symlink to `/Volumes/Depot/downloads`.

Default Docker filenames under `media/`:

- `macos9.qcow2`, `macos-922-uni.iso`
- `macos921.qcow2`
- `macos91.qcow2`
- `macos904.toast` (empty `macos904.qcow2` is created on first boot)
- `macos-rom.bin` (Mac OS ROM suitcase kept beside the disks; OpenBIOS is used)

## Mac OS X 10.0–10.5 (Apple, PowerPC)

QemuMac `power_mac_g4_tiger` and `power_mac_g4_leopard` cover 10.4 / 10.5.
10.0–10.3 use the same `qemu-system-ppc` launcher. Installer CDs are not
on Depot. QemuMac `iso-downloader.sh` fetches Tiger/Leopard from the
archive.org items listed in `iso/software-database.json`:

| QemuMac key | Archive name | `media/` name | md5 |
| --- | --- | --- | --- |
| `macos_x_tiger` | `MacOSX.4.iso` | `macosx104.iso` | `4764d50fecb9f9370b626fc146f09954` |
| `macos_x_leopard` | `MacOSXLeopard10.5.iso` | `macosx105.iso` | `39131217782d060d72c9cb7688b2b26d` |

`pull-media.sh` copies those files from `local/QemuMac/iso/` when a clone
is present. Empty `macosx104.qcow2` / `macosx105.qcow2` and
`macosx100.qcow2`–`macosx103.qcow2` are created on first boot.

Place 10.0–10.3 CDs as `macosx100.iso` … `macosx103.iso`. QemuMac
`power_mac_g4_tiger_3d` needs a Radeon QEMU build and is not a Docker
guest.

## Mac OS X 10.6 Snow Leopard (Apple, Intel)

Retail 10.6 dropped PowerPC. The guest is `qemu-system-x86_64` + OVMF +
OpenCore (`guests/macosx-intel/qemu-macosx-intel.sh`).

| File | What |
| --- | --- |
| `macosx106-oc.qcow2` | OpenCore EFI disk from LegacyOSXKVM `opencore/opencore-SLeopard.qcow2` |
| `macosx106.qcow2` | empty 16G HDD, created on first boot |
| `macosx106.iso` | operator 10.6 Install DVD (optional) |
| `macosx106-vars.fd` | OVMF VARS copy, created on first boot |

`./scripts/bootstrap-legacyosxkvm.sh` clones
[royalgraphx/LegacyOSXKVM](https://github.com/royalgraphx/LegacyOSXKVM)
into `local/` (not vendored). `pull-media.sh` copies the OpenCore qcow2.
Do not auto-fetch Apple 10.6 ISOs or `sl_utm.qcow2`. Depot
`/Volumes/Depot/code/repos/OSX-KVM` is the 10.13+ OpenCore stack.

## Macintosh System 1–6 (Apple, Mini vMac)

Stock QEMU has no Macintosh 128K or Plus. Mini vMac covers System 1.0
(128K) and System 1.1–6.0.8 (Plus).

| File | What |
| --- | --- |
| `vMac.ROM` | Plus v3 from `Old_World_Mac_Roms.zip` |
| `Mac128K.ROM` | 128K from the same zip |
| `macos6.dsk` | Apple System 6.0.8 System Startup (freeware) |
| `macos6-additions.dsk` | System Additions |
| `macos1.dsk` … `macos5.dsk` | operator System 1–5 disks |

`pull-media.sh` extracts the ROMs and downloads the two Apple
`SSW_6.0.8-1.4MB_Disk*.sea.bin` files, then unpacks them with ua608d.
Apple’s 6.0.8 license is freeware; the unpacked disks stay under
gitignored `media/` and are not redistributed from this repo.

## Mac OS 7.5 / 7.6 (Apple, 68k Quadra 800)

| Path | What |
| --- | --- |
| `/Volumes/Depot/downloads/Old_World_Mac_Roms.zip` | `800.ROM` (md5 `69489153dde910a69d5ae6de5dd65323`) |

`pull-media.sh` extracts `1MB ROMs/1993-02 - F1ACAD13 - Quadra, Centris 610,650,800.ROM`.
That checksum matches QemuMac's `roms/800.ROM`.

7.5.3 and 7.6.1 installer CDs are not on Depot. Place Apple Legacy Recovery
(or a 7.5/7.6 CD) as `macos75.iso` / `macos76.iso`. The launchers create empty
2G qcow2 disks and refuse to boot from CD until those files exist.

Mac OS 8.1 is the last 68k System; use the same `qemu-macos-m68k` launcher
with a dedicated disk/ISO when one is available. 8.0–8.6 do not run on
`qemu-system-ppc`.

SheepShaver `classic.dmg` on Depot is a PPC SheepShaver disk, not a q800 image.

## Haiku (open source)

Official images: https://www.haiku-os.org/get-haiku/ and
https://download.haiku-os.org/

Grok-bot copies on `m4-casa`:

| Path | What |
| --- | --- |
| `/Volumes/Depot/grok/workspace/haiku/haiku-r1beta6-x86_64.qcow2` | Installed disk |
| `/Volumes/Depot/grok/workspace/haiku/haiku-r1beta6-x86_64-anyboot.iso` | Official anyboot ISO |
| `/Volumes/Depot/grok/workspace/haiku/start-haiku.sh` | Original TCG launcher |

Default Docker files: `haiku-r1beta6-x86_64.qcow2` plus its backing
`haiku-r1beta6-x86_64-anyboot.iso`. The qcow2 is a 196 MiB overlay created
at `/workspace/haiku/` on the grok VM; `pull-media.sh` rebases it onto the
ISO in `media/`.

## Pull

```sh
./scripts/pull-media.sh
```
