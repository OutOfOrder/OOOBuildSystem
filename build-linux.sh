#!/bin/bash

dir=$PWD
arch=$1
shift

if [ -z "$arch" ]; then
    echo "Specify if 32 or 64 arch sync"
    exit 1
fi

if [ "$arch" = "32" ]; then
    suffix="x86"
    libroot="lib"
else
    suffix="x86_64"
    libroot="lib64"
fi

if [ -r ./mock-config.txt ]; then
    . ./mock-config.txt
else
    echo "Missing mock-config.txt"
    exit 1
fi

if [ $arch -eq 32 ]; then
    ROOT=$ROOT32
elif [ $arch -eq 64 ]; then
    ROOT=$ROOT64
else
    echo "Pick a correct sync arch (32 or 64)"
    exit 2
fi

root=`mock -r $ROOT --print-root-path`/builddir

if [ ! -d "$root" ]; then
    echo "mock root not prepared."
    echo "Please run ./mock-prep.sh $arch init"
    exit 3
fi

build_clean=""
build_type=""

while [ ! -z "$1" ]; do
    case "$1" in
        clean)
        build_clean="clean"
        ;;
        debug)
        build_type="Debug"
        echo "Setting build type to Debug"
        ;;
        release)
        build_type="Release"
        echo "Setting build type to Release"
        ;;
        reldebug)
        build_type="RelWithDebInfo"
        echo "Setting build type to RelWithDebInfo"
        ;;
    esac
    shift
done

if [ -z "${build_type}" ]; then
    echo "Please specify the build type..   debug, release, reldebug"
    exit 4
fi

echo "Syncing code in 2 seconds"
sleep 2
./mock-sync.sh $arch

cat > $root/$dst_root/build.sh <<EOSCRIPT
cd /builddir/$dst_root

mkdir -p build
cd build
    cmake $cmake_path -DCMAKE_BUILD_TYPE=$build_type $cmake_options
    make -j4 $build_clean all
cd ..
EOSCRIPT

echo "Starting build in 2 seconds"
sleep 2

./mock-shell.sh $arch -- "cd builddir/$dst_root; bash ./build.sh;"

mkdir -p ./Release/
cp $root/$dst_root/build/*.bin.$suffix ./Release/
cp -a $root/$dst_root/build/$libroot ./Release/
