#!/bin/sh
set -eu
root="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
cd "$root"

fail=0
for script in \
    scripts/check.sh \
    scripts/alt-hosts.sh \
    scripts/pull-media.sh \
    scripts/bootstrap-qemumac.sh \
    guests/entrypoint.sh \
    guests/macos-ppc/qemu-macos-ppc.sh \
    guests/macos-m68k/qemu-macos-m68k.sh \
    guests/macos9/qemu-macos9.sh \
    guests/haiku/qemu-haiku.sh
do
    if ! sh -n "$script"; then
        echo "syntax: $script" >&2
        fail=1
    fi
done

if command -v docker >/dev/null 2>&1; then
    if [ -f "$root/.env" ]; then
        COMPOSE_ENV_FILES="$root/.env"
    else
        COMPOSE_ENV_FILES="$root/.env.example"
    fi
    export COMPOSE_ENV_FILES
    docker compose -f "$root/compose.yaml" config >/dev/null
else
    echo "docker not on PATH; skipped compose config" >&2
fi

test -f "$root/VERSION"
test -f "$root/LICENSE"
test -f "$root/compose.yaml"

if [ "$fail" -ne 0 ]; then
    exit 1
fi
echo "alt-hosts check ok"
