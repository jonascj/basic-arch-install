#!/bin/zsh
set -x
set -e

## Format partitions
## Change these to match your layout
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/vg0/lv-root
mkfs.ext4 /dev/vg0/lv-home
mkswap /dev/vg0/lv-swap


## Mount and activate swap
mount -t ext4 /dev/vg0/lv-root /mnt

mkdir /mnt/home
mount -t ext4 /dev/vg0/lv-home /mnt/home

mkdir -p /mnt/boot/efisys
mount -t vfat /dev/sda1 /mnt/boot/efisys

swapon /dev/vg0/lv-swap


## Mirrors
## Change this to a mirror of your choice
echo 'Server = http://mirror.one.com/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist


## Install base system
pacstrap /mnt base


## Configure the system

# fstab
genfstab -p /mnt >> /mnt/etc/fstab
