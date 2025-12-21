#!/bin/sh

# You might need to restart your pc if sharun doesn't create `AppDir` in this directory (It should create dirs on its own)
set -eu

ARCH="$(uname -m)"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

export ADD_HOOKS="self-updater.bg.hook"
#export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export OUTNAME=protocol_10-anylinux-"$ARCH".AppImage
export DESKTOP=protocol_10.desktop
export ICON=https://raw.githubusercontent.com/Twig6943/Protocol-10/refs/heads/main/protocol_10.png
export DEPLOY_OPENGL=0
export DEPLOY_VULKAN=0
export DEPLOY_DOTNET=0

#Remove leftovers
rm -rf AppDir dist

# ADD LIBRARIES
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun

# Point to your binaries
./quick-sharun ./linux-$(uname -m)/protocol_10 /AppDir/bin/protocol_10

# Copy rest safely
for ext in so; do
    cp -v ./*.$ext ./AppDir/bin/ 2>/dev/null || :
done

# Copy exec
cp ./linux-$(uname -m)/protocol_10 ./AppDir/bin/

# Make AppImage
./quick-sharun --make-appimage

mkdir -p ./dist
mv -v ./*.AppImage* ./dist

echo "All Done!"
