# Setup as laptop

* use `sudo`
* use `sudo eselect rc` instead of `rc-update`


## Create user

```zsh
: Create your user
# useradd -m -G users,wheel,audio -s /bin/bash USERNAME
# passwd USERNAME
```

```zsh
# emerge -av sudo

: Then add USERNAME as sudoers
# visudo

# exit
```


## Setup system

### Shell

```zsh
% sudo emerge -av zsh
% sudo username USERNAME -s /bin/zsh
% touch ~/.zshrc
% exit
```

### Freetype

(if you don't have yet, and if you want)

* freetype with `infinality`

### Consolefont

```zs
% sudo emerge -av terminus-font
% sudo setfont <name>
% sudo vim /etc/conf.d/consolefont
% sudo eselect rc add consolefont default
```

Use name like `ter-i18n`.  
This is how to check consolefont list.

```zsh
(cd /usr/share/consolefonts && find . -type f -name '*.psf.gz'; ) |
    sed 's/.\/\(.*\).psf.gz/\1/' |
    sort |
    column
```

### ntp and hwclock

#### ntp-client

```zsh
# If you don't have yet
% sudo emerge -av ntp
```


Edit `/etc/ntp.conf`

```text
servers 0.ch.pool.ntp.org
servers 1.ch.pool.ntp.org
servers 2.ch.pool.ntp.org
servers 3.ch.pool.ntp.org
```

Or use servers for Gentoo users

```text
server 0.gentoo.pool.ntp.org
server 1.gentoo.pool.ntp.org
server 2.gentoo.pool.ntp.org
server 3.gentoo.pool.ntp.org
```

See [ntp servers in Switzerland](http://www.pool.ntp.org/zone/ch).

```zsh
% sudo eselect rc add ntp-client default
```

#### hwclock

```zsh
% sudo eselect rc list | grep hwclock
 hwclock          boot

% sudo vim /etc/conf.d/hwclock
clock_systohc="YES"
```

```sh
% cat adjustclock
#!/bin/sh

# Asia/Tokyo
# ntpdate ntp3.jst.mfeed.ad.jp
# Europe/Zurich
ntpdate bernina.ethz.ch

hwclock --systohc
hwclock -w
```

```zsh
% sudo adjustclock
```

### DBus

```zsh
% sudo emerge -av dbus
% sudo eselect rc add dbus default
```

### SSH

```zsh
# check USE flags for openssh
% equery u openssh

% sudo emerge -av openssh
```

```
# edit sshd_config (for server)
# for your needs
% sudo vim /etc/ssh/sshd_config

# edit ssh_config (for client)
# then append `UseRoaming no`
% sudo vim /etc/ssh/ssh_config
```

### Git

```
% sudo su
# echo 'app-crypt/gnupg tools' >> /etc/portage/package.use/gnupg
# echo 'dev-vcs/git highlight' >> /etc/portage/package.use/git
# exit

% sudo emerge -av dev-vcs/git
```


## Setup X11

Set your `USE` flags for x11-drivers,  
like `synaptics` for toucpad, `nvidia` for monitor etc.

I don't use touchpad.

And you might need also `virtualbox`, `libressl` for your environment.

```
% sudo emerge -av xorg-server
% sudo emerge -av portage-utils

% qlist -I -C x11-drivers/

% sudo emerge -av xscreensaver
```

### xorg.conf.d

```
Section "InputClass"
  Identifier "evdev pointer catchall"
  MatchIsPointer "on"
  MatchDevicePath "/dev/input/event*"
  Driver "evdev"
  Option "EmulateWheel" "true"
  Option "EmulateWheelButton" "2"
  Option "Emulate3Buttons" "false"
  Option "XAxisMapping" "6 7"
  Option "YAxisMapping" "4 5"
EndSection

Section "InputClass"
  Identifier "evdev keyboard catchall"
  MatchIsKeyboard "on"
  MatchDevicePath "/dev/input/event*"
  Driver "evdev"
  Option "XkbLayout" "dvorak"
  Option "XkbVariant" "dvorak"
EndSection
```

Create `~/.Xresources` and `~/.xinitrc`  
(just clone it from your repo for rc-files)


### desktop

* slim

```zsh
% sudo emerge -av slim

% sudo eselect rc add xdm default
% sudo cat /etc/conf.d/xdm
DISPLAPYMANAGER="slim"
```

### Note

```
# save current file as sudo user in vim
:w !sudo tee>/dev/null %
```
