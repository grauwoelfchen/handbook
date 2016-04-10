# Burn CD/DVD

## portages

```
% sudo emerge -av dvd+rw-tools
% sudo emerge -av cdrtools
```

## dd

```
insert CD
# mount
# umount /dev/cdrom
# dd if=/dev/cdrom of=/tmp/image.iso
```

## cdrtools

```
% emerge -av cdrtools
```

### check scsibus

```
% cdrecord -scanbus
Cdrecord-ProDVD-ProBD-Clone 3.01a13 (x86_64-unknown-linux-gnu) Copyright (C) 1995-2012 Joerg Schilling
Linux sg driver version: 3.5.34
Using libscg version 'schily-0.9'.
scsibus0:
        0,0,0     0) 'Optiarc ' 'DVD RW AD-7280S ' '1.21' Removable CD-ROM
        0,1,0     1) *
        0,2,0     2) *
        0,3,0     3) *
        0,4,0     4) *
        0,5,0     5) *
        0,6,0     6) *
        0,7,0     7) *
scsibus1:
        1,0,0   100) 'ATA     ' 'ST500DM002-1BD14' 'KC45' Disk
        1,1,0   101) *
        1,2,0   102) *
        1,3,0   103) *
        1,4,0   104) *
        1,5,0   105) *
        1,6,0   106) *
        1,7,0   107) *
```

#### check options

```
% cdrecord dev=0,0,0 driveropts=help -checkdrive
Cdrecord-ProDVD-ProBD-Clone 3.01a13 (x86_64-unknown-linux-gnu) Copyright (C) 1995-2012 Joerg Schilling
scsidev: '0,0,0'
scsibus: 0 target: 0 lun: 0
Linux sg driver version: 3.5.34
Using libscg version 'schily-0.9'.
Device type    : Removable CD-ROM
Version        : 5
Response Format: 2
Capabilities   :
Vendor_info    : 'Optiarc '
Identifikation : 'DVD RW AD-7280S '
Revision       : '1.21'
Device seems to be: Generic mmc2 DVD-R/DVD-RW/DVD-RAM.
Driver options:
burnfree        Prepare writer to use BURN-Free technology
noburnfree      Disable using BURN-Free technology
layerbreak      Write DVD-R/DL media in automatic layer jump mode
layerbreak=val  Set jayer jump address for DVD+-R/DL media
```

### test

* `-dummy`
* `-dao`: Disk at Once

```
% cdrecord -dummy -v dev=0,0,0 driveropts=burnfree speed=12 -dao ~/Downloads/test.iso
```

### bake


```
% cdrecord -v dev=0,0,0 driveropts=burnfree speed=12 -dao ~/Downloads/test.iso
```


## growisofs

* `-dvd-compat`: dvd-rom
* `-Z /dev/dvd=/path/to/iso`

```
% growisofs -dvd-compat -speed=8 -Z /dev/dvd=test.iso
% growisofs -Z /dev/dvd -R -J ./*
```


## links

* http://www.gentoo-wiki.info/HOWTO_Create_a_DVD:Burn
