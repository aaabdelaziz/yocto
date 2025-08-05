#!/bin/bash

# Simple SD Card Setup Script for Raspberry Pi 4
# Cleans existing files, copies boot files, and extracts root filesystem

# Uncomment for debugging
# set -e
# set -x

# Configuration
DEVICE="/dev/sdb"
USER_HOME="$HOME/yocto-project"
IMAGE_DIR="$USER_HOME/yocto/poky/build/tmp/deploy/images/raspberrypi4-64"

# Correct way to set OVERLAYS_DIR without wildcards in path
OVERLAYS_DIR="$USER_HOME/yocto/poky/build/tmp/work/raspberrypi4_64-poky-linux/rpi-bootfiles"

# Mount points
BOOT_MOUNT="/media/aaaziz/boot"
ROOT_MOUNT="/media/aaaziz/root"

echo "=== Simple SD Card Setup ==="
echo "Device: $DEVICE"
echo "Build files: $IMAGE_DIR"
echo

# # Step 1: Clean mounted target directories
# echo "Step 1: Cleaning mount points..."
sudo rm -rf "$BOOT_MOUNT"/*
sudo rm -rf "$ROOT_MOUNT"/*
echo "Partitions cleaned."

# Step 2: Find overlays and copy
echo "Step 2: Copying overlay files..."

# Find overlays
echo "************** Finding overlays *******************"
overlays=$(find "$OVERLAYS_DIR" -name "overlays")
echo "$overlays"

if [ -z "$overlays" ]; then
  echo "No overlays found."
else
  echo "Overlays found, copying..."
  sudo cp -rf $overlays "$BOOT_MOUNT/"
fi

# Change directory to IMAGE_DIR for rsync
cd "$IMAGE_DIR" || { echo "Failed to change directory to $IMAGE_DIR"; exit 1; }

# Copy essential boot files with `rsync` and options to avoid issues with permissions/symlinks
sudo rsync -a --progress --no-links bcm2711-rpi-4-b.dtb "$BOOT_MOUNT/"
sudo rsync -a --progress --copy-links --no-perms --no-owner --no-group --no-times Image-raspberrypi4-64.bin "$BOOT_MOUNT/"
sudo rsync -a --progress --copy-links --no-perms --no-owner --no-group --no-times Image "$BOOT_MOUNT/"

# Copy additional boot files
echo "************** copying bootfiles *******************"
sudo rsync -a --progress --copy-links --no-perms --no-owner --no-group --no-times bootfiles/* "$BOOT_MOUNT/"

# # Uncomment if needed:
# sudo cp config.txt "$BOOT_MOUNT/"
# sudo cp cmdline.txt "$BOOT_MOUNT/"
# sudo cp Image "$BOOT_MOUNT/"
# sudo cp fixup4*.dat "$BOOT_MOUNT/"
# sudo cp start4*.elf "$BOOT_MOUNT/"
# sudo cp *.dtbo "$BOOT_MOUNT/" 2>/dev/null || true

echo "Boot files copied."

# Step 3: Extract root filesystem
echo "Step 3: Extracting root filesystem..."
# Compute the correct rootfs tarball filename (pick the latest)
# Find the latest tar.bz2 archive
rootfs_tarball=$(ls -t "$USER_HOME/yocto/poky/build/tmp/deploy/images/raspberrypi4-64"/core-image-minimal-raspberrypi4-64-*.tar.bz2 | head -n 1)

if [ -f "$rootfs_tarball" ]; then
  echo "Extracting $rootfs_tarball..."
  sudo tar -xjf "$rootfs_tarball" -C "$ROOT_MOUNT"
else
  echo "Rootfs tarball not found!"
  exit 1
fi

# Verify the tarball
ls "$USER_HOME/yocto/poky/build/tmp/deploy/images/raspberrypi4-64"/*rootfs.tar.bz2

echo "Root filesystem extracted."

# Step 4: Fix cmdline.txt
echo "Step 4: Fixing cmdline.txt..."
if [ -f "$BOOT_MOUNT/cmdline.txt" ]; then
  sudo sed -i 's/console=ttyUSB0/console=tty1/g' "$BOOT_MOUNT/cmdline.txt"
  echo "cmdline.txt fixed."
else
  echo "cmdline.txt not found at $BOOT_MOUNT"
fi

# Step 5: Sync and finish
echo "Step 5: Syncing files..."
sync
echo "Done!"

echo
echo "SD card is ready. You can now:"
echo "1. Safely eject the SD card"
echo "2. Insert into Raspberry Pi 4"
echo "3. Connect serial
