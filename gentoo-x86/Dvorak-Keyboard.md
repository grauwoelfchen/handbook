
I use Dvorak keymap.

* for x-org
  - /etc/X11/xorg.conf

```
Section "InputDevice"
        Identifier  "Keyboard0"
        Driver      "kbd"
        Option      "CoreKeyboard"
        Option      "XkbRules" "xorg"
        Option      "XkbModel" "pc105"
        Option      "XkbLayout" "dvorak"
        Option      "XkbVariant" "dvorak"
EndSection
```

* for gdm login winodw
  - /usr/share/X11/xorg.conf.d/10-evdev.conf

```
Section "InputClass"
        Identifier "evdev keyboard catchall"
        MatchIsKeyboard "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
        Option "XkbLayout" "dvorak"
        Option "XkbVariant" "dvorak"
EndSection
```

