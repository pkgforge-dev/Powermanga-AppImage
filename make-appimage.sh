#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook:wayland-is-broken.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/brunonymous/Powermanga/refs/heads/master/images_for_menu_entry/powermanga_48x48.png
export DESKTOP=https://raw.githubusercontent.com/brunonymous/Powermanga/refs/heads/master/powermanga.desktop
export STARTUPWMCLASS=powermanga
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun ./AppDir/bin/powermanga /usr/lib/libmodplug.so*
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
