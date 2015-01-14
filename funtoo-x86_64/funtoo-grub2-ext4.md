
# Setup Gentoo

## start

keyboard 12 (dvorak)

```
$ net-setup {eth0|wlan0}
$ ping -c 3 www.gentoo.org
```

----

## parted and mkfs


* gdisk (GPT)


```
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          206847   500.0 MiB   8300  Linux filesystem
   2          206848          272383   32.0 MiB    EF02  BIOS boot partition
   3          272384         8660991   4.0 GiB     8200  Linux swap
   4         9480192       234441614   927.0 GiB   8300  Linux filesystem
```

```
/dev/sda1, which will be used to hold the /boot filesystem,
/dev/sda2, which will be used directly by the new GRUB,
/dev/sda3, which will be used for swap space, and
/dev/sda4, which will hold your root filesystem.
```

Create filesystems

```
# mke2fs -t ext2 /dev/sda1
# mkfs.ext4 /dev/sda4
# mkswap /dev/sda3
# swapon /dev/sda3
```

```
# mkdir /mnt/funtoo
# mount /dev/sda4 /mnt/funtoo
# mkdir /mnt/funtoo/boot
# mount /dev/sda1 /mnt/funtoo/boot
```

* fdisk (MBR)

check with `fdisk`

```
$ fdisk -l | grep '^Disk'
Disk /dev/sda: 1000.2GB 10xxxxxxxx bytes, xxxxxxx sectors
```

* parted (GPT)

```
# parted
(parted) mklabel gpt
(parted) mkpart primary ext2 0 32mb(255mb)
(parted) mkpart primary linux-swap 32mb(255mb)  542mb(1020mb)
(parted) mkpart primary ext4 542mb(1020mb) -1s
(parted) set 1 bios_grub on
(parted) print

$ mkswap /dev/sda2
$ swapon /dev/sda2

$ mkfs.ext4 /dev/sda3
$ mkfs.ext2 /dev/sda1

$ mount /dev/sda3 /mnt/gentoo
$ mkdir /mnt/gentoo/boot
$ mount /dev/sda1 /mnt/gentoo/boot
```




-----

## stage

```
$ date
$ date MMDDhhmmYYYY
```

### Note

* http://www.funtoo.org/wiki/Download

```
The AMD line of 64-bit processors were released well ahead of Intel's offering. Therefore, for historical reasons the arch keyword for all x86-64 compatible architectures is amd64. As such, AMD64 is a generic reference to 64-bit chips, whether AMD or Intel. '
```

### AMD Turion_II

* http://ja.wikipedia.org/wiki/Turion_II

```
Turion X2 Ultraの後継で、AMD K10 アーキテクチャを採用した。
```

```
amd64-k10: AMD Phenom, Phenom II and compatible, or higher
amd64-k8: AMD Opteron or Athlon 64 processors, or higher
```

```
$ cd /mnt/funtoo
$ wget http://ftp.osuosl.org/pub/funtoo/funtoo-current/x86-64bit/amd64-k10/stage3-latest.tar.xz
$ tar xpf stage3-latest.tar.xz
```

### Corei7

* http://www.funtoo.org/wiki/Download

```
x86-64bit
* Intel
  Corei7: Intel Core i3, Core i5 and Core i7 desktop processors or higher. Xeon 5500, 5600 and 7500 series server processors or higher. (Nehalem, Sandy Bridge)
  ...
```

```
$ cd /mnt/funtoo
$ wget http://ftp.osuosl.org/pub/funtoo/funtoo-current/x86-64bit/corei7/stage3-latest.tar.xz
$ tar xpf stage3-latest.tar.xz
```

-----

## portage

* http://ftp.osuosl.org/pub/funtoo/

```
$ cd /mnt/funtoo
$ wget http://ftp.osuosl.org/pub/funtoo/funtoo-current/snapshots/portage-latest.tar.xz
$ tar xf portage-latest.tar.xz -C /mnt/funtoo/usr

$ cat /proc/cpuinfo | grep "processor" | wc -l
$ nano -w /mnt/funtoo/etc/portage/make.conf
```

```
MAKEOPTS="-jN" ; N = count of processors + 1
LINGUAS="en de ja"
```

-----

## chroot

```
$ cd /mnt/funtoo
$ mount --bind {/,}proc
$ mount --bind {/,}dev
$ cp /etc/resolv.conf ./etc

$ env -i HOME=/root TERM=$TERM chroot . bash -l
# export PS1="(chroot) $PS1"
```

-----

## sync portage

```
# cd /usr/portage
# git checkout funtoo.org
# emerge --sync
```

-----

## system settings

### editor

