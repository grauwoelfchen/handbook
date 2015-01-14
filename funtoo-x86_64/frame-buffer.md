
# Frame buffer setting

/usr/src/linux/Documentation/fb/uvesafb.txt


```
/var/log/messages
Sep 27 02:06:19 stockhorn kernel: [    0.698783] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
Sep 27 02:06:19 stockhorn kernel: [    0.699036] [drm] MTRR allocation failed.  Graphics performance may suffer.
```

lilo.conf に append で指定してみたがだめ...。

```
# dmesg | grep mtrr
[    0.000000] Command line: auto BOOT_IMAGE=gentoo ro root=803 video=uvesafb:1680x1050-32,mtrr:2,ywrap
[    0.000000] Kernel command line: auto BOOT_IMAGE=gentoo ro root=803 video=uvesafb:1680x1050-32,mtrr:2,ywrap
[    0.698783] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    0.973340] mtrr: type mismatch for e0000000,8000000 old: write-back new: write-combining
```

CONFIG_FB の Location。

```
Location:
        -> Device Drivers
            -> Graphics support
                -> Support for frame buffer devices (FB [=y])
```

MTRR の support をチェック。

```
 -*- MTRR (Memory Type Range Register) support
      [*]   MTRR cleanup support
      (1)     MTRR cleanup enable value (0-1)
      (1)     MTRR cleanup spare reg num (0-7)
```

MTRR cleanup enable value (0-1) を 0 から 1 にしてみた。  
Boot 時のメッセージが増えた。

```
# dmesg | grep mtrr
[    0.000000] Command line: BOOT_IMAGE=gentoo ro root=803 video=uvesafb:1680x1050-32,mtrr:2,ywrap
[    0.000000] mtrr_cleanup: can not find optimal value
[    0.000000] please specify mtrr_gran_size/mtrr_chunk_size
[    0.000000] Kernel command line: BOOT_IMAGE=gentoo ro root=803 video=uvesafb:1680x1050-32,mtrr:2,ywrap
[    0.697689] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    0.972810] mtrr: type mismatch for e0000000,8000000 old: write-back new: write-combining
```

mttr_gran_size と mtrr_chunk_size を追加した。  
適当なサイズがわからない...。


```
 # dmesg | grep mtrr
[    0.000000] Command line: BOOT_IMAGE=gentoo ro root=803 video=uvesafb:1680x1050-32,mtrr:2,ywrap enable_mtrr_cleanup mtrr_spare_reg_nr=1 mtrr_gran_size=32M mtrr_chunk_size=128M
[    0.000000] update e820 for mtrr
[    0.000000] Kernel command line: BOOT_IMAGE=gentoo ro root=803 video=uvesafb:1680x1050-32,mtrr:2,ywrap enable_mtrr_cleanup mtrr_spare_reg_nr=1 mtrr_gran_size=32M mtrr_chunk_size=128M
[    0.972161] mtrr: no more MTRRs available
```

## Ref.

* [MTRR](http://en.gentoo-wiki.com/wiki/MTRR)
* [Gentoo Linux nVidiaガイド](http://www.gentoo.org/doc/ja/nvidia-guide.xml?style=printable)
* [10. ブートローダを設定する](http://www.gentoo.org/doc/ja/handbook/handbook-amd64.xml?style=printable&part=1&chap=10)
* [MTRR機能を使ってXの描画を高速化させたい](http://www.itmedia.co.jp/help/tips/linux/l0173.html)
