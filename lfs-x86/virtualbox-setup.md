# VirtualBox

## Install (on Gentoo)

### 1. emerge

`emerge virtualbox` with USE flag `USE="headless additions vnc -qt4"`.

### 2. load kernel modules

```
$ sudo modprobe -l
...
misc/vboxnetflt.ko
misc/vboxpci.ko
misc/vboxnetadp.ko
misc/vboxdrv.ko
```

edit `/etc/conf.d/modules`

```
modules="vboxdrv vboxnetadp vboxnetflt vboxpci"
```


## Create VM

### 1. create virtual machine

```
$ VBoxManage list ostypes
$ VBoxManage createvm --name wetterhorn --ostype Linux --register
$ VBoxManage list vms
"wetterhorn" {ad24d296-8375-4eea-8322-85b2e3791af3}
```

### 2. memory

default is "128MB". check with `$ VBoxManage showvminfo wetterhorn`

```
$ VBoxManage modifyvm wetterhorn --memory 512
```

### 3. create hard disk

`--size <megabytes>`

```
$ VBoxManage createhd --filename "wetterhorn/wetterhorn.vdi" --size 102400
```

### 4. add strage controller

IDE Controller is default of virtualbox.

```
$ VBoxManage storagectl "ubuntu server" --name "IDE Controller" --add ide
```

### 5. attach hard disk, live cd

__HD__

Attach HD.

```
$ VBoxManage storageattach "wetterhorn" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium "wetterhorn/wetterhorn.vdi"
```

__DVD/CD__

[San Antonio, TX, USA](ftp://anduin.linuxfromscratch.org/LFS-LiveCD/) FTP Mirror has newest live cd.  
*lfslivecd-x86-6.3-r2160-min.iso (232MB)*. Use this 32bit (x86) version.

Attach livecd.

```
$ VBoxManage storageattach "wetterhorn" --storagectl "IDE Controller" --port 1 --device 1 --type dvddrive --medium ~/Downloads/lfslivecd-x86-6.3-r2160-min.iso
```


## Run VM

### 1. run vm

```
$ VBoxHeadless --startvm wetterhorn --vnc --vrde off
Oracle VM VirtualBox Headless Interface 4.1.18_Gentoo_
(C) 2008-2012 Oracle Corporation
All rights reserved.

20/08/2012 02:41:55 Listening for VNC connections on TCP port 5900
20/08/2012 02:41:55 Listening for VNC connections on TCP6 port 5900
Set framebuffer: buffer=7f973f500010 w=800 h=600 bpp=32
Set framebuffer: buffer=7f973ba7a000 w=640 h=480 bpp=32
Set framebuffer: buffer=7f97405858d0 w=640 h=480 bpp=32
Set framebuffer: buffer=7f97404598c0 w=720 h=400 bpp=32
```

### 2. connect to vm

* x2vnc (multiple display)
* tigervnc

__x2vnc__

```
$ x2vnc localhost:5900
```

__tigervnc__

```
$ vncviewer localhost

TigerVNC Viewer for X version 1.1.0 - built Aug 20 2012 03:25:14
Copyright (C) 1999-2011 TigerVNC Team and many others (see README.txt)
See http://www.tigervnc.org for information on TigerVNC.

Mon Aug 20 03:29:30 2012
 CConn:       connected to host localhost port 5900

Mon Aug 20 03:29:31 2012
 CConnection: Server supports RFB protocol version 3.8
 CConnection: Using RFB protocol version 3.8
 TXImage:     Using default colormap and visual, TrueColor, depth 24.
 CConn:       Using pixel format depth 24 (32bpp) little-endian rgb888
 CConn:       Using Tight encoding
```

output on vm process.

```
20/08/2012 03:29:30 Got connection from client 127.0.0.1
20/08/2012 03:29:30   other clients:
20/08/2012 03:29:31 Normal socket connection
20/08/2012 03:29:31 Client Protocol Version 3.8
20/08/2012 03:29:31 Protocol version sent 3.8, using 3.8
20/08/2012 03:29:31 rfbProcessClientSecurityType: executing handler for type 1
20/08/2012 03:29:31 rfbProcessClientSecurityType: returning securityResult for client rfb version >= 3.8
20/08/2012 03:29:31 Pixel format for client 127.0.0.1:
20/08/2012 03:29:31   32 bpp, depth 24, little endian
20/08/2012 03:29:31   true colour: max r 255 g 255 b 255, shift r 16 g 8 b 0
20/08/2012 03:29:31 Enabling full-color cursor updates for client 127.0.0.1
20/08/2012 03:29:31 Enabling NewFBSize protocol extension for client 127.0.0.1
20/08/2012 03:29:31 rfbProcessClientNormalMessage: ignoring unsupported encoding type Enc(0xFFFFFECC)
20/08/2012 03:29:31 rfbProcessClientNormalMessage: ignoring unsupported encoding type Enc(0xFFFFFECD)
20/08/2012 03:29:31 Enabling LastRect protocol extension for client 127.0.0.1
20/08/2012 03:29:31 Using image quality level 8 for client 127.0.0.1
20/08/2012 03:29:31 Using JPEG subsampling 0, Q92 for client 127.0.0.1
20/08/2012 03:29:31 Using tight encoding for client 127.0.0.1
```


## links

* [Download the Official LFS LiveCD](http://www.linuxfromscratch.org/livecd/download.html)
* [Linux From Scratch(http://www.linuxfromscratch.org/) 入門](http://ww21.tiki.ne.jp/~takeda/lfs.html)
* (ja)[FreeBSD なサーバーに VirtualBox を入れて、その上で Ubuntu server を動かす](http://d.hatena.ne.jp/f99aq/20110919/1316436810)
* (ja)[How to setup headless Sun xVM VirtualBox on Ubuntu server](http://burnz.wordpress.com/2008/09/04/how-to-setup-headless-xvm-virtualbox-on-ubuntu-server/)
