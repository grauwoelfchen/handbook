# Setup Server

$ emerge sudo

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


-----

### Note

back to console

```
Ctrl + Alt + F1
```
