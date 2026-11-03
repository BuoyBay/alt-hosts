# Macintosh System 1–6 (Mini vMac)

Stock QEMU only emulates the Quadra 800 (System 7.1–8.1). System 1–6 run
on Mini vMac: Macintosh 128K for System 1.0, Macintosh Plus for 1.1–6.0.8.

Compose services `macos1` … `macos6`. Shared launcher:
`minivmac-macos.sh` (Xvfb + x11vnc).

## Media

| File | Role |
| --- | --- |
| `vMac.ROM` | Macintosh Plus v3 (checksum `4D1F8172`, md5 `8a41e0754ffd1bb00d8183875c55164c`) |
| `Mac128K.ROM` | Macintosh 128K (checksum `28BA61CE`) |
| `macos6.dsk` | Apple System 6.0.8 “System Startup” (freeware) |
| `macos6-additions.dsk` | optional “System Additions” |
| `macos1.dsk` … `macos5.dsk` | operator System 1–5 disks |

`scripts/pull-media.sh` extracts the ROMs from Depot `Old_World_Mac_Roms.zip`
and unpacks Apple’s 6.0.8 `.sea.bin` with ua608d.

## Access

- System 6 noVNC: http://127.0.0.1:6116/vnc.html
- System 1 noVNC: http://127.0.0.1:6110/vnc.html

Notes: [docs/macos-system.md](../../docs/macos-system.md).
