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



## Install base system
pacstrap /mnt base



## Configure the system

# fstab
genfstab -p /mnt >> /mnt/etc/fstab

#chroot and do the configuration in the chroot
wget http://wuhtzu.dk/random/archinstall2.sh -O /mnt/archinstall2.sh
chmod +x /mnt/archinstall2.sh
arch-chroot /mnt ./archinstall2.sh

# back from chroot
# unmount and restart
umount -R /mnt
reboot