#!/bin/sh

chmod +x archinstall1.sh archinstall2.sh

# Do everything needed before chrooting
./archinstall1.sh 2>&1 | tee /mnt/archinstall1.log

# chroot and do the configuration in the chroot
arch-chroot /mnt /bin/sh -c "/archinstall2.sh 2>&1 | tee /archinstall2.log"

# unmount and restart
umount -R /mnt
reboot
