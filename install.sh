#!/bin/zsh
exec > >(tee ./tmp/install.log)
exec 2>&1
set -x
set -e

## Execute permission 
chmod +x outside-arch-chroot.sh


## Before arch-chroot
./outside-arch-chroot.sh #2>&1 | tee ./tmp/archinstall1.log


## Place the inside-arch-chroot.sh script
## at the root of the new filesystem (/mnt)
cp ./inside-arch-chroot.sh /mnt
chmod +x /mnt/inside-arch-chroot.sh 

## Inside chroot
arch-chroot /mnt /bin/bash -c /inside-arch-chroot.sh

## remove the inside-arch-chroot.sh script from /mnt (the new root)
rm -f /mnt/inside-arch-chroot.sh

# Unmount and restart
umount -R /mnt

read -q "key?Reboot [Yyn]? "
if [[ "$key" =~ ^[Yy]$ ]]
then
    reboot
fi
