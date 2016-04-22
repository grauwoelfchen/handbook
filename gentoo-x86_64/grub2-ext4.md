# Setup Gentoo

* ZBook
* GPT with BIOS boot
* Grub 2
* Ext4 as rootfs
* SystemRescueCD
* wpa_supplicant
* keymap="dvorak"
* LINGUAS="en de ja"


## SystemRescueCD

### Burn CD

```zsh
# use SystemRescueCD as bootable image
% curl -LO https://sourceforge.net/projects/systemrescuecd/files/sysresccd-x86/4.7.2/systemrescuecd-x86-4.7.2.iso/download
% sha256sum systemrescuecd-x86-4.7.2.iso
b0a3333c091ec2f4658e2a150305053a2cf50c63b217465cd504559dee4447a7  systemrescuecd-x86-4.7.2.iso
```

```zsh
% cdrecord -scanbus

# check your bus (like 0,0,0)
% cdrecord -v dev=YOURBUS driveopts=help -checkdrive

# test
% cdrecord -dummy -v dev=2,0,0 driveopts=burnfree speed=12 -dao ./systemrescuecd-x86-4.7.2.iso

# burn to cdrom
% cdrecord -v dev=2,0,0 driveopts=burnfree speed=12 -dao ./systemrescuecd-x86-4.7.2.iso
```


### Network

SystemRescueCD's `net-setup` does not support `WPA2` protocol.  
So setup `wpa_supplicant`

```zsh
# stop NetworkManager
% /etc/init.d/NetworkManager stop

# check interface name
% ip link (or ifconfig -a)

% ip link set {INTERFACE} up
```

#### Run wpa_supplicant

```zsh
% cat /etc/wpa_supplicant/wpa_supplicant.conf
ctrl_interface=/run/wpa_supplicant
update_config=1

# run wpa_supplicant without `-B` to check running correcty
% wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf -i {INTERFACE}
# run wpa_supplicant with `-B`
% wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf -i {INTERFACE} -B
% wpa_cli
```

#### Setup WPA Network

```
> scan
OK
...
> scan_results
...

> add_network
0
> set_network 0 ssid "SSID"
OK
> set_network 0 psk "PASSPHRASE"
OK
> enable_network 0
OK
...
> save_config
> q
```

#### Boot dhcpcd

Finaly, wpa_supplicant.conf is:

```
ctrl_interface=/run/wpa_supplicant
update_config=1

network={
    ssid="SSID"
    psk="PASSPHRASE"
}
```

```zsh
# Boot dhcp client
% dhcpcd INTERFACE
{INTERFACE}: adding address xx:xx:xx:xx:
DUID 00:00:00:00:00%:00%:00
{INTERFACE}: IAID ...
```

```zsh
# check network :)
% ping -c 3 www.gentoo.org
```


### Prepare Disk

`parted`

* In the case of a GPT partitioned disk it will embed it in the BIOS Boot Partition , denoted by bios_grub flag in parted.
* check with `% parted /dev/sda print`

```
(parted) mklabel gpt
(paretd) unit mib

(parted) mkpart primary 1 3
(parted) name 1 grub
(parted) set 1 bios_grub on

(parted) mkpart primary 3 259
(parted) name 2 boot

(paretd) mkpart primary 259 771
(parted) name 3 swap

(parted) mkpart primary 771 -1
(parted) name 4 root

(parted) set 2 boot on

(parted) print
Model: ATA SenDisk SD6PP4M- (scsi)
Disk: /dev/sda 244198MiB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start    End        Size       File system  Name  Flags
1       1.00MiB  3.00MiB    2.00MiB                 grub  bios_grub
2       3.00MiB  259MiB     256MiB                  boot  boot, esp
3       259MiB   771MiB     512MiB                  swap
4       771MiB   244197MiB  243426MiB               root

(parted) quit
```

```zsh
% mke2fs -T small /dev/sda2
% mkswap /dev/sda3
% swapon /dev/sda3
% mkfs.ext4 /dev/sda4
```


### Mount partitions

```zsh
# mount `root` as gentoo
% mount /dev/sda4 /mnt/gentoo

# mount `boot` as gentoo/boot
% mkdir /mnt/gentoo/boot
% mount /dev/sda2 /mnt/gentoo/boot
```


### Stage3

```zsh
# set as UTC
% date
% date MMDDhhmmYYYY
```

`SystemRescueCD` does not have `links` and `lynx`.

