# syntax=docker/dockerfile:1
FROM debian:trixie-slim AS minivmac
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        gcc \
        git \
        libc6-dev \
        libx11-dev \
        make \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /src
RUN git clone --depth 1 https://github.com/minivmac/minivmac.git .
COPY guests/minivmac/build.sh /tmp/build-minivmac.sh
RUN sh /tmp/build-minivmac.sh

FROM debian:trixie-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        libx11-6 \
        novnc \
        ovmf \
        procps \
        python3-websockify \
        qemu-system-misc \
        qemu-system-ppc \
        qemu-system-x86 \
        qemu-utils \
        x11vnc \
        xvfb \
    && rm -rf /var/lib/apt/lists/*

COPY --from=minivmac /out/minivmac-plus /usr/local/bin/minivmac-plus
COPY --from=minivmac /out/minivmac-128k /usr/local/bin/minivmac-128k
COPY guests/entrypoint.sh /usr/local/bin/entrypoint
COPY guests/macos-ppc/qemu-macos-ppc.sh /usr/local/bin/qemu-macos-ppc
COPY guests/macos-m68k/qemu-macos-m68k.sh /usr/local/bin/qemu-macos-m68k
COPY guests/macos9/qemu-macos9.sh /usr/local/bin/qemu-macos9
COPY guests/haiku/qemu-haiku.sh /usr/local/bin/qemu-haiku
COPY guests/macosx-intel/qemu-macosx-intel.sh /usr/local/bin/qemu-macosx-intel
COPY guests/minivmac/minivmac-macos.sh /usr/local/bin/minivmac-macos
RUN chmod 0755 \
    /usr/local/bin/entrypoint \
    /usr/local/bin/qemu-macos-ppc \
    /usr/local/bin/qemu-macos-m68k \
    /usr/local/bin/qemu-macos9 \
    /usr/local/bin/qemu-haiku \
    /usr/local/bin/qemu-macosx-intel \
    /usr/local/bin/minivmac-macos \
    /usr/local/bin/minivmac-plus \
    /usr/local/bin/minivmac-128k

WORKDIR /media
EXPOSE 5900 6080 2222
STOPSIGNAL SIGTERM
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["macos9"]
