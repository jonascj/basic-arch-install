#!/bin/sh

# Do everything needed before chrooting
./archinstall1.sh > /mnt/archinstall1.log

# chroot and do the configuration in the chroot
arch-chroot /mnt /bin/sh -c "/archinstall2.sh > /archinstall2.log"

# unmount and restart
umount -R /mnt
reboot
