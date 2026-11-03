# Haiku notes

The grok-bot VM on `m4-casa` already installed Haiku R1/beta6 into
`haiku-r1beta6-x86_64.qcow2` using TCG (nested KVM was broken there). This
host uses KVM when `/dev/kvm` is readable.

Original command (TCG, VNC `:1`):

```sh
qemu-system-x86_64 \
  -name haiku-r1beta6 \
  -machine type=pc,accel=tcg \
  -cpu qemu64 \
  -m 2048 \
  -smp 2 \
  -drive file=haiku-r1beta6-x86_64.qcow2,format=qcow2,if=ide,index=0,media=disk \
  -netdev user,id=net0 \
  -device rtl8139,netdev=net0 \
  -usb -device usb-tablet \
  -vga std \
  -display none \
  -vnc 127.0.0.1:1
```

`guests/haiku/qemu-haiku.sh` keeps that device set and only swaps in KVM/host
CPU when possible.

Third-party wrapper: https://github.com/hectorm/docker-qemu-haiku
(`docker.io/hectorm/qemu-haiku`) with SSH on 2222 and noVNC on 6080.
