#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake      \
    ninja      \
    patch      \
    sdl2_mixer

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Building Powermanga..."
echo "---------------------------------------------------------------"
REPO="https://github.com/brunonymous/Powermanga"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
echo "$VERSION" > ./LATEST_VERSION
git clone --depth 1 "$REPO" ./Powermanga

cd ./Powermanga
# CMake build has no PREFIX fallback (autotools passes it via src/Makefile.am)
patch -Np1 -i ../powermanga-prefix-fallback.patch
cmake -Bbuild -GNinja                    \
    -DCMAKE_BUILD_TYPE=Release           \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5   \
    -DPOWERMANGA_SDL=ON                  \
    -DPOWERMANGA_SDL2=ON                 \
    -DUSE_SDLMIXER=ON
cmake --build build

mkdir -p ../AppDir/bin
mv -v build/powermanga ../AppDir/bin
cp -vr graphics sounds texts data ../AppDir/bin
