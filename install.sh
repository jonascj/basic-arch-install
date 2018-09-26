#!/bin/zsh
exec > >(tee ./tmp/install.log)
exec 2>&1
set -x
set -e

#------------------------------------------------------------------------------#
# Outside arch-chroot
#------------------------------------------------------------------------------#
chmod +x outside-arch-chroot.sh
./outside-arch-chroot.sh 2>&1 | tee ./outside-arch-chroot.log

# Copy log file to new root (so it will be there after a reboot)
cp ./outside-arch-chroot.log /mnt

# Place the inside-arch-chroot.sh script
# at the root of the new filesystem (/mnt)
cp ./inside-arch-chroot.sh /mnt
chmod +x /mnt/inside-arch-chroot.sh 



#------------------------------------------------------------------------------#
# Inside arch-chroot
#------------------------------------------------------------------------------#
arch-chroot /mnt /bin/bash -c "/inside-arch-chroot.sh 2>&1 | tee /inside-arch-chroot.log"

# remove the inside-arch-chroot.sh script from /mnt (the new root)
rm -f /mnt/inside-arch-chroot.sh

# Copy log file to install script folder
cp /mnt/inside-arch-chroot.log .
 


#------------------------------------------------------------------------------#
# Unmount and restart
#------------------------------------------------------------------------------#

umount -R /mnt

read -q "key?Reboot [Yyn]? "
if [[ "$key" =~ ^[Yy]$ ]]
then
    reboot
fi
