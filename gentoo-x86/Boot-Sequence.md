
* first Vim
  - `emerge vim`

* locale
  - `vim /etc/lacale.gen` en, de, ja
  - locale-gen

* kernel-sourses
  - `emerge gentoo-sources`
  - `emerge pciutls`

* menuconfig
  - `cd /usr/src/linux`
  - `make menuconfig`

```
Processor type and features --->
  Processor Family (Core 2/newer Xeon) --->
    (X) Core 2/newer Xeon

File System --->
  <*> Second extended fs support
  <*> Ext3 jornalling file system support
  <*> The Extended 4 (ext4) filesystem
  <*> Apple Macintosh file system support
  <*> Apple Extended HFS file system support
  Partition types --->
    [*] Advanced partition selection
    [*] Macintosh partion map support
    [*] EFI GUID Partition support

Device Driver --->
  [*] USB support --->
    [*] Apple Cinema Display support
    [*] iSight firmware loading support
  <M> Sound card support --->
    <M> Advanced Linux Sound Architecture -->
      <M> Sequencer support
      <M> OSS Mixer API
      <M> OSS PCM (digital audio) API
      [*] PCI sound devices --->
        <M> Intel HD Audio --->
        <M> Intel/SiS/nVidia/AMD/ALi AC97 Controller
      <M> ALSA for SoC audio support --->
    < > Open Sound System (DEPRECATED) --->
  [*] Staging drivers
    <*> Broadcom IEEE802.11n PCIe SoftMAC WLAN driver
    <M> Nouveau (nVidia) cards
  [*] Input device support
    [*] Mice --->
      <*> Apple USB Touchpad support
      <*> Apple USB BCM5974 Multitouch trackpad support
  [*] Network device support --->
    [*] Wireless LAN --->
      <*> Broadcom 43xx wireless support (mac80211 stack)
      <*> Hermes chipset 802.11b support (Orinoco/Prism2/Symbol)
  [*] Hardware Monitoring support --->
    <*> Apple SMC (Monitor sensor, light sensor, keyboard backlight)

Graphics support --->
  -*- Backlight $ LCD device support --->
    <*> Apple Backlight Driver
```

* system tools
  - `emerge syslog-ng`
  - `emerge logrotate`
  - `emerge vixie-cron`
  - `emerge mlocate`
  - `emrege dhchcd`
  - `emerge busybox` for rescue boot
  - `emerge diskdev_cmds` for hfsplus fs
  
* grub
  - `vim /etc/grub/grub.conf`
  - [[grub.conf|https://gist.github.com/1603488]]
  - grub-install

* xorg-server
  - addd VIDEO_CARDS="nvidia" to make.conf [update] set "nouveau" with staging driver
  - echo 'x11-base/xorg-server udev' >> /etc/portage/package.use
  - `Xorg -configure`
  - `vim /root/xorg.conf.new`
  - `X -config /root/xorg.conf.new` as test
  - my current [[xorg.conf|https://gist.github.com/1603584]]
  - `startx`

* gnome
  - `emerge gnome`
  - `emerge gdm`
  - setup .xinitrc, .xsession

