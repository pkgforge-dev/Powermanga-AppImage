#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q powermanga | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/pixmaps/powermanga.png
export DESKTOP=/usr/share/applications/powermanga.desktop
export STARTUPWMCLASS=
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun ./AppDir/bin/powermanga
#echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --test ./dist/*.AppImage