```zsh
$ cd /mnt/gentoo
% elinks https://www.gentoo.org/downloads/mirrors

# download stag3 tar ball from mirror (current-stage3-amd64/stage3-amd64-xxxxxxxx.tar.bz2)
% ls
boot lost+found stage3-amd64-20160407.tar.bz2 stage3-amd64-20160407.tar.bz2.CONTENTS stage3-amd64-20160407.tar.bz2.DIGESTS stage3-amd64-20160407.tar.bz2.DIGESTS.asc

# verify
% openssl dgst -r -sha512 stage3-amd64-20160407.tag.bz2
XXXXXXXX *stage3-amd64-20160407.tar.bz2
% cat stage3-amd64-20160407.tar.bz2.DIGESTS
# SHA512 HASH
XXXXXXXX stage3-amd64-20160407.tar.bz2
...

# extract stag3
$ tar xvjpf stage3-amd64-20160407.tar.bz2 --xattrs
```


### Portage

```
% cd /mnt/gentoo
% vim etc/portage/make.conf
CFLAGS="-march=native -O2 -pipe"
MAKEOPTS="-j5" (Set CUPs + 1)
```

```zsh
% cd /mnt/gentoo
% mirrorselect -i -o >> etc/portage/make.conf

% mkdir etc/portage/repos.conf
% cp usr/share/portage/config/repos.conf etc/portage/repos.conf/gentoo.conf

# make sure gentoo.conf
% cat etc/portage/repos.conf/gentoo.conf
```

#### DNS

```
% cp -L /etc/resolv.conf /mnt/gentoo/etc
```

#### FileSystem

```
% mount /dev/sda4 /mnt/gentoo
% mount -t proc proc /mnt/gentoo/proc
% mount --rbind /sys /mnt/gentoo/sys
% mount --make-rslave /mnt/gentoo/sys
% mount --rbind /dev /mnt/gentoo/dev
% mount --make-rslave /mnt/gentoo/dev
```

#### Chroot

```zsh
% chroot /mnt/gentoo /bin/bash
% source /etc/profile
% export PS1="(chroot) $PS1"
```

#### Sync

```
% emerge-webrsync
% emerge --sync
```


### Setup timezon & locale

#### Editor

```
# first emerge vim without use flag
% emerge -av vim

# add USE
% vim /etc/portage/make.conf
```

```zsh
# vim /etc/env.d/99editor
```

```zsh
EDITOR=/usr/bin/vim
```

#### Locale

```
% vim /etc/locale.gen
% locale-gen
% locale -a
```

```
% vim /etc/env.d/02locale
LANG="en_US.UTF-8"
LC_COLLATE="POSIX"

% env-update
% source /etc/profile && export PS1="(chroot) $PS1"
```

#### Timezone

```zsh
# set Europe/Zurich
% cp /usr/share/zoneinfo/Europe/Zurich /etc/localtime
% vim /etc/timezone
Europe/Zurich
```

```zsh
% emerge --config sys-libs/timezone-data
```

#### keymap

```
% vim /etc/conf.d/keymaps
keymap="dvorak"
```

#### hwclock

```
% vim /etc/conf.d/hwclock
clock="local"
```

#### Tools

* pciutils
* gentoolkit


### Configure Kernel

```zsh
% echo 'sys-kernel/gentoo-sources symlink' >> /etc/portage/package.use/gentoo-sources
% emerge -av gentoo-sources
```

#### Kernel

`lspci -vv` and `dmesg` might be usefull to know which driver has to be enabled.

```zsh
% cd /usr/src/linux
% make menuconfig
% make && make modules_install
% cp arch/x86_64/boot/bzImage /boot/kernel-4.5.1-gentoo
```

* `e1000e` for enp0s25 (renamed from eth0)
* `iwlwifi` for wlo1 (renamed from wlan0)
* `cfg80211`

#### Kernel modules

```
# check modules
% find /lib/modules/<kernel version>/ -type f -iname '*.o' -or -iname '*.ko' | less
% vim /etc/conf.d/modules
```

#### Firmware

```
# Some drivers for wireless network need this
% emerge -av linux-firmware
```


### FileSystem

```zsh
% vim /etc/fstab

/dev/sda2     /boot        ext2 defaults         1 2
/dev/sda3     none         swap sw               0 0
/dev/sda4     /            ext4 noatime          0 1
/dev/cdrom    /mnt/cdrom   auto noauto,ro,user   0 0
```

### Setup system

#### Hostname

```
% vim /etc/conf.d/hostname
```

#### Password

```
% passwd
```

#### Tools

* syslog-ng
* vixie-cron
* mlocate
* dhcpcd
* logrotate
* ntp

