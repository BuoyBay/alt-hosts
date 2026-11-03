#!/bin/sh
# Compile Mini vMac Plus and 128K X11 binaries. Run from the minivmac
# source tree inside the Docker build stage.
set -eu
mkdir -p /out
gcc -o setup_t setup/tool.c

build_one() {
    model="$1"
    dest="$2"
    rm -rf bld minivmac Makefile cfg
    ./setup_t \
        -t lx64 \
        -m "$model" \
        -e bgc \
        -api xwn \
        -sound 0 \
        -magnify 1 \
        -mf 2 \
        -bg 1 \
        -n "$dest" \
        > setup.sh
    bash ./setup.sh
    make -j"$(nproc)"
    test -x ./minivmac
    cp ./minivmac "/out/$dest"
}

build_one Plus minivmac-plus
build_one 128K minivmac-128k
ls -l /out
