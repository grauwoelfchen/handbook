# ppc32

## Keymap

```
# ls /usr/share/keymaps/i386
# loadkeys drorak
```

## Network

```
# modprobe sungem

# mkdir /run
# dhcpcd eth0

# mkdir /var/lib/misc
# touch /var/lib/misc/syslog-ng.persist-
# /etc/init.d/syslog-ng start

# /etc/init.d/sshd start --> does not work ...
```

## Partition

```
# mac-fdisk /dev/hda

initalize:       i
apple bootstrap: b --> 2p
swap:            c --> 3p, 1024M, (name: swap)
boot:            c --> 4p, 4p, (name: root)
w
q
```

## Filesystem

```
(swap)
# mkswap /dev/hda3
# swapon /dev/hda3

(ext3)
# mke2fs -j /dev/hda4

(mount)
# mount /dev/hda4 /mnt/gentoo
```

## Stage3

```
# date MMDDhhmmYYYY

(stage3)
# cd /mnt/gentoo
# links http://www.gentoo.org/main/en/mirrors.xml
    releases/ppc/autobuilds
    stage3-ppc-<release>.tar.bz2
# md5sum -c stage3-ppc-<release>.tar.bz2.DIGESTS
# tar xvjpf stage3-ppc-<release>.tar.bz2

(portage)
# links http://www.gentoo.org/main/en/mirrors.xml
    snapshots/portage-latest-tar.bz2.md5sum
    snapshots/portage-latest-tar.bz2
# md5sum -c portage-latest-tar.bz2.md5sum
# tar xjvf /mnt/gentoo/portage-latest.tar.bz2 -C /mnt/gentoo/usr
```

## make.conf

```
# vi /etc/make.conf
    MAKEOPTS="-j2"
```

## chroot

```
# mirrorselect -i -o >> /mnt/gentoo/etc/make.conf
# mirrorselect -i -r -o >> /mnt/gentoo/etc/make.conf
# vi /etc/make.conf

# cp -L /etc/make.conf /mnt/gentoo/etc

# mount -t proc none /mnt/gentoo/proc
# mount --rbind /dev /mnt/gentoo/dev

# chroot /mnt/gentoo /bin/bash
# env-update
# source /etc/profile
# export PS1="(chroot) $PS1"
```

## Setup

```
# emerge --sync
# mv /etc/make.conf /etc/portage/
```

### vim

```
# USE="python ruby" emerge -av vim
# vim /etc/env.d/99editor
    EDITOR=/usr/bin/vim
```

### Locale

```
# vim /etc/locale.gen

    en_US ISO-8859-1
    en_US.UTF-8 UTF-8
    de_DE ISO-8859-1
    de_DE@euro ISO-8859-15
    ja_JP.EUC-JP EUC-JP
    ja_JP.UTF-8 UTF-8

# locale-gen

# vim /etc/env.d/02locale
# env-update && source /etc/profile

# ln -sf /usr/share/zoneinfo/Japan /etc/localtime
```

## Kernel

```
# cd /usr/src/linux
# make menuconfig

+ partition types (Machintosh partition map supporting)
    Enable the block layer
      Partition Types --->
        [*] Advanced partition selection
+ Device drivers
   ATA/IDE/MFM/RLL Support (DEPRECATED)
     [*] PowerMac IDE DMA Support
+ enable ext3
    File system --->
      <*> Ext3 journaling file system support
+ open firmware
+ proc filesystem support
+ Prompt for development and/or incomplete code/drivers
+ OHCI HCD support (Device Drivers ---> USB support)
+ sungem
   Device Drivers
   -> Network device support
     -> Ethernet driver support
       -> Sun devices
+ Network support
    Options
      Packet support
      TCP/IP
(+ Firewire support)
(+ ADB (Machintosh Device Drivers))
(+ HFS support)

# make all && make modules_install
# cp vmlinux /boot/kernel-3.4.9
```


## fstab

```
# vim /etc/fstab

/dev/hda4   /          ext3  noatime              0 1
/dev/hda3   none       swap  sw                   0 0
/dev/cdrom  /mnt/cdrom auto  noauto,user          0 0
proc        /proc      proc  defaults             0 0
shm         /dev/shm   tmpfs nodev,nosuid,noexec  0 0
```

## network

```
# vim /etc/conf.d/net
    config_eth0="dhcp"
# cd /etc/init.d
# ln -s net.lo ent.eth0
# rc-update add net.eth0 default
```

## Other

```
# passwd
# vim /etc/conf.d/keymaps
    keymap="dvorak"
# vim /etc/conf.d/hwclock
    clock="local"
# vim /etc/timezone
    Asia/Tokyo
```

## System Tool

* dhcpcd
* syslog-ng
* vixie-cron
* logrotate
* mlocate
* openssh

## yaboot

```
# exit
# mount -o bind /dev /mnt/gentoo/dev
# chroot /mnt/gentoo /bin/bash
# /usr/sbin/env-update && source /etc/profile
# emerge --usepkg --update yaboot

# exit
# yabootconfig --chroot /mnt/gentoo
(or)
# cp /etc/yaboot.conf.sample /etc/yaboot.conf

# vim /etc/yaboot.conf

    boot=/dev/hda2
    ofboot=hd:2
    device=hd:
    partition=4
    root=/dev/hda4
    timeout=30
    install=/usr/lib/yaboot/yaboot
    magicboot=/usr/lib/yaboot/ofboot
    append="video=ofonly"

    enablecdboot
    etableofboot

    image=/boot/kernel-3.4.9
      label=Linux
      read-only

# mkofboot -v (ybin -v)
# umount /mnt/gentoo/proc /mnt/gentoo/dev /mnt/gentoo
# reboot
```

## Check

```
# mount /dev/hda4 /mnt/gentoo
# mount -t proc none /mnt/gentoo/proc
# mount -o bind /dev /mnt/gentoo/dev
# chroot /mnt/gentoo /bin/bash

# env-update
# source /etc/profile

# vim /etc/yaboot.conf
# ybin -v

# exit
# umount /mnt/gentoo/proc /mnt/gentoo/dev
# umount /mnt/gentoo
# reboot
```

## User

```
# useradd -m -G users,wheel -s /bin/bash yasuhiro
# passwd yasuhiro
```

## clear up

```
# rm /stage3-\*
# rm /portage-latest\*
```

## sshd

```
# /etc/init.d/sshd start
# rc-update add sshd default
```

## Ref.

* [Gentoo Linux PPC Handbook](http://www.gentoo.org/doc/en/handbook/handbook-ppc.xml)
* [install-powerpc-minimal-20120909: sshd not working on ppc32](http://forums.gentoo.org/viewtopic-t-937880.html?sid=793719c46f76edc04a8dbb7b835803d7)
* [Gentoo Linux on an iBook G4 1.33 GHz (mid 2005)](http://cmr.cx/ibook/linux/ibook_linux.html)
* [Kernel panic on boot](http://forums.gentoo.org/viewtopic-t-656345-start-0.html)
* [unable to mount root fs](http://forums.gentoo.org/viewtopic.php?t=147680)