```zsh
% rc-update add syslog-ng default
% rc-update add vixie-cron default
% rc-update add ntp-client default
```

#### Network

```zsh
% ip link
% cd /etc/init.d/
% ln -s net.lo net.wlo1
% ln -s net.lo net.enp0s25
...

# choose automatically starting interface at boot
% rc-update add net.wlo1 default
```


##### Note

###### iwlwifi

```
% dmesg
...
XXX request for firmware file 'iwlwifi-5000-4.ucode' failed.
XXX Direct firmware load for iwlwifi-5000-3.ucode failed with error -2
XXX request for firmware file 'iwlwifi-5000-3.ucode' failed.
XXX Direct firmware load for iwlwifi-5000-2.ucode failed with error -2
XXX request for firmware file 'iwlwifi-5000-2.ucode' failed.
XXX Direct firmware load for iwlwifi-5000-1.ucode failed with error -2
XXX request for firmware file 'iwlwifi-5000-1.ucode' failed.
```

The error -2 means ENOENT (i.e. file not found)  

Check wireless network device support as kernel module.
See `find /lib64 -iname 'iwlfifi*'` and check `/etc/conf.d/modules`

If you have still trouble in wlan firmware, then use `falling back to user helper`.

```
Device Drivers
    Generic Driver Options
        [*] Fallback user-helper invocation for firmware loading
```

###### rfkill

```
% wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf -i wlo1
Successfully initialized wpa_supplicant
rfkill: Cannot open RFKILL control device
wlo1: SME: Trying ...
wlo1: Associated with xx:xx:xx:xx
...
wlo1: CTRL-EVENT-CONNECTED
```

```
Networking support
    <M> Bluetooth subsystem support --->
    <M> RF switch subsystem support
```


### Bootloader

```zsh
# If you don't have
% echo 'media-font/freetype bzip2 png fontforge infinality utils' >> /etc/portage/package.use/freetype
% emerge -av sys-boot/grub:2

% grub2-install /dev/sda
installing for i386-pc platform.
installation finished. No error repoted.

% grub2-mkconfig -o /boot/grub/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/kernel-4.5.1-gentoo
done
```

```
# If you retry (after change files in `/etc/grub.d/*`)
% grub-install --target=i386-pc --recheck /dev/sda
```

#### If bios boot does not work

The following workaround works for me.

```text
Set the boot flag on the protective MBR partition (type 0xEE).
This can be done with parted /dev/sdX and disk_toggle pmbr_boot or using sgdisk /dev/sdX --attributes=1:set:2.
```

```
(parted) disk_toggle pmbr_boot
```

See also other [workarounds](https://wiki.arnux.org/index.php/GUID_Partition_Table#Workarounds)

#### Links

* [Configuring the bootloader](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Bootloader)
* [GRUB - ArchWiki](https://wiki.arnux.org/index.php/GRUB)


### Others

The followings are also usefull at installation.  
Emerge these also in your OS side. (SystemRescueCD has both)

* wpa_supplicant
* parted


### Debug

```zsh
% /etc/init.d/NetworkManager stop
# setup again wpa_supplicant at here if you need
% wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf -i wlo1 -B

% (mkdir /mnt/gentoo)
% mount /dev/sda4 /mnt/gentoo
% mount -t proc proc /mnt/gentoo/proc
% mount --rbind /dev /mnt/gentoo/dev
% mount --rbind /sys /mnt/gentoo/sys
% mount /dev/sda2 /mnt/gentoo/boot

# (if needed)
% cp /etc/resolv.conf /mnt/gentoo/etc/

% cd /mnt/gentoo
% env -i HOME=/root TERM=$TERM chroot . bash -l
% etc-update
% source /etc/profile

do something

% exit

% cd
% umount -l /mnt/gentoo/dev{/shm,/pts,}
% umount -l /mnt/gentoo{/boot,/sys,/proc,}
% reboot
```

### Links

* [Handbook:AMD64 - GentooWiki](https://wiki.gentoo.org/wiki/Handbook:AMD64)
* [Gentoo Forums:: View [SOLVED] iwlwifi fails to load after upgrade to 3.17.0](https://forums.gentoo.org/viewtopic-t-1001638.html)
* [iwlwifi - Debian Wiki](https://wiki.debian.org/iwlwifi)
* [GUID Partition Table - ArchWiki](https://wiki.arnux.org/index.php/GUID_Partition_Table)
* [GRUB - ArchWiki](https://wiki.arnux.org/index.php/GRUB)
