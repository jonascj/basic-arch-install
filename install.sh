#!/bin/zsh
exec > >(tee ./tmp/install.log)
exec 2>&1
set -x
set -e

## Execute permission 
chmod +x outside-arch-chroot.sh


## Before arch-chroot
./outside-arch-chroot.sh #2>&1 | tee ./tmp/archinstall1.log

## Place the archinstall2.sh script and grub.cfg
## at the root of the new filesystem (/mnt)
cp ./inside-arch-chroot.sh /mnt
cp ./grub.cfg /mnt

# Execute permission on archinstall2.sh
chmod +x /mnt/inside-arch-chroot.sh


## Inside chroot
arch-chroot /mnt /bin/bash -c /inside-arch-chroot.sh

## remove the archinstall2.sh script from /mnt (the new root)
rm -f /mnt/inside-arch-chroot.sh

# unmount and restart
umount -R /mnt

read -q "key?Reboot [Yyn]? "
if [[ "$key" =~ ^[Yy]$ ]]
then
    reboot
fi
