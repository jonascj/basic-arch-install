#!/bin/bash
set -x
set -e

# hostname
# Change this to a hostname of your choice
echo "jonascj-laptop" > /etc/hostname

# locale and time
ln -s /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime

sed -i 's/#en_DK.UTF-8 UTF-8/en_DK.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

tee /etc/locale.conf << 'EOF' >> /dev/null
LANG="en_DK.UTF-8"
LC_TIME="en_DK.UTF-8"
EOF

echo "KEYMAP=dk" > /etc/vconsole.conf

# TRIM on lvm
sed -i 's/issue_discards = 0/issue_discards = 1/' /etc/lvm/lvm.conf

# mkinitcpio
sed -i 's/HOOKS="base udev autodetect modconf block filesystems keyboard fsck"/HOOKS="base udev autodetect modconf block lvm2 filesystems keyboard fsck"/' /etc/mkinitcpio.conf

mkinitcpio -p linux

# bootloader
pacman -S --noconfirm grub dosfstools efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efisys --bootloader-id=grub --recheck --debug
cp /grub.cfg /boot/grub/grub.cfg


## ADDITIONAL CONFIGURATION (BASE INSTALL IS COMPLETE)


pacman -Syu --noconfirm vim git base-devel

# wifi-menu is from dialog
pacman -Syu --noconfirm dialog

# User, sudo and lock root
pacman -Syu --noconfirm sudo
groupadd sudo
useradd -m -G sudo -s /bin/bash jonas
passwd jonas
useradd -m -G sudo -s /bin/bash test

sed -i 's/# %sudo/%sudo/g' /etc/sudoers
passwd -l root

# disable pc speaker
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

# dhcp for wired interface
systemctl enable dhcpcd@enp0s25

# exit the chroot to finish up
exit
