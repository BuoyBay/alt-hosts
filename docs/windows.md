# Windows 95–10 (QEMU)

Microsoft Windows from 95 through 10 as Docker-wrapped QEMU guests.
Installers are copyrighted. Keep them on the operator's machine. Do not
commit them, and do not publish them to GitHub. Depot has no Windows
ISOs; `pull-media.sh` does not fetch any.

| Service | OS | Binary | CPU / accel | RAM | NIC | VGA | Sound |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `win95` | 95 | `qemu-system-i386` | pentium, TCG | 64 | `ne2k_isa` irq 10 | cirrus | sb16 |
| `win98` | 98 SE | i386 | pentium2, TCG | 256 | pcnet | cirrus | ac97 |
| `winme` | Me | i386 | pentium3, TCG | 256 | pcnet | cirrus | ac97 |
| `winnt4` | NT 4.0 | i386 | pentium, TCG | 128 | pcnet | cirrus | sb16 |
| `win2000` | 2000 | i386 | qemu32, KVM | 384 | rtl8139 | cirrus | sb16 |
| `winxp` | XP | `qemu-system-x86_64` | qemu64, KVM | 512 | rtl8139 | cirrus | ac97 |
| `winvista` | Vista | x86_64 | host, KVM | 1024 | e1000 | std | ac97 |
| `win7` | 7 | x86_64 | host, KVM | 2048 | e1000 | std | ac97 |
| `win81` | 8.1 | x86_64 | host, KVM | 2048 | e1000 | std | hda |
| `win10` | 10 | x86_64 | host, KVM | 2048 | e1000 | std | hda |

Windows 11 needs TPM 2.0 and is a later guest. 9x/NT4 stay on TCG
(`pentium` under KVM is a poor fit). 2000 and later use KVM on this
workstation. HPET is off. RTC is localtime. Boot order is HD, CD,
floppy (`menu=on`). Empty disks reach SeaBIOS instead of exiting.

Flags follow the [QEMU Windows 95](https://wiki.qemu.org/Documentation/GuestOperatingSystems/Windows95)
and [Windows 2000](https://wiki.qemu.org/Windows2000) notes, plus
[hectorm/docker-qemu-win2000](https://github.com/hectorm/docker-qemu-win2000)
(cirrus + rtl8139 + pc). QEMU 10 has no `-soundhw`; audio is
`-audiodev none` plus `sb16` / `AC97` / `intel-hda`.

## Media

| File | What |
| --- | --- |
| `win95.iso` / `win95.img` | 95 CD and optional boot floppy |
| `win98.iso` | 98 SE CD |
| `winme.iso` | Me CD |
| `winnt4.iso` | NT 4.0 CD |
| `win2000.iso` | 2000 CD |
| `winxp.iso` | XP CD |
| `winvista.iso` | Vista DVD |
| `win7.iso` | 7 DVD |
| `win81.iso` | 8.1 DVD |
| `win10.iso` | 10 ISO |

Empty `win95.qcow2` … `win10.qcow2` are created on first boot.

```sh
./scripts/alt-hosts.sh up win95
```

noVNC: http://127.0.0.1:6130/vnc.html

Do not auto-start the whole chain (RAM). XP and later also publish
RDP on host `3335`–`3339` (guest 3389) once an install enables it.
