# Macintosh System 1–6 (Mini vMac)

Stock Debian `qemu-system-m68k` only emulates the Quadra 800, which boots
System 7.1 through Mac OS 8.1. System 1.0 through 6.0.8 need a compact
Macintosh. [Mini vMac](https://github.com/minivmac/minivmac) (GPL-2.0)
emulates a Macintosh Plus and a Macintosh 128K. This image compiles both
and shows them through Xvfb + x11vnc on the same noVNC ports as the QEMU
guests.

| Service | OS | Machine | Ports |
| --- | --- | --- | --- |
| `macos6` | System 6.0.8 | Plus, 4 MiB | VNC 5916, noVNC 6116 |
| `macos5` | System 5 | Plus | VNC 5915, noVNC 6115 |
| `macos4` | System 4 | Plus | VNC 5914, noVNC 6114 |
| `macos3` | System 3 | Plus | VNC 5913, noVNC 6113 |
| `macos2` | System 2 | Plus | VNC 5912, noVNC 6112 |
| `macos1` | System 1.0 | 128K | VNC 5910, noVNC 6110 |

Apple released System 6.0.8 as freeware. `pull-media.sh` downloads the two
1.4 MB `.sea.bin` archives from Apple and unpacks them with Gryphel
`ua608d` to `macos6.dsk` (“System Startup”) and `macos6-additions.dsk`.
System 1–5 installer disks stay operator-supplied (`macos1.dsk` …
`macos5.dsk`). Without a disk the guest still starts and shows the
blinking floppy.

## ROMs

From Depot `Old_World_Mac_Roms.zip`:

| File | Zip member | md5 |
| --- | --- | --- |
| `vMac.ROM` | `128KB ROMs/1986-03 - 4D1F8172 - MacPlus v3.ROM` | `8a41e0754ffd1bb00d8183875c55164c` |
| `Mac128K.ROM` | `64KB ROMs/1984-01 - 28BA61CE - Macintosh 128.ROM` | `1d7f52d2d490524954f6afce083d9593` |

ROMs are Apple copyrighted and are not in git.

## Mini vMac

- Plus binary: `/usr/local/bin/minivmac-plus` (`-m Plus -magnify 1 -sound 0 -bg 1`)
- 128K binary: `/usr/local/bin/minivmac-128k`
- Display: 512×342 at 2× = 1024×684, Xvfb 24-bit, x11vnc on container 5900
- Source is cloned at image build time from `minivmac/minivmac`; it is not vendored

```sh
./scripts/pull-media.sh
./scripts/alt-hosts.sh up macos6
```

System 1.1 through 6.0.8 run on the Plus guest. System 1.0 needs `macos1`
(128K). System 7.5/7.6 stay on the Quadra 800 QEMU guests.
