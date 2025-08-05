#!/bin/bash

# WARNING: This script will erase all data on /dev/sdX. Double-check your device.
DISK="/dev/sdX"

# Unmount all mounted partitions on the disk
sudo umount ${DISK}* 2>/dev/null

# Create a new partition table
# Create BOOT partition: msdos 256MB, FAT32
sudo parted -s "$DISK" mklabel msdos mkpart primary fat32 1M 100M

# Create ROOT partition: remaining space, ext4
sudo parted -s "$DISK" mkpart primary ext4 100 100%

# Wait a moment for the kernel to recognize the new partitions
sleep 2

# Format the partitions
sudo mkfs.vfat -F32 "${DISK}1"
sudo mkfs.ext4 "${DISK}2"

sudo fatlabel ${DISK}1 boot  # for NTFS Partition
sudo e2label ${DISK}2 root   # for ext4 Partition

lsblk -f
du 

# Mounting the BOOT partition:
echo "Mounting the BOOT Partion"
sudo mkdir -p /media/aaaziz/boot
sudo mount ${DISK}1 /media/aaaziz/boot
du -h /media/aaaziz/boot

# Mounting the ROOT partition:
echo "Monting the ROOT Partion"
sudo mkdir -p /media/aaaziz/root
sudo mount ${DISK}2 /media/aaaziz/root
du -h /media/aaaziz/root


echo "Partitioning complete. BOOT: ${DISK}1, ROOT: ${DISK}2"


