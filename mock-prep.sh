#!/bin/bash

PREFIX=`dirname "$0"`

if [ -r ./mock-config.txt ]; then
    echo "Reading ./mock-config.txt"
    . ./mock-config.txt
else
    echo "Missig mock-config.txt"
    exit 1
fi

if [ "$1" == "init" ]; then
    mock -r $ROOT --init
    shift
fi

dual_arch_packages="pkgconfig mesa-libGLU-devel mesa-libGL-devel glibc-devel zlib-devel \
    libX11-devel libXrandr-devel libXmu-devel libXi-devel libXext-devel libXft-devel \
    alsa-lib-devel pulseaudio-devel libXinerama-devel libuuid-devel"

arch_packages=""
for x in $dual_arch_packages; do
    arch_packages="$arch_packages $x.i686 $x.x86_64"
done

mock -r $ROOT --install ccache dos2unix \
    ${arch_packages} \
    RPMS/*.rpm $EXTRA \
    vim-enhanced  \
    $*

