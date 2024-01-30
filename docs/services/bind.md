# Bind9 - `distro`, `ylmcc`

Bind9 is our DNS provider. Currently it runs on [`paphos`](../hardware/paphos.md), but this may change in the near future.

## Configuration

The config files for bind are located in `/etc/bind/master/`. The most important file in this directory is the `db.Redbrick.dcu.ie` file.

> [!WARNING] Note
> You must never update this file without following the steps below first!

## Updating DNS

To update DNS:

1. Change directory to `/etc/bind/master`
2. Back up the `db.Redbrick.dcu.ie` file, usually to `db.Redbrick.dcu.ie.bak`
3. Run `rndc freeze redbrick.dcu.ie` - this stops changes to the file affecting DNS while you edit it
4. Edit `db.Redbrick.dcu.ie`
5. Before changing any DNS entry in the file, you **must** edit the serial number on 4. You can increment it by one if
you want, or follow the format: `YYYYMMDDrev` where rev is revision
6. Once you are happy with your file, you can check it with `named-checkzone redbrick.dcu.ie db.Redbrick.dcu.ie`
7. If this returns no errors, you are free to run `rndc thaw redbrick.dcu.ie`
8. Check the status of `bind9` by running `service bind9 status`

You can access more logs from `bind9` by checking `/var/log/named/default.log`.
