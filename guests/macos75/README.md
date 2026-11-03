# Mac OS 7.5–8.x (next)

68k Quadra 800 guests come after Mac OS 9.x is booting from Docker.

QemuMac already ships:

- `vms/68k_quadra_800_os753` — Mac OS 7.5.3
- `vms/68k_quadra_800` — Mac OS 7.6.1

Those need `qemu-system-m68k` (`-M q800`, CPU `m68040`) and a Quadra 800
ROM (`800.ROM`). The ROM is Apple copyrighted; keep it in `media/` like
the OS 9 disks. QEMU 8.2+ is required.

On this Debian host, install `qemu-system-misc` when wiring the guest.
The Docker image currently ships `qemu-system-ppc` and `qemu-system-x86`
only.

Operator media already on `m4-casa` that may help later:

- `/Volumes/Depot/downloads/Old_World_Mac_Roms.zip`
- `/Volumes/Depot/downloads/SheepShaver_Roms.zip`
- `/Volumes/Depot/downloads/qemu-os9/Mac OS ROM` (NewWorld; not the 68k ROM)
