#!/bin/bash

# === CONFIGURATION ===
YOCTO_DIR="yocto"
POKY_REPO="git://git.yoctoproject.org/poky"
POKY_BRANCH="kirkstone"

META_OE_REPO="https://github.com/openembedded/meta-openembedded.git"
META_OE_BRANCH="kirkstone"

META_RPI_REPO="https://github.com/agherzan/meta-raspberrypi.git"
META_RPI_BRANCH="kirkstone"

# === BEGIN SCRIPT ===

echo "Creating Yocto directory: $YOCTO_DIR"
mkdir -p "$YOCTO_DIR"
cd "$YOCTO_DIR" || exit 1

# Clone Poky
if [ ! -d "poky" ]; then
    echo "Cloning Poky..."
    git clone -b "$POKY_BRANCH" "$POKY_REPO"
else
    echo "Poky already exists. Skipping clone."
fi

cd poky || exit 1

# Clone meta-openembedded
if [ ! -d "meta-openembedded" ]; then
    echo "Cloning meta-openembedded..."
    git clone -b "$META_OE_BRANCH" "$META_OE_REPO"
else
    echo "meta-openembedded already exists. Skipping clone."
fi

# Clone meta-raspberrypi
if [ ! -d "meta-raspberrypi" ]; then
    echo "Cloning meta-raspberrypi..."
    git clone -b "$META_RPI_BRANCH" "$META_RPI_REPO"
else
    echo "meta-raspberrypi already exists. Skipping clone."
fi

# List folders to confirm
echo "Your layers:"
#ls -d */
tree -L 1
