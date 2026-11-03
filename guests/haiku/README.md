# Haiku R1/beta6 guest

x86_64 Haiku in QEMU, using the disk built on the grok-bot VM and kept at
`m4-casa:/Volumes/Depot/grok/workspace/haiku/`.

That launcher used TCG because nested KVM on the bot VM hit a kernel BUG.
This Debian workstation has `/dev/kvm`; `qemu-haiku.sh` turns KVM on when
the device is readable and falls back to TCG otherwise.

## Media

| File | Role |
| --- | --- |
| `haiku-r1beta6-x86_64.qcow2` | Overlay on the anyboot ISO (required) |
| `haiku-r1beta6-x86_64-anyboot.iso` | Official anyboot ISO (backing file) |

The grok qcow2 is not a standalone disk; QEMU needs the ISO beside it.
`scripts/pull-media.sh` copies both and rebases the overlay onto a relative
path. `qemu-haiku.sh` does the same rebase if the original
`/workspace/haiku/...` backing path is missing.

Official images: https://www.haiku-os.org/get-haiku/ and
https://download.haiku-os.org/

## Access

- noVNC: http://127.0.0.1:6111/vnc.html
- VNC: `127.0.0.1:5911`
- SSH forward `2211` is published for a later sshd setup on the guest
  (`user` is Haiku's default account)

A maintained third-party image, `hectorm/qemu-haiku`, is an alternative
CI wrapper. This repo keeps first-party launch flags so the Depot disk
boots as it did on the grok VM.
