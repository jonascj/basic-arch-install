#!/bin/sh



## Place the archinstall2.sh script
## at the root of the new filesystem
cp ./archinstall2.sh /mnt/archinstall2.sh
cp ./grub.cfg /mnt/grub.cfg

# Execute permission on the two scripts
chmod +x archinstall1.sh
chmod +x /mnt/archinstall2.sh


# Before arch-chroot
./archinstall1.sh 2>&1 | tee /mnt/archinstall1.log

# After arch-chroot
arch-chroot /mnt /bin/sh -c "/archinstall2.sh 2>&1 | tee /archinstall2.log"

# remove the archinstall2.sh script from /mnt (the new root)
rm -f /mnt/archinstall2.sh

# unmount and restart
umount -R /mnt
reboot
