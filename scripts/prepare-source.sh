#!/usr/bin/env bash
# Prepare the exact OpenWrt tree used by this repository.
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
src_dir=${1:-"$PWD/openwrt-25.12"}
base_commit=60c494ad065fe3fcaeadf0e9ff4a8a2dc6e6be43

if [ "$(uname -s)" = Darwin ]; then
  echo "OpenWrt must be built in a Linux VM, container, or CI; macOS system make/awk/bash are unsupported." >&2
  exit 2
fi

if [ ! -d "$src_dir/.git" ]; then
  # Keep the complete commit graph, but fetch blobs on demand. This makes a
  # clean checkout much smaller while still allowing a pinned detached commit.
  git clone --filter=blob:none --no-checkout --branch openwrt-25.12 \
    https://github.com/openwrt/openwrt.git "$src_dir"
fi

git -C "$src_dir" fetch --filter=blob:none origin "$base_commit"
git -C "$src_dir" checkout --detach "$base_commit"
git -C "$src_dir" clean -fdx

for patch in "$repo_dir"/patches/*.patch; do
  git -C "$src_dir" apply --check "$patch"
  git -C "$src_dir" apply "$patch"
done

cd "$src_dir"
./scripts/feeds update -a
./scripts/feeds install -a
cp "$repo_dir/config/kn4010.config" .config
make defconfig

echo "Prepared: $src_dir"
