#!/bin/sh

# hostname
echo "jonascj-pc" > /etc/hostname

# locale and time
ln -s /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime

sed -i 's/#en_DK.UTF-8 UTF-8/en_DK.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

tee /etc/locale.conf << 'EOF' >> /dev/null
LANG="en_DK.UTF-8"
LC_TIME="en_DK.UTF-8"
EOF

echo "KEYMAP=dk-qwerty" > /etc/vconsole.conf

# mkinitcpio
sed -i 's/HOOKS="base udev autodetect modconf block filesystems keyboard fsck"/HOOKS="base udev autodetect modconf block lvm2 filesystems keyboard fsck"/' /etc/mkinitcpio.conf

mkinitcpio -p linux

# password ...
passwd 'pleaseboot'

# bootloader
pacman -S --noconfirm grub dosfstools efibootmgr
mkdir /boot/efi
mount -t vfat /dev/sda1 /boot/efi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub --boot-directory=/boot/efi/EFI --recheck --debug
grub-mkconfig -o /boot/efi/EFI/grub/grub.cfg

# exit back to archinstall1.sh to reboot
exit
