#!/bin/sh

## Format partitions
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/vg0/lv-root
mkfs.ext4 /dev/vg0/lv-home
mkswap /dev/vg0/lv-swap



## Mount root, home and activate swap
mount -t ext4 /dev/vg0/lv-root /mnt
mkdir /mnt/home
mount -t ext4 /dev/vg0/lv-home /mnt/home
swapon /dev/vg00/lvswap

## Mirrors
echo '#Server = http://mirror.one.com/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist



## Install base system
pacstrap /mnt base



## Configure the system

# fstab
genfstab -p /mnt >> /mnt/etc/fstab
