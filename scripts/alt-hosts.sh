#!/bin/sh
set -eu
root="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
cd "$root"
# This host exports COMPOSE_ENV_FILES=/opt/stacks/.env.common,.env.
# Keep compose self-contained.
if [ -f "$root/.env" ]; then
    COMPOSE_ENV_FILES="$root/.env"
else
    COMPOSE_ENV_FILES="$root/.env.example"
fi
export COMPOSE_ENV_FILES

compose() {
    docker compose -f "$root/compose.yaml" "$@"
}

usage() {
    echo "usage: $0 check|pull-media|bootstrap-qemumac|up [guest]|down [guest]|status|logs [guest]" >&2
    echo "guests: macos9 (default) | haiku" >&2
    exit 2
}

cmd="${1:-}"
if [ "$#" -gt 0 ]; then
    shift
fi

case "$cmd" in
    check)
        exec "$root/scripts/check.sh"
        ;;
    pull-media)
        exec "$root/scripts/pull-media.sh" "$@"
        ;;
    bootstrap-qemumac)
        exec "$root/scripts/bootstrap-qemumac.sh" "$@"
        ;;
    up)
        guest="${1:-macos9}"
        compose up --build -d "$guest"
        echo "noVNC: macos9 http://127.0.0.1:6099/vnc.html  haiku http://127.0.0.1:6011/vnc.html"
        ;;
    down)
        if [ "$#" -gt 0 ]; then
            compose stop "$1"
        else
            compose down
        fi
        ;;
    status)
        compose ps
        ;;
    logs)
        guest="${1:-macos9}"
        compose logs -f "$guest"
        ;;
    *)
        usage
        ;;
esac
