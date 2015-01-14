# Install/Setup ThinkPad

```
Intel(R) Core(TM) i5-3427U CPU
2.30GHz
```

## SystemRescueCD

```
;; ThinkPad
root@sysrescd /root % dmidecode -s system-product-name
34442CE
```

## Note

* funtoo
* x86_64 (intel corei5)
  * `cat /proc/cpuinfo | grep "processor" | wc -l`
* SSD

## Date

```
% date MMDDhhmmYYYY
```

## Network

```
# /etc/init.d/NetworkManager stop
% ifconfig -a
% ifconfig wlp3s0 up
% iwlist wlp3s0 scan
% wpa_passphrase SSID PASSPHRASE > /etc/wpa_supplicant/wpa_supplicant.conf
% vim /etc/wpa_supplicant/wpa_supplicant.conf
{
  ...
  scan_ssid=1
  proto=WPA2
  key_mgmt=WPA-PSK
  pairwise=CCMP TKIP
  group=CCMP TKIP
}
% wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf -i wlp3s0 -D wext
...
wlp3s0: WPA: Key negotiation completed with xx:xx:xx:xx:xx:xx [PTK=CCMP GTK=CCMP]
wlp3s0: CTRL-EVENT-CONNECTED - Connection to xx:xx:xx:xx:xx:xx completed [id=N id_str=]
...
# wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf -i wlp3s0 -D wext -B
# dhcpcd -d wlp3s0
...
dhcpcd[NNNN]: forked to background, child pid NNNN
```

## Install

### partition

#### fdisk

check with `fdisk`

```
$ fdisk -l | grep '^Disk'
Disk /dev/sda: 256.1GB 256xxxxxxx bytes, xxxxxxx sectors
Disk identifier: xxxxxxxx
```

#### gparted

http://www.funtoo.org/Funtoo_Linux_Installation

```
% gdisk /dev/sda
Number Start (sector)  End (sector) Size        Code Name
1                                   500.0 MiB   8300 Linux filesystem
2                                   32.0 MiB    EF02 BIOS boot partition
3                                   4.0 GiB     8200 Linux swap
4                                   234.0 GiB   8300 Linux filesystem
% mke2fs -t ext2 /dev/sda1
% mkfs.ext4 /dev/sda4
% mkswap /dev/sda3
% swapon /dev/sda3
% mkdir /mnt/funtoo
% mount /dev/sda4 /mnt/funtoo
% mkdir /mnt/funtoo/boot
% mount /dev/sda1 /mnt/funtoo/boot
```

### stage3

* http://www.funtoo.org/wiki/Download

```
x86-64bit
* Intel
  Corei7: Intel Core i3, Core i5 and Core i7 desktop processors or higher. Xeon 5500, 5600 and 7500 series server processors or higher. (Nehalem, Sandy Bridge)
  ...
```

```
% cd /mnt/funtoo
% wget http://ftp.osuosl.org/pub/funtoo/funtoo-current/x86-64bit/corei7/stage3-latest.tar.xz
% tar xpf stage3-latest.tar.xz
```

### portage

* http://ftp.osuosl.org/pub/funtoo/

```
% cd /mnt/funtoo
% wget http://ftp.osuosl.org/pub/funtoo/funtoo-current/snapshots/portage-latest.tar.xz
% tar xf portage-latest.tar.xz -C /mnt/funtoo/usr
% cat /proc/cpuinfo | grep "processor" | wc -l
% vim /mnt/funtoo/etc/portage/make.conf
CHOST="x86_64-pc-linux-gnu"
CFLAGS="-march=corei7 -O2 -pipe"
CXXFLAGS="${CFLAGS}"

ACCEPT_KEYWORDS="~amd64"
MAKEOPTS="-jN" ; N = count of processors + 1
LINGUAS="en de ja"
```

### chroot

```
% cd /mnt/funtoo
# mount -t proc proc /mnt/funtoo/proc
# mount --rbind /sys /mnt/funtoo/sys
# mount --rbind /dev /mnt/funtoo/dev
% cp /etc/resolv.conf ./etc
% env -i HOME=/root TERM=$TERM chroot . bash -l
# etc-update
# source /etc/profile
# export PS1="(chroot) $PS1"
```

### sync portage

```
# cd /usr/portage
# git checkout funtoo.org
# emerge --sync
# eselect news read all
```

### setup editor

```
;; for now
# USE="minimal -ipv6" emerge -av vim
# vim /etc/env.d/99editor
EDITOR=/usr/bin/vim
```

### locale

```
# vim /etc/locale.gen
en_US.UTF-8 UTF-8
de_DE ISO-8859-1
de_DE@euro ISO-8859-15
ja_JP.UTF-8 UTF-8
# locale-gen
```

### timezone

```
# cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# vim /etc/timezone
Asia/Tokyo
```

### keymap

```
# vim /etc/conf.d/keymaps
keymap="dvorak"
```

### hwclock

```
# vim /etc/conf.d/hwclock
clock="local"
```

