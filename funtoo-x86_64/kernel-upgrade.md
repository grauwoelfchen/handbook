

* check gentoo kernel support list [http://packages.gentoo.org/package/sys-kernel/gentoo-sources]
* do `sudo emerge --sync`
* do `sudo emerge -av portage` if this is needed.
* `sudo emerge -av sys-kernel/gentoo-sources` (your sources)
* `sudo emerge -C (--unmerge) (old-soerces)`

```
% sudo USE="symlink" emerge -av sys-kernel/gentoo-sources

These are the packages that would be merged, in order:

Calculating dependencies... done!
[ebuild  NS    ] sys-kernel/gentoo-sources-3.8.0:3.8.0 [3.7.6:3.7.6] USE="symlink -build -deblob" 82,663 kB

Total: 1 package (1 in new slot), Size of downloads: 82,663 kB

Would you like to merge these packages? [Yes/No]
```

```
eselect kernel list
```


```
« stockhorn » ~ 
% cd /usr/src 
« stockhorn » /usr/src 
% ls -la
total 16
drwxr-xr-x  4 root root 4096 Feb 26 01:04 .
drwxr-xr-x 15 root root 4096 Oct 15 15:07 ..
-rw-r--r--  1 root root    0 May 26  2012 .keep_sys-apps_baselayout-0
lrwxrwxrwx  1 root root   18 Feb 26 00:59 linux -> linux-3.8.0-gentoo
drwxr-xr-x 24 root root 4096 Feb 20 21:19 linux-3.7.6-gentoo
drwxr-xr-x 23 root root 4096 Feb 26 00:59 linux-3.8.0-gentoo
```

* cd /usr/src/linux
* sudo make menuconfig
* make && make modules_install


### Framebuffer


```
<*>   Userspace VESA VGA graphics support
[*]   VESA VGA graphics support
[*]   EFI-based Framebuffer Support
```

```
 Symbol: FB_EFI [=y]
  │ Type  : boolean
  │ Prompt: EFI-based Framebuffer Support
  │   Defined at drivers/video/Kconfig:768
  │   Depends on: HAS_IOMEM [=y] && FB [=y]=y && X86 [=y] && EFI [=y]
  │   Location:
  │     -> Device Drivers
  │       -> Graphics support
  │         -> Support for frame buffer devices (FB [=y])
  │   Selects: FB_CFB_FILLRECT [=y] && FB_CFB_COPYAREA [=y] && FB_CFB_IMAGEBLIT [=y]

```

### Ref.

* [http://www.funtoo.org/wiki/Funtoo_Linux_Installation#Configuring_and_installing_the_Linux_kernel]

