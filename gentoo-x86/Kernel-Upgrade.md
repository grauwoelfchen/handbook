
I upgrade kernel from 3.0.6 to 3.2.0-r1.

* check http://packages.gentoo.org/package/sys-kernel/gentoo-sources
* `echo "sys-kernel/gentoo-sources ~x86" >> /etc/portage/package.accept_keywords`
* add "symlink" to USE
* `emerge -S gentoo-sources`
* `emerge -u gentoo-sources`

```
make menuconfig
make && make modules_install
cp arch/x86/boot/bzImage /boot/kernel-3.2.0-r1
```

* edit /boot/grub/grub.conf

```
emerge module-rebuild
module-rebuild populate
module-rebuild rebuild
```

