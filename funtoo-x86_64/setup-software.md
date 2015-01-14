# Setup Development environment

$ emerge sudo
$ emerge dbus

$ rc-update add dbus default

-----

## console font

* infinalyty
  * cycle dependency

```
\# USE="-infinality" emerge -av freetype
\# USE="infinality" emerge -av freetype
```

* font

```
\# emerge -av terminus-font
\# setfont <name> (in /usr/share/consolefonts)
\# vim /etc/conf.d/consolefont (permanent)
\# eselect rc add consolefont default
```

list

```
(cd /usr/share/consolefonts && find . -type f -name '*.psf.gz'; ) |
    sed 's/.\/\(.*\).psf.gz/\1/' |
    sort |
    column
```

-----

## clock

### ntp

$ emerge ntp

/etc/init.d/ntpd start
rc-update add ntpd default


### hwclock

$ rc-update
hwclock | boot

```
#clock_systohc="NO"
clock_systohc="YES"
```

vim adjustclock

```
#!/bin/sh

ntpdate ntp3.jst.mfeed.ad.jp
hwclock --systohc
hwclock -w
```
$ sudo adjustclock


-----

## X11

$ emerge xorg-server
$ emerge portage-utils; qlist -I -C x11-drivers/
$ emerge xscreensaver

### Note

back to console

```
Ctrl + Alt + F1
```

-----

## xterm

$ emerge xterm

```
USE="truetype unicode"
```

set keymap

$ vim /usr/share/X11/xorg.conf.d/10-evdev.conf

```
Section "ImputClass"
  Identifier "evdev keyboard catchall"
  MatchIsKeyboard "on"
  MatchDevicePath "/dev/input/event*"
  Option "XkbLayout" "dvorak"
  Option "XkbVariant" "dvorak"
EndSection
```

create $HOME/.Xresources

### Ref.
* https://gist.github.com/2018320


-----

## slim

$ emerge slim
$ rc-update add xdm default
$ vim /etc/conf.d/xdm

```
DISPLAPYMANAGER="slim"
```

create .xinitrc

```

```

edit login_cmd on /etc/slim.conf for $HOME/.xinitrc

```
...
36 login_cmd exec /bin/bash -login ~/.xinitrc %session
37 #login_cmd exec /bin/bash -login /usr/share/slim/Xsession %session
38
...
68 #welcome_msg Welcome to %host
69 welcome_msg Willkommen zu %host
...
93 current_theme default
64 current_theme xxx
...
```

-----

## Set variables

in `/etc/portage/make.conf`

```
#ALSA_CARDS="hda-intel"
ALSA_CARDS="snd-oxygen"
INPUT_DEVICES="evdev keyboard mouse"
#VIDEO_CARDS="nouveau"
VIDEO_CARDS="intel"
```

-----

## alsa

$ emerge alsa-utils
$ lspci -vv | grep -i audio

\# vim /etc/modprobe.d/asla.conf

\# rc-update add alsasound boot
\# /etc/init.d/alsasound start
\# alsamixer

\# cat /proc/asound/cards
\# cat /proc/asound/version

\# gpasswd -a <username> audio

\# emerge mplayer
\# mplayer cdda:// -cdrom-device /dev/scd0

### Refs.

* http://www.gentoo.org/doc/ja/alsa-guide.xml#initscript


-----

## Input method

\# vim /etc/make.conf

USE="emacs anthy"

\# emrege -av anthy
\# emerge -av uim

$ vim ~/.xinitrc

-----

## ion3

\# emerge lua
$ wget http://tuomov.iki.fi/software/dl/ion-3-20090110.tar.gz
$ cd ion3-20090110
$ vim system.mk
  * lua path '/usr/local' => '/usr'

$  make && sudo make install

vim ~/.xinitrc

```
 exec ion3
```

### Ref.
* https://github.com/grauwoelfchen/ion3-config


-----

## keyboard setup

$ emerge xev
$ emrege xkbset

$ check with xev

create .xmousekey

for my HHKB keyboard

```
#!/bin/bash

# turn on mousekeys
xkbset m
# stop mousekeys expiring after timeout
xkbset exp =m
# set the Super_R key to paste its contents: HHKB
xmodmap -e "Keycode 134 = Pointer_Button2"
```

source .xmousekey in bashrc


-----

## input method

uim-anthy

$ uim-pref-gtk

install font to /usr/share/fonts

create font scale and load from X

$ xterm -h | grep fa

### Ref.
* http://grauwoelfchen.at/graffiti/xterm_with_ttf-font

