# Bind

## Prepare

### bind and named

```
$ sudo ln -sf /etc/bind /etc/named
$ sudo ln -sf /var/bind /var/named
$ sudo mkdir /var/bind/conf
$ sudo mkdir /var/named/reverse
$ sudo mkdir /var/named/personal
$ sudo chown -R named: /var/bind
$ sudo mkdir /var/log/bind
$ sudo ln -sf /var/log/bind /etc/named
$ sudo chown -R named: /var/log/bind
$ cd /etc/bind
$ sudo cp named.conf named.conf.orig
```

## rndc.conf

```
# /usr/sbin/rndc-confgen -b 512 -r /dev/urandom -k samplekey > /etc/rndc.conf
$ sudo chown named:named /etc/rndc.conf
$ sudo chmod 644 /etc/rndc.conf
$ sudo usermod -G named,root named
```

## named.conf

```

$ ls -la /etc/named/
named.conf
named.cache #=> root.cache (or /var/named/root.cache)
hint.check  #=> sh
zones/      #=> forward/reverse zones files
```

## Notes

* `emerge -av bind-tools`
* `dig @127.0.0.1 example.org`


## Ref.

* [](http://en.gentoo-wiki.com/wiki/BIND)
* [](http://en.gentoo-wiki.com/wiki/HOWTO_Setup_a_DNS_Server_with_BIND)
* [](http://gentoovps.net/installing-dns-server/)
