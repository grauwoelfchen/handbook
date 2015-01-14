# Ubuntu 12.10 32bit

## VirtualBox

### X drivers

`12.10` needs VBoxGuestAdditions of virtualbox 4.2.2.  
X drivers are not found.

```
Installing the Window System drivers
Warning: unknown version of the X Window System installed.  Not installing
X Window System drivers.
```

### attach

```
$ VBoxManage storageattach weisshorn --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium /usr/share/virtualbox/VBoxGuestAdditions.iso 
```
-----

### .xinitrc and .xsession

need +x permission :(

-----

### alternatives

```
$ sudo update-alternatives --config editor
```

-----

## Applications

* System Preferences: `gnome-control-center`
* Gnome File Manager: `nautilus`

* kill gnome-keyring
  * /etc/xdg/autostart/gnome-keyring-ssh.desktop
  * http://askubuntu.com/questions/162850/how-to-disable-the-keyring-for-ssh-and-gpg

-----

## Desktop

* Stumpwm
  * needs `grome-session-fallback`
