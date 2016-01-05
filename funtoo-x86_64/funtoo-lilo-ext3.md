# Setup Gentoo

## HD

* boot -> ext2
* /    -> ext3
* bootloader lilo

-----

## Start

keyboard 12 (dvorak)

```
$ net-setup eth0
$ ping -c 3 www.gentoo.org
```

----

## Create partition with parted and mkfs

```
$ parted
(parted) mklabel gpt
(parted) mkpart primary ext2 0 201mb
(parted) mkpart primary linux-swap 201mb 542mb
(parted) mkpart primary ext3 542mb -1s
(parted) set 1 boot on
(parted) print

$ mkswap /dev/sda2
$ swapon /dev/sda2

$ mkfs.ext3 /dev/sda3
$ mkfs.ext2 /dev/sda1

\# mount /dev/sda3 /mnt/gentoo
\# mkdir /mnt/gentoo/boot
\# mount /dev/sda1 /mnt/gentoo/boot
```


-----

## Stage

```
$ date
$ date MMDDhhmmYYYY
```


### Note

```
The AMD line of 64-bit processors were released well ahead of Intel's offering. Therefore, for historical reasons the arch keyword for all x86-64 compatible architectures is amd64. As such, AMD64 is a generic reference to 64-bit chips, whether AMD or Intel. '
```

```
$ cd /mnt/gentoo
$ wget http://ftp.osuosl.org/pub/funtoo/funtoo-current/x86-64bit/corei7/stage3-current.tar.xz
$ tar xpf stage3-current.tar.xz
```

### Note

```
x86-64bit
* Intel 
  Corei7: Intel Core i3, Core i5 and Core i7 desktop processors or higher. Xeon 5500, 5600 and 7500 series server processors or higher. (Nehalem, Sandy Bridge)
  ...
```

### Ref.
* http://ftp.osuosl.org/pub/funtoo/

\# cd /mnt/gentoo
\# wget http://ftp.osuosl.org/pub/funtoo/funtoo-current/snapshots/portage-current.tar.xz
\# tar xf portage-current.tar.xz -C /mnt/gentoo/usr

\# cat /proc/cpuinfo | grep "processor" | wc -l
\# nano -w /mnt/gentoo/etc/make.conf

add MAKEOPTS
add LINGUAS="en de ja"

-----

## Let's chroot

\# cd /mnt/gentoo
\# mount --bind {/,}proc
\# mount --bind {/,}dev
\# cp /etc/resolv.conf ./etc

\# env -i HOME=/root TERM=$TERM chroot . bash -l
\# etc-update
\# source /etc/profile
\# export PS1="(chroot) $PS1"


-----

## sync portage

\# cd /usr/portage
\# git checkout funtoo.org
\# emerge --sync

-----

## System settings

### editor

\# emerge vim
\# vim /etc/env.d/99editor

```
EDITOR=/usr/bin/vim
```

### locale

\# vim /etc/locale.gen

```
de_DE ISO-8859-1
de_DE@euro ISO-8859-15
ja_JP.EUC-JP EUC-JP
ja_JP.UTF-8 UTF-8
```

\# locale-gen

### timezone

\# cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
\# vim /etc/timezone

### keymap

\# vim /etc/conf.d/keymaps

```
keymap="dvorak"
```

### Refs.

* http://www.funtoo.org/wiki/Funtoo_Linux_Installation#Chroot_into_Funtoo

### dhcpcd

\# rc-update add dhcpcd default

-----

## kernel config

\# emrege gentoo-sources

\# cd /usr/src/linux
\# make menuconfig

```
Executable file formats / Emulations  --->
   [*] IA32 Emulation

File systems --->
  [*] The Extended 4 (ext4) filesystem

Device Drivers --->
  Graphics support --->
    <*> Direct Rendering Manager (XFree86 4.1.0 and higher DRI support) --->
      <*> Nouveau (nVidia) cards
      [*]   Support for backlight control
      [*]   Build in Nouveau s debugfs support
```

\# make && make modules_install

-----

## Portage

\# emerge dhcpcd
\# emerge syslog-ng
\# emrege vixie-cron
\# emerge logrotate
\# emrege mlocate

\# rc-update add syslog-ng default
\# rc-update add vixie-cron default

-----

## Boot sequence

\# vim /etc/fstab
\# vim /etc/conf.d/hostname

\# mount /dev/sda1 /boot

\# emerge lilo
\# vim /etc/lilo.conf
\# /sbin/lilo

\# exit
\# cd
\# umount -l /mnt/gentoo/dev{/shm,/pts,}
\# umount -l /mnt/gentoo{/boot,/proc,}
\# reboot

-----

## Debug

```
\# mount /dev/sda3 /mnt/gentoo
\# mount -t proc none /mnt/gentoo/proc
\# mount --rbind /dev /mnt/gentoo/dev
\# mount --rbind /sys /mnt/gentoo/sys
\# mount /dev/sda1 /mnt/gentoo/boot
\# cd /mnt/gentoo
\# env -i HOME=/root TERM=$TERM chroot . bash -l
\# etc-update
\# source /etc/profile
\# dhcpcd

do something

\# exit
\# cd
\# umount -l /mnt/gentoo/dev{/shm,/pts,}
\# umount -l /mnt/gentoo{/boot,/sys,/proc,}
\# reboot
```



-----

### Recreate kernel

```
cd /usr/src/linux
make menuconfig
make && make modules_install
cp /boot/kernel-N.N.N-gentoo /boot/kernel-N.N.N-gentoo.back
cp x86_64/boot/bzImage /boot/kernel-X.X.X-gentoo
sudo emerge @module-rebuild
lilo
```

-----

### Ref.

grub2 on gentoo:
* http://wiki.gentoo.org/wiki/GRUB2#UEFI.2FGPT
* http://dev.gentoo.org/~scarabeus/grub-2-guide.xml
* http://forums.gentoo.org/viewtopic-t-906696-start-0.html

grub2 on UEFI:
* https://help.ubuntu.com/community/UEFIBooting
* http://www.funtoo.org/wiki/GUID_Booting_Guide
* https://wiki.archlinux.org/index.php/GRUB2#UEFI_systems
* http://www.thinkwiki.org/wiki/Installing_Gentoo_on_a_ThinkPad_X220#Grub_with_EFI_support_installation
* http://wiki.sabayon.org/index.php?title=UEFI_Boot

ethernet realtek RTL8111X/RTL8168 driver
* http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=5&PFid=5&Level=5&Conn=4&DownTypeID=3&GetDown=false#RTL8111B/RTL8168B/RTL8111/RTL8168/RTL8111C
*  http://d.hatena.ne.jp/metastable/20100117/1263737845


__add 20120917__

* [Repository of realtek network drivers](http://code.google.com/p/r8168/downloads/list)
* [Realtek r8168 driver](http://code.google.com/p/r8168/issues/detail?id=9)
* [Funtoo network setting](http://www.funtoo.org/wiki/Funtoo_Linux_Networking)

r8168-31.00 version driver works fine.

