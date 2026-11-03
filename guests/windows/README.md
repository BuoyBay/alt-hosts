# Windows 95–10 (QEMU)

Shared launcher `qemu-windows.sh`. Compose services `win95` … `win10`.
Microsoft ISOs are operator-supplied and are not in git.

| Service | Guest | QEMU | Ports |
| --- | --- | --- | --- |
| `win95` | Windows 95 | i386, pentium, TCG | VNC 5930, noVNC 6130 |
| `win98` | Windows 98 SE | i386, pentium2, TCG | VNC 5931, noVNC 6131 |
| `winme` | Windows Me | i386, pentium3, TCG | VNC 5932, noVNC 6132 |
| `winnt4` | Windows NT 4.0 | i386, pentium, TCG | VNC 5933, noVNC 6133 |
| `win2000` | Windows 2000 | i386, qemu32, KVM | VNC 5934, noVNC 6134 |
| `winxp` | Windows XP | x86_64, qemu64, KVM | VNC 5935, noVNC 6135, RDP 3335 |
| `winvista` | Windows Vista | x86_64, host, KVM | VNC 5936, noVNC 6136, RDP 3336 |
| `win7` | Windows 7 | x86_64, host, KVM | VNC 5937, noVNC 6137, RDP 3337 |
| `win81` | Windows 8.1 | x86_64, host, KVM | VNC 5938, noVNC 6138, RDP 3338 |
| `win10` | Windows 10 | x86_64, host, KVM | VNC 5939, noVNC 6139, RDP 3339 |

Place `win95.iso` (and optional `win95.img` boot floppy) in `media/`.
Notes: [docs/windows.md](../../docs/windows.md).
