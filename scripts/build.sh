#!/usr/bin/env bash
# Build all KN-4010 images after scripts/prepare-source.sh.
set -euo pipefail

src_dir=${1:-"$PWD/openwrt-25.12"}
jobs=${JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu)}

cd "$src_dir"
make -j"$jobs" download
make -j"$jobs" V=s

bin_dir=bin/targets/mediatek/filogic
printf '\nImages:\n'
find "$bin_dir" -maxdepth 1 -type f -name '*keenetic_kn-4010*' -print | sort
