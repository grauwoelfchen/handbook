# Install/Setup MacBookAir4,2

## SystemRescueCD

```
root@sysrescd /root % dmidecode -s system-product-name
MacBookAir4,2
```

## Note

    4 Intel(R) Core(TM) i5-2557M CPU @ 1.70GHz CPU(s) @ 1701MHz

    Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller
    driver = sda_hda_intel

    Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller
-----

## Network

```
# lspci -nn | grep Network
02:00.0 Network controller [0280]: Broadcom Corporation BCM43224 802.11/a/b/g/n [14e4:4353] (rev 01)
```

If you use SystemRescueCd, stop NetworkManager, first.

```
# /etc/init.d/NetworkManager stop
```

Then

```
# ifconfig wlp2s0 up
# iwlist wlp2s0 scan

# wpa_passphrase SSID PASSPHRASE >> /etc/wpa_supplicant/wpa_supplicant.conf
# vim /etc/wpa_supplicant/wpa_supplicant.conf

scan_ssid=1
proto=WPA2
key_mgmt=WPA-PSK
pairwise=CCMP TKIP
group=CCMP TKIP

# wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf -i wlp2s0 -D wext
...
WPA: Key negotiation completed with xx:xx:xx:xx:xx:xx [PTK=CCMP GTK=CCMP]
```

```
# wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf -i wlp2s0 -D wext -B
# dhcpcd -d wlp2s0
...
dhcpcd[2090]: forked to background, ...
```

-----

## Install



-----

## Setup

* wireless-tools
* wicd
* sudo
* zsh
* vim

-----

## Wireless Network

* brcmsmac
* add `blacklist b43`

* wpa_supplicant
* dhcp
* wicd
  * `rc-update add wicd default`

```
[*] Networking support  --->
    -*- Wireless  --->
      <*>   cfg80211 - wireless configuration API
      [*]     cfg80211 wireless extensions compatibility   # => extension
```




### User

```
# useradd -m -G users,wheel,audio,chrom -s /bin/zsh <username>
# passwd USERNAME
```
