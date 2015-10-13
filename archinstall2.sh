#!/bin/sh

# hostname
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


## Some nice-to-have software

pacman -Syu --noconfirm vim

# wifi-menu is from dialog
pacman -Syu --noconfirm dialog


# exit the chroot ot finish up
exit