```
# USE="cscope perl ruby vim-syntax -ipv6" emerge -av vim
# USE="perl ruby vim-syntax -ipv6" emerge -av vim

# vim /etc/env.d/99editor
```

```
EDITOR=/usr/bin/vim
```

### locale

```
# vim /etc/locale.gen
```

```
de_DE ISO-8859-1
de_DE@euro ISO-8859-15
ja_JP.EUC-JP EUC-JP
ja_JP.UTF-8 UTF-8
```

```
# locale-gen
```

### timezone

```
# cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# vim /etc/timezone
```

```
Asia/Tokyo
```


### keymap

```
# vim /etc/conf.d/keymaps
```

```
keymap="dvorak"
```

### hwclock

```
# vim /etc/conf.d/hwclock
```

* clock="local"


### Refs.

* http://www.funtoo.org/wiki/Funtoo_Linux_Installation#Chroot_into_Funtoo

-----

## kernel config

```
# USE="symlink" emrege gentoo-sources
# cd /usr/src/linux
# make menuconfig
```

```
Executable file formats / Emulations  --->
   [*] IA32 Emulation

File systems
  [*] The Extended 4 (ext4) filesystem

Netfilter
  IP: Netfilter Configuration --->
    <*> IP tables
    ...
```

```
# make && make modules_install
# cp arch/x86_64/boot/bzImage /boot/kernel-3.9.8-gentoo
```

## kernel module


```
# find /lib/modules/<kernel version>/ -type f -iname '*.o' -or -iname '*.ko' | less
```


-----

## settings

```
# emerge syslog-ng
# emrege vixie-cron
# emerge logrotate
# emrege mlocate

# rc-update add syslog-ng default
# rc-update add vixie-cron default
```

-----

## fstab

```
# vim /etc/fstab
```

```
/dev/sda1	  	/boot		    ext2		defaults,noatime	1 2
/dev/sda3		  none		    swap		sw			          0 0
/dev/sda4		  /		        ext4		noatime		      	0 1
/dev/cdrom		/mnt/cdrom	auto		noauto,ro,user		0 0
```

-----

## profile

```
# eselect profile show
# eselect profile list

# eselect profile add 10
```

-----

## hostname


* `/etc/conf.d/hostname`

-----

## Note

Remove MBR (optional)

```
# dd if=/dev/zero of=/dev/sda bs=512 count=1 #=> remove MBR !!
```

* http://mimumimu.net/blog/2012/02/01/hybrid-mbr-を-gpt-mbr-ディスクに変換する。/

-----

## boot sequence


```
# emerge boot-update

# grep -v rootfs /proc/mounts > /etc/mtab
# grub-install --no-floppy /dev/sda
# boot-update
```

check /etc/boot.conf

-----

##

(optional)

```
# emerge linux-firmware
```

-----

```
# rc-update add dhcpcd default
# passwd

# exit
# cd /
# umount /mnt/funtoo/boot /mnt/funtoo/dev /mnt/funtoo/proc /mnt/funtoo
# reboot
```

-----

# debug

```
# mkdir /mnt/funtoo
# mount /dev/sda4 /mnt/funtoo
# mount -t proc none /mnt/funtoo/proc
# mount --rbind /dev /mnt/funtoo/dev
# mount --rbind /sys /mnt/funtoo/sys
# mount /dev/sda1 /mnt/funtoo/boot
# cd /mnt/funtoo
# env -i HOME=/root TERM=$TERM chroot . bash -l
# etc-update
# source /etc/profile
# dhcpcd

do something

# exit
# cd
# umount -l /mnt/funtoo/dev{/shm,/pts,}
# umount -l /mnt/funtoo{/boot,/sys,/proc,}
# reboot
```


-----

```
ERST: Failed to get Error Log Address Range
```

* http://h20000.www2.hp.com/bizsupport/TechSupport/Document.jsp?objectID=c03731635&lang=en&cc=us&taskId=101&prodSeriesId=5268290&prodTypeId=15351


-----

### Ref.

* http://www.funtoo.org/Funtoo_Linux_Installation

grub2 on gentoo:
* http://wiki.gentoo.org/wiki/GRUB2
* http://dev.gentoo.org/~scarabeus/grub-2-guide.xml
* http://forums.gentoo.org/viewtopic-t-906696-start-0.html

grub2 on UEFI:
* https://help.ubuntu.com/community/UEFIBooting
* http://www.funtoo.org/wiki/GUID_Booting_Guide
* https://wiki.archlinux.org/index.php/GRUB2#UEFI_systems
* http://www.thinkwiki.org/wiki/Installing_Gentoo_on_a_ThinkPad_X220#Grub_with_EFI_support_installation
* http://wiki.sabayon.org/index.php?title=UEFI_Boot

