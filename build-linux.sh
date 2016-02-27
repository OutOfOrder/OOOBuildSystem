#!/bin/bash

dir=$PWD
arch=$1
shift

if [ -z "$arch" ]; then
    echo "Specify if 32 or 64 arch"
    exit 1
fi

if [ "$arch" = "32" ]; then
    suffix="x86"
    libroot="lib"
else
    suffix="x86_64"
    libroot="lib64"
fi

cmake_build_system="Unix Makefiles"

if [ -r ./mock-config.txt ]; then
    . ./mock-config.txt
else
    echo "Missing mock-config.txt"
    exit 1
fi

if [ $arch -eq 32 ]; then
    arch_options=$cmake_options32
elif [ $arch -eq 64 ]; then
    arch_options=$cmake_options64
else
    echo "Pick a correct arch (32 or 64)"
    exit 2
fi

root=`mock -r $ROOT --print-root-path`/builddir

if [ ! -d "$root" ]; then
    echo "mock root not prepared."
    echo "Please run ./mock-prep.sh $arch init"
    exit 3
fi

CPU_COUNT=1
if type nproc 2>&1 > /dev/null; then
    CPU_COUNT=`nproc`
    CPU_COUNT=$(( ${CPU_COUNT} - 1 ))
    echo "Building using $CPU_COUNT simultaneous jobs"
fi

build_clean=""
build_type=""
builddir_suffix=""
finaldir_suffix=""
build_opts=""

while [ ! -z "$1" ]; do
    case "$1" in
        clean)
        build_clean="--clean-first"
        ;;
        [Dd]ebug)
        build_type="Debug"
        echo "Setting build type to Debug"
        ;;
        [Rr]elease)
        build_type="Release"
        echo "Setting build type to Release"
        ;;
        [Rr]el[Dd]ebug)
        build_type="RelWithDebInfo"
        echo "Setting build type to RelWithDebInfo"
        ;;
        steam)
        build_steam=1
        builddir_suffix=-steam
        finaldir_suffix=Steam
        build_opts=$cmake_steam_options
        echo "Enabling steam build"
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
./mock-sync.sh

build_dir=build-$build_type-$arch$builddir_suffix

cat > $root/$dst_root/build.sh <<EOSCRIPT
#!/bin/sh
cd /builddir/$dst_root

mkdir -p $build_dir
cd $build_dir
    cmake -G$cmake_build_system $cmake_path -DCMAKE_BUILD_TYPE=$build_type $cmake_options $build_opts $arch_options
    cmake --build . $build_clean -- -j$CPU_COUNT
cd ..
EOSCRIPT

echo "Starting build in 2 seconds"
sleep 2

./mock-shell.sh -- "bash /builddir/$dst_root/build.sh"

if [ -z "$final_dest" ]; then
    final_dest=.
fi
mkdir -p $final_dest/$build_type$finaldir_suffix/

cp $root/$dst_root/$build_dir/*.bin.$suffix $final_dest/$build_type$finaldir_suffix/
cp -a $root/$dst_root/$build_dir/$libroot $final_dest/$build_type$finaldir_suffix/

