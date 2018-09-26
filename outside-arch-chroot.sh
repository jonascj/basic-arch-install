#!/bin/zsh
# Print commands, after expansion but before execution, to stderr 
set -x
# Exit shell on errors
set -e


#------------------------------------------------------------------------------#
# Partitions and filesystem
#------------------------------------------------------------------------------#

# Make file systems
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.btrfs -f /dev/sda3

# Creating btrfs subvolumes
mount /dev/sda3 /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@opt
umount /mnt

# Mounting 
mount -o noatime,compress=lzo,space_cache,subvol=@root /dev/sda3 /mnt
mkdir /mnt/{home,.snapshots,opt}
mount -o noatime,compress=lzo,space_cache,subvol=@home /dev/sda3 /mnt/home
mount -o noatime,compress=lzo,space_cache,subvol=@snapshots /dev/sda3 /mnt/.snapshots
mount -o noatime,compress=lzo,space_cache,subvol=@opt /dev/sda3 /mnt/opt

mkdir -p /mnt/boot/efi
mount -t vfat /dev/sda1 /mnt/boot/efi 

swapon /dev/sda2



#------------------------------------------------------------------------------#
# Mirrors 
#------------------------------------------------------------------------------#
echo 'Server = https://mirrors.dotsrc.org/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
echo 'Server = https://mirror.one.com/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist



#------------------------------------------------------------------------------#
# Install base system 
#------------------------------------------------------------------------------#
pacstrap /mnt base base-devel 


#------------------------------------------------------------------------------#
# Additional configuration outside chroot 
#------------------------------------------------------------------------------#

# fstab
genfstab -p /mnt >> /mnt/etc/fstab
