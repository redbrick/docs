---
id: bind
aliases:
  - Bind9 - `distro`, `ylmcc`, `wizzdom`
tags:
  - services
  - dns
author:
  - distro
  - ylmcc
  - wizzdom
created: 2021-06-29T04:44:29
modified: 2024-04-03T17:52:43
title: Bind (DNS)
---

# Bind9 - `distro`, `ylmcc`, `wizzdom`

`bind9` is our DNS provider. Currently it runs on [`paphos`](../hardware/paphos.md), but this **will** change in the near future.

## Configuration

The config files for bind are located in `/etc/bind/master/`. The most important files in this directory are:

- `db.Redbrick.dcu.ie`
- `db.Rb.dcu.ie`
- various other files for other [`socs`](socs.md) and members

> [!WARNING]
> You must never update this file without following the steps below first!

## Updating DNS

To update DNS:

1. Change directory to `/etc/bind/master`

```bash
cd /etc/bind/master
```

2. Back up the `db.Redbrick.dcu.ie` file, usually to `db.Redbrick.dcu.ie.bak`

```bash
cp db.Redbrick.dcu.ie{,.bak}
```

3. Stop changes to the file affecting DNS while you edit it

```bash
rndc freeze redbrick.dcu.ie
```

4. Edit `db.Redbrick.dcu.ie`
5. Before changing any DNS entry in the file, you ***must*** edit the serial number on 4. You can increment it by one if
you want, or follow the format: `YYYYMMDDrev` where `rev` is revision. For example:

```d title="db.Redbrick.dcu.ie"
2024033106 ; serial
```

6. Once you are happy with your file, you can check it with:

```bash
named-checkzone redbrick.dcu.ie db.Redbrick.dcu.ie
```

7. If this returns no errors, you are free to thaw the DNS freeze:

```bash
rndc thaw redbrick.dcu.ie
```

8. Check the status of `bind9`:

```bash
service bind9 status
```

9. You can access more logs from `bind9` by checking `/var/log/named/default.log`:

```bash
tail -n 20 /var/log/named/default.log
```

> [!NOTE]
> Once you have verified that everything is working properly. Add your changes and commit them to git.
