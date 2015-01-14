
Once I setuped with broadcom-sta, but it calls wlan0 eth1.
I remove it.


* lspci

```
lspci -nn | grep Network
03:00.0 Network controller [0280]: Broadcom Corporation Device [14e4:4353] (rev 01
```

* setup driver
  - make menuconfig

```
-*- Device Drivers
  [*] Staging drivers
    [*] Broadcom IEEE802.11n PCIe SoftMAC WLAN driver
```


* get new firmware
  - get from [[kernel.org|http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=summary]] (or emerge linux-firmware) to /lib/firmware
  - add to .config

```
CONFIG_EXTRA_FIRMWARE="brcm/bcm43xx-0.fw brcm/bcm43xx_hdr-0.fw"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
```

```
CC      drivers/staging/staging.o
CC      drivers/staging/brcm80211/brcmsmac/wl_mac80211.o
CC      drivers/staging/brcm80211/brcmsmac/wl_ucode_loader.o
CC      drivers/staging/brcm80211/brcmsmac/wlc_alloc.o
CC      drivers/staging/brcm80211/brcmsmac/wlc_ampdu.o
CC      drivers/staging/brcm80211/brcmsmac/wlc_antsel.o
CC      drivers/staging/brcm80211/brcmsmac/wlc_bmac.o
CC      drivers/staging/brcm80211/brcmsmac/wlc_channel.o
CC      drivers/staging/brcm80211/brcmsmac/wlc_main.o
CC      drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.o
CC      drivers/staging/brcm80211/brcmsmac/wlc_pmu.o
CC      drivers/staging/brcm80211/brcmsmac/wlc_rate.o
CC      drivers/staging/brcm80211/brcmsmac/wlc_stf.o
CC      drivers/staging/brcm80211/brcmsmac/aiutils.o
CC      drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.o
CC      drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.o
CC      drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.o
CC      drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.o
CC      drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.o
CC      drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.o
CC      drivers/staging/brcm80211/brcmsmac/bcmotp.o
CC      drivers/staging/brcm80211/brcmsmac/bcmsrom.o
CC      drivers/staging/brcm80211/brcmsmac/hnddma.o
CC      drivers/staging/brcm80211/brcmsmac/nicpci.o
CC      drivers/staging/brcm80211/brcmsmac/nvram.o
LD      drivers/staging/brcm80211/brcmsmac/brcmsmac.o
LD      drivers/staging/brcm80211/brcmsmac/built-in.o
CC      drivers/staging/brcm80211/util/bcmutils.o
CC      drivers/staging/brcm80211/util/bcmwifi.o
LD      drivers/staging/brcm80211/util/brcmutil.o
LD      drivers/staging/brcm80211/util/built-in.o
LD      drivers/staging/brcm80211/built-in.o
LD      drivers/staging/generic_serial/built-in.o
LD      drivers/staging/tty/built-in.o
LD      drivers/staging/built-in.o
```

```
 MK_FW   firmware/brcm/bcm43xx-0.fw.gen.S
 AS      firmware/brcm/bcm43xx-0.fw.gen.o
 MK_FW   firmware/brcm/bcm43xx_hdr-0.fw.gen.S
 AS      firmware/brcm/bcm43xx_hdr-0.fw.gen.o
```

* blacklist
  - `vim /etc/modprobe.d/blacklist.conf`
  - add blacklist b43

* dmesg | grep bcm

```
[    0.870794] usbcore: registered new interface driver bcm5974
[    2.339365] bcm5974 1-1.2:1.2: usb_probe_interface
[    2.339368] bcm5974 1-1.2:1.2: usb_probe_interface - got id
[    2.339424] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input6
```

* ifconfig -a

```
wlan0     Link encap:Ethernet  HWaddr 60:33:4b:03:1f:e7  
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```

* setup wireless lan
  - `emerge wpa_supplicant`
  - check CONFIG_PACKET in .config
  - `wpa_pssphrase ESSID PASSOWRD`
  - setup /etc/wpa_supplicant/wpa_supplicant.conf
  - test with `wpa_supplicant -Dnl80211 -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf`

* config tools
  - `emerge ifplugd`
  - `emerge openresolv`
  - `emerge wireless-tools`  (for iwconfig)


__refs__

* http://en.gentoo-wiki.com/wiki/Broadcom_43xx
* http://www.lxg.de/code/broadcom-4353-wireless-et-al-opensource-howto
* http://wireless.kernel.org/en/users/Drivers/brcm80211#Get_the_code
