#!/bin/sh

## Format partitions
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/vg00/lvroot
mkfs.ext4 /dev/vg00/lvhome



## Mount root, home and activate swap
mount -t ext4 /dev/vg00/lvroot /mnt
mkdir /mnt/home
mount -t ext4 /dev/vg00/lvhome /mnt/home
swapon /dev/vg00/lvswap


## Place the archinstall2.sh script
## at the root of the new filesystem
cp ./archinstall2.sh /mnt/archinstall2.sh
cp ./grub.cfg /mnt/grub.cfg
chmod +x /mnt/archinstall2.sh

## Update mirror list before installing basesystem
## The updated mirror list file is copied to the installed system
pacman --noconfirm -S reflector
reflector -l 20 -p http --sort rate --save /etc/pacman.d/mirrorlist


## Install base system
pacstrap /mnt base



## Configure the system

# fstab
genfstab -p /mnt >> /mnt/etc/fstab
