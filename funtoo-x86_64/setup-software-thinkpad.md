# Setup Development environment

```
% emerge sudo
```

## Setup truetype

* truetype has cycle dependency with `infinalyty` flag

```
;; to avoid cycle dependency
% echo 'media-libs/freetype png' >> /etc/portage/package.use
% USE="-infinality" emerge -av freetype
% USE="infinality" emerge -av freetype
```

-----

## clock

### ntp

```
% echo 'net-misc/ntp ssl' >> /etc/portage/package.use
% emerge -av ntp
% rc-service ntp-client start
% rc-update add ntp-client default
```

### hwclock

```
% vim /etc/conf.d/hwclock
#clock_systohc="NO"
clock_systohc="YES"

#clock_hctosys="NO"
clos_hctosys="YES"
% rc-service hwclock restart
% rc-update add hwclock boot
```

create `adjustclock` command

```
% vim adjustclock
#!/bin/sh

ntpdate ntp3.jst.mfeed.ad.jp
hwclock --systohc
hwclock -w
% sudo adjustclock
```

-----

## util

```
% emerge -av portage-utils
```


## vim

```
;; racket ebuild has some bugs
% emerge -av jpeg libpng
% emerge -av x11-libs/pango
% emerge -av racket

;; +racket
% emerge -av vim
```

-----

## X11

```
;; setup device and use flag for X11 window system
% vim /etc/portage/make.conf
VIDEO_CARDS="intel"
INPUT_DEVICES="evdev synaptics"
;; emerge xorg-server
% echo "x11-base/xorg-drivers ADDITONAL_USE_FLAG" >> /etc/poratage/package.use

% emerge -av xorg-server
% emerge -av xscreensaver
```

```
;; add dvorak option to xorg.conf
% vim /usr/share/X11/xorg.conf.d/10-evdev.conf
option

;; add fonts to xorg.conf
% vim /usr/share/X11/xorg.conf.d/99-font.conf
```

```
% emerge -av xev
% emerge -av xkbset
% emerge -av xmodmap
```


```
% emerge dbus
% rc-update add dbus default
```

## StumpWM

```
;; stumpish needs this
% emerge -av font-misc-misc
% emerge -av xprop
% emerge -av rlwrap
;; stumpwm need this
% emerge -av xdpyinfo
% emerge -av sbcl
% curl -O http://quicklisp.org/ ...
% sbcl --load quicklisp.lisp

(ql)

;; edit ~/.sbclrc

;; clone stumpwm
% autoconf
% make
% sudo make install
```

### font for stumpWM

```
;; from github
I'm on gentoo and stumpwm fails to start. It produces the error: There is no applicable method for the generic function # when called with arguments (NIL).

You're missing a font package that StumpWM needs to run.

StumpWM's default font, "9x15bold" is part of media-fonts/font-misc-misc. This package used to be a dependency of x11-base/xorg-server, but since version 1.5, it has to be emerged explicitly.
```





## input method

anthy + uim

`LINGUAS="en de ja"`

```
;; install anthy
% emerge -av anthy

;; enable anthy support 
# echo "app-i18n/uim anthy skk" >> /etc/portage/package.use
% emerge -av uim
```


## slim

$ emerge slim
$ rc-update add xdm default
$ vim /etc/conf.d/xdm

```
DISPLAPYMANAGER="slim"
```



```
% vim /etc/slim.conf
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

### install my theme

```
% cd /usr/share/slim/themes
% git clone
```


## font

* azukifontLP100
* dejavu `emereg -av dejavu`
