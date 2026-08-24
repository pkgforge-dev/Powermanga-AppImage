#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
#pacman -Syu --noconfirm

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
PRE_BUILD_CMDS="sed -i 's/ --prefix=\/usr//; s|usr/games|usr/local/share/games|' ./PKGBUILD" make-aur-package powermanga --overwrite "/usr/local/share/man/*"
mkdir -p ./AppDir/bin
mv -v /usr/bin/powermanga ./AppDir/bin
mv -v /usr/share/games/powermanga/* ./AppDir/bin

# If the application needs to be manually built that has to be done down here
