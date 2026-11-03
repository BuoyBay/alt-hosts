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
    echo "usage: $0 check|pull-media|bootstrap-qemumac|bootstrap-legacyosxkvm|up [guest]|down [guest]|status|logs [guest]" >&2
    echo "guests: macos9 macos921 macos91 macos904 macosx106 macosx105 macosx104 macosx103 macosx102 macosx101 macosx100 macos76 macos75 macos6 macos5 macos4 macos3 macos2 macos1 win95 win98 winme winnt4 win2000 winxp winvista win7 win81 win10 haiku" >&2
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
    bootstrap-legacyosxkvm)
        exec "$root/scripts/bootstrap-legacyosxkvm.sh" "$@"
        ;;
    up)
        guest="${1:-macos9}"
        compose up --build -d "$guest"
        echo "noVNC:"
        echo "  macos9   http://127.0.0.1:6099/vnc.html"
        echo "  macos921 http://127.0.0.1:6092/vnc.html"
        echo "  macos91  http://127.0.0.1:6091/vnc.html"
        echo "  macos904  http://127.0.0.1:6094/vnc.html"
        echo "  macosx106 http://127.0.0.1:6098/vnc.html"
        echo "  macosx105 http://127.0.0.1:6097/vnc.html"
        echo "  macosx104 http://127.0.0.1:6093/vnc.html"
        echo "  macosx103 http://127.0.0.1:6123/vnc.html"
        echo "  macosx102 http://127.0.0.1:6122/vnc.html"
        echo "  macosx101 http://127.0.0.1:6121/vnc.html"
        echo "  macosx100 http://127.0.0.1:6120/vnc.html"
        echo "  macos76   http://127.0.0.1:6096/vnc.html"
        echo "  macos75  http://127.0.0.1:6095/vnc.html"
        echo "  macos6    http://127.0.0.1:6116/vnc.html"
        echo "  macos5    http://127.0.0.1:6115/vnc.html"
        echo "  macos4    http://127.0.0.1:6114/vnc.html"
        echo "  macos3    http://127.0.0.1:6113/vnc.html"
        echo "  macos2    http://127.0.0.1:6112/vnc.html"
        echo "  macos1    http://127.0.0.1:6110/vnc.html"
        echo "  win95    http://127.0.0.1:6130/vnc.html"
        echo "  win98    http://127.0.0.1:6131/vnc.html"
        echo "  winme    http://127.0.0.1:6132/vnc.html"
        echo "  winnt4   http://127.0.0.1:6133/vnc.html"
        echo "  win2000  http://127.0.0.1:6134/vnc.html"
        echo "  winxp    http://127.0.0.1:6135/vnc.html"
        echo "  winvista http://127.0.0.1:6136/vnc.html"
        echo "  win7     http://127.0.0.1:6137/vnc.html"
        echo "  win81    http://127.0.0.1:6138/vnc.html"
        echo "  win10    http://127.0.0.1:6139/vnc.html"
        echo "  haiku    http://127.0.0.1:6111/vnc.html"
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
