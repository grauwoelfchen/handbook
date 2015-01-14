
* Check sound card. `lspci -vv | grep -i audio`

* `aplay -l`

* check menuconfig (driver install as Module)

* vim /etc/modprobe.d/alsa.conf. my current [[alsa.conf|https://gist.github.com/1611891]]

* set "ALSA_CARDS" to /etc/make.conf

* alsa-utils

```
emerge alsa-utils
rc-update add alsasound boot
```

* NOTE: alsaconf doesn't work.

* alsamixer 
  - check to volume '00' of "Front Speaker"


__refs__

* http://bugtrack.alsa-project.org/main/index.php/Matrix:Module-hda-intel
* http://ubuntuforums.org/showthread.php?t=1474700

