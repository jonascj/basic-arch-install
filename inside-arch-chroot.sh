#!/bin/bash
# Print commands, after expansion but before execution, to stderr 
set -x
# Exit shell on errors
set -e



#------------------------------------------------------------------------------#
# Hostname, locale, time, keymap
#------------------------------------------------------------------------------#

# Hostname
echo "jonascj-laptop" > /etc/hostname

# Set local time zone
ln -s /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime
hwclock --systohc

# Set locale
sed -i 's/#en_DK.UTF-8 UTF-8/en_DK.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

tee /etc/locale.conf << 'EOF' >> /dev/null
LANG="en_DK.UTF-8"
LC_TIME="en_DK.UTF-8"
EOF

# Set permanent keymap (for the console)
echo "KEYMAP=dk" > /etc/vconsole.conf



#------------------------------------------------------------------------------#
# mkinitcpio
#------------------------------------------------------------------------------#
mkinitcpio -p linux



#------------------------------------------------------------------------------#
# Bootloader 
#------------------------------------------------------------------------------#
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub 
grub-mkconfig -o /boot/grub/grub.cfg



#------------------------------------------------------------------------------#
# User setup
#------------------------------------------------------------------------------#

# Add user, setup sudo 
pacman -Syu --noconfirm sudo zsh
groupadd sudo
sed -i 's/# %sudo/%sudo/g' /etc/sudoers

useradd -m -G sudo -s /bin/zsh jonas
passwd jonas

# Lock root user
passwd -l root



#------------------------------------------------------------------------------#
# Additional configuration
#------------------------------------------------------------------------------#

# Disable pc speaker
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

# Additional packages are nice to have during further setup
pacman -Syu --noconfirm vim git tree btrfs-progs



#------------------------------------------------------------------------------#
# Exit chroot (let install.sh finish up)
#------------------------------------------------------------------------------#
exit
