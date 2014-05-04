#!/bin/sh

## Execute permission 
chmod +x archinstall1.sh


## Before arch-chroot
./archinstall1.sh 2>&1 | tee ./archinstall1.log

## Place the archinstall2.sh script and grub.cfg
## at the root of the new filesystem (/mnt)
cp ./archinstall2.sh /mnt/archinstall2.sh
cp ./grub.cfg /mnt/grub.cfg
cp ./archinstall1.log /mnt/archinstall1.log

# Execute permission on archinstall2.sh
chmod +x /mnt/archinstall2.sh


## After arch-chroot
arch-chroot /mnt /bin/sh -c "/archinstall2.sh 2>&1 | tee /archinstall2.log"

## remove the archinstall2.sh script from /mnt (the new root)
rm -f /mnt/archinstall2.sh

# unmount and restart
umount -R /mnt
reboot
