# syntax=docker/dockerfile:1
FROM debian:trixie-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        novnc \
        ovmf \
        procps \
        python3-websockify \
        qemu-system-misc \
        qemu-system-ppc \
        qemu-system-x86 \
        qemu-utils \
    && rm -rf /var/lib/apt/lists/*

COPY guests/entrypoint.sh /usr/local/bin/entrypoint
COPY guests/macos-ppc/qemu-macos-ppc.sh /usr/local/bin/qemu-macos-ppc
COPY guests/macos-m68k/qemu-macos-m68k.sh /usr/local/bin/qemu-macos-m68k
COPY guests/macos9/qemu-macos9.sh /usr/local/bin/qemu-macos9
COPY guests/haiku/qemu-haiku.sh /usr/local/bin/qemu-haiku
COPY guests/macosx-intel/qemu-macosx-intel.sh /usr/local/bin/qemu-macosx-intel
RUN chmod 0755 \
    /usr/local/bin/entrypoint \
    /usr/local/bin/qemu-macos-ppc \
    /usr/local/bin/qemu-macos-m68k \
    /usr/local/bin/qemu-macos9 \
    /usr/local/bin/qemu-haiku \
    /usr/local/bin/qemu-macosx-intel

WORKDIR /media
EXPOSE 5900 6080 2222
STOPSIGNAL SIGTERM
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["macos9"]
