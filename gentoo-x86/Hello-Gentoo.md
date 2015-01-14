
I have referred to the [[Handbook|http://www.gentoo.org/doc/en/handbook/handbook-x86.xml]].

* Burn Disk
  - download minimum iso.
  - burned to CD with Disk Utilitiy.app

* Network
  - `net-setup eth0` (select Wired, use DHCP)
  - `ping -C 3 www.gentoo.org`
  - `ifconfig (check ip)`

* Partition
  - first, created 2 partition with Mac OSX Disk Utilities.app
    - Mac OSX and MS-DOS(Fat)
  - used GNU parted for handling of GUID partition table.
    + __/dev/sda1__ is for rEFIt
    + __/dev/sda2,3__ are for Mack OSX
    + __/dev/sda4,5,6__ are for Gentoo
    + __/dev/sda7__ is as shared HD (format hfsplus, later)
  - parted as ext4 filesystem.
  - make swap partition.
    + `mkswap /dev/sda5`
    + `swapon /dev/sda5`

```
Number  Start   End    Size    File system  Name                  Flags
1       20.5kB  210MB  210MB   fat32        EFI system partition  boot
2       210MB   150GB  150GB   hfs+         Customer
3       150GB   151GB  650MB   hfs+         Recovery HD
4       151GB   151GB  31.5MB  ext2
5       151GB   152GB  513MB   linux-swap(v1)
6       152GB   302GB  150GB   ext4
7       302GB   320GB  18.1GB  hfs+
`````

* Mount
  - `mount /dev/sda3 /mnt/gentoo`
  - `mkdir /mnt/gentoo/boot`
  - `mount /dev/sda1 /mnt/gentoo/boot`

* Get stage3 and snapshot
  - `cd /mnt/gentoo`
  - `links http://www.gentoo.org/main/en/mirrors.xml`
  - `/ releases/`
  - `d stage3-i686-*.tar.bz2`
  - `tar xvjpf stage-i686-*tar.bz2`
  - `cd /mnt/gentoo`
  - `links http://www.gentoo.org/main/en/mirrors.xml`
  - `/ snapshots/`
  - `d portage-latest.tar.bz2`
  - `tar xvjf /mnt/gentoo/portage-latest.tar.bz2 -C /mnt/gentoo/usr`

* make.conf
  - `nano -w /mnt/gentoo/etc/make.conf` vim not exit ;-(
  - add MAKEOPTS="-j3" (Oevr 3 possible ?)
  - `mirrorselect -i -o >> /mnt/gentoo/etc/make.conf`
  - `mirrorselect -i -r -o >> /mnt/gentoo/etc/make.conf`

* resolv.conf
  - `cp -L /etc/resolv.conf /mnt/gentoo/etc/`

* proc and dev for my Gentoo
  - `mount -t proc none /mnt/gentoo/proc`
  - `mount --rbind /dev /mnt/gentoo/dev`

* chroot
  - `chroot /mnt/gentoo /bin/bash`
  - `env-update`
  - `source /etc/profile`
  - `export PS1="(Hello Gentoo) $PS1"`

