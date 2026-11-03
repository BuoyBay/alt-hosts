# Mac OS X 10.6 Snow Leopard (Intel)

`qemu-macosx-intel.sh` launches retail Snow Leopard on
`qemu-system-x86_64` with OVMF pflash and an OpenCore boot disk. Compose
service `macosx106`.

## Media

| File | Role |
| --- | --- |
| `macosx106-oc.qcow2` | OpenCore EFI (from LegacyOSXKVM; required) |
| `macosx106.qcow2` | empty 16G HDD, created on first boot |
| `macosx106.iso` | optional Install DVD |
| `macosx106-vars.fd` | OVMF VARS, created on first boot |

```sh
./scripts/bootstrap-legacyosxkvm.sh
./scripts/pull-media.sh
./scripts/alt-hosts.sh up macosx106
```

## Access

- noVNC: http://127.0.0.1:6098/vnc.html
- VNC: `127.0.0.1:5908`
- SSH (after Remote Login): `127.0.0.1:2216`

Notes: [docs/macosx.md](../../docs/macosx.md).
