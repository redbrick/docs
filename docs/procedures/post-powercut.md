---
id: post-powercut
aliases:
  - Post-powercut Todo List
tags:
  - powercut
  - todo
created: 2023-12-05T01:36:11
modified: 2024-09-30T19:24:57
title: Post-powercut Todo List
---

# Post-powercut Todo List

A list of things that should be done/checked immediately after a power cut:

- Ensure the [`aperture`](../hardware/aperture/index.md) servers have the correct IP addresses:
	- `eno1` should have the internal IP address (`10.10.0.0/24`) - this should be reserved by DHCP on [`mordor`](../hardware/network/mordor.md)
	- `eno2` should have *no IP address*
	- `br0` should have the external IP address (`136.206.16.0/24`) - this should also be reserved by DHCP on [`mordor`](../hardware/network/mordor.md)
- If the [`bastion-vm`](../services/bastion-vm.md) fails to start, check:
	- `/storage` is mounted `rw` on each [`aperture`](../hardware/aperture/index.md) server
	- `br0` is present and configured on each [`aperture`](../hardware/aperture/index.md) server
	- `vm-resources.service.consul` is running and `http://vm-resources.service.consul:8000/bastion/bastion-vm-latest.qcow2` is accessible
	- if the `latest` symlink points to a corrupted image, `ln -sf` it to an earlier one
- All the [`nixos`](..//procedures/nixos.md) boxes rely on [`DNS`](..//services/bind.md) for [`LDAP`](../services/ldap.md) and [`NFS`](../services/nfs.md):
	- Make sure bind is running on [`paphos`](../hardware/paphos.md)
	- mount `/storage`
	- `systemctl restart` `httpd`, `php-fpm-rbusers-*` and `ldap`
- Apache on [`hardcase`](../hardware/nix/hardcase.md) sometimes tries to start before networking is finished starting. To fix it, disable/re-enable it a few times. This usually makes it turn on.
- Mailman on [`hardcase`](../hardware/nix/hardcase.md) has a lock file at `/var/lib/mailman/lock/master.lck`. If it doesn't shut down correctly, this lock file will block mailman from starting up. Remove it with:

```bash
rm /var/lib/mailman/lock/master.lck
```

- [`paphos`](../hardware/paphos.md) is old and sometimes its time will become out of sync. To make sure its time is accurate, run:

```bash
sudo service ntp restart
```

and ensure you have the correct time with `date`
