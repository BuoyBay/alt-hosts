# Guest media

This repository ships launchers, not operating systems.

## Mac OS 9 (Apple)

Apple installers, NewWorld ROMs and restored disks are copyrighted. Keep them
on the operator's machine. Do not commit them, and do not publish them to
GitHub.

Known copies on `m4-casa`:

| Path | What |
| --- | --- |
| `/Volumes/Depot/downloads/qemu-os9/macos-922-uni.iso` | Mac OS 9.2.2 Universal |
| `/Volumes/Depot/downloads/qemu-os9/macos9.qcow2` | Installed 9.2 disk (5 GiB qcow2) |
| `/Volumes/Depot/downloads/qemu-os9/Mac OS 9.0.4.toast` | 9.0.4 restore |
| `/Volumes/Depot/downloads/qemu-os9/Mac OS ROM` | NewWorld ROM |
| `/Volumes/Depot/downloads/Mac OS 9.1.utm` | UTM bundle |
| `/Volumes/Depot/downloads/Mac OS 9.2.1.utm` | UTM bundle |
| `/Volumes/Depot/downloads/Mac OS 9.2.2.utm` | UTM bundle |

`~/Downloads` on that Mac is a symlink to `/Volumes/Depot/downloads`.

Default Docker filenames under `media/`:

- `macos9.qcow2`
- `macos-922-uni.iso`

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
ALT_HOSTS_PULL_EXTRAS=1 ./scripts/pull-media.sh
```