## kernel config

```
# echo 'sys-kernel/gentoo-sources symlink' >> /etc/portage/package.use
# emrege -av gentoo-sources
# cd /usr/src/linux
# make menuconfig
```

```
;; check hardware
# lspci
# lspci -k
# lsusb
```

```
Executable file formats / Emulations  --->
   [*] IA32 Emulation

File systems
  [*] The Extended 4 (ext4) filesystem

Networking support
  Wireless
    [*] cfg80211 wireless extensions compatibility

Device Drivers
  Network device support
    Wireless LAN
      Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate-N (iwlwifi)
```

```
# make && make modules_install
# cp arch/x86_64/boot/bzImage /boot/kernel-3.15.1-gentoo
```

```
# find /lib/modules/<kernel version>/ -type f -iname '*.o' -or -iname '*.ko' | less
```

Note about network modules iwlwifi, iwldvm

* http://wireless.kernel.org/en/users/Drivers/iwlwifi
* http://lxr.free-electrons.com/source/drivers/net/wireless/iwlwifi/Kconfig

```
46 config IWLDVM
47         tristate "Intel Wireless WiFi DVM Firmware support"
48         depends on IWLWIFI
49         default IWLWIFI
50         help
51           This is the driver that supports the DVM firmware which is
52           used by most existing devices (with the exception of 7260
53           and 3160).
54 
55 config IWLMVM
56         tristate "Intel Wireless WiFi MVM Firmware support"
57         depends on IWLWIFI
58         help
59           This is the driver that supports the MVM firmware which is
60           currently only available for 7260 and 3160 devices.
61 
62 # don't call it _MODULE -- will confuse Kconfig/fixdep/...
63 config IWLWIFI_OPMODE_MODULAR
64         bool
65         default y if IWLDVM=m
66         default y if IWLMVM=m
67 
68 comment "WARNING: iwlwifi is useless without IWLDVM or IWLMVM"
69         depends on IWLWIFI && IWLDVM=n && IWLMVM=n
```



## syslog, logrotate and cron

install some packages.

```
# emerge -av syslog-ng
# emrege -av vixie-cron
# emerge -av logrotate
# emrege -av mlocate
# rc-update add syslog-ng default
# rc-update add vixie-cron default
```

```
;; emerge these packages
net-wireless/wireless-tools
net-wireless/iw
sys-apps/net-tools
sys-apps/iproute2
net-wireless/wpa_supplicant
```


## fstab

```
# vim /etc/fstab
# The root filesystem should have a pass number of either 0 or 1.
# All other filesystems should have a pass number of 0 or greater than 1.
#
# NOTE: If your BOOT partition is ReiserFS, add the notail option to opts.
#
# See the manpage fstab(5) for more information.
#
# <fs>       <mountpoint>  <type>  <opts>         <dump/pass>

/dev/sda1    /boot         ext2    noatime        1 2
/dev/sda3    none          swap    sw             0 0
/dev/sda4    /             ext4    noatime        0 1
#/dev/cdrom  /mnt/cdrom    auto    noauto,ro      0 0
```

## profile

```
# eselect profile show
# eselect profile list
# eselect profile set-flavor 6
```

## hostname

```
# vim /etc/conf.d/hostname
```

## boot sequence

```
# emerge -av boot-update
# grep -v rootfs /proc/mounts > /etc/mtab
# grub-install --no-floppy /dev/sda
# vim /etc/boot.conf
# boot-update
```

## setup

```
# emerge -av linux-firmware
# rc-update add dhcpcd default
```

## user

```
# passwd
# useradd -m -G users,wheel,audio -s /bin/bash USERNAME
# passwd USERNAME
```

## finish

```
# exit
# cd /
# umount -l /mnt/funtoo/dev{/shm,/pts,}
# umount -l /mnt/funtoo{/boot,/sys,/proc,}
# reboot
```

## Debug

```
# /etc/init.d/NetworkManager stop
# date MMDDhhmmYYYY
# mkdir /mnt/funtoo
# mount /dev/sda4 /mnt/funtoo
# mount -t proc proc /mnt/funtoo/proc
# mount --rbind /dev /mnt/funtoo/dev
# mount --rbind /sys /mnt/funtoo/sys
# mount /dev/sda1 /mnt/funtoo/boot
# cd /mnt/funtoo
# env -i HOME=/root TERM=$TERM chroot . bash -l
# etc-update
# source /etc/profile
;; setup wlan if you need
# dhcpcd

do something

# exit
# cd
# umount -l /mnt/funtoo/dev{/shm,/pts,}
# umount -l /mnt/funtoo{/boot,/sys,/proc,}
# reboot
```


## link

* https://wiki.gentoo.org/wiki/GRUB_Error_Reference
* http://wiki.gentoo.org/wiki/GCC_optimization
* http://www.gentoo.org/doc/en/handbook/
* http://wiki.gentoo.org/wiki/Safe_CFLAGS
* http://www.funtoo.org/Installation_Troubleshooting
