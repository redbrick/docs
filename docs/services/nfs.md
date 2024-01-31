# NFS / Network File Storage

NFS is used to serve the notorious `/storage` directory on Icarus to all of Redbrick's machines, which in turn serves `/home`, `/webtree` and some other critical folders.

## Deployment

- NFS is deployed with Nix on [Icarus](../hardware/nix/icarus.md)
- It is backed onto the PowerVault MD1200 with all its disk passed through single-drive RAID 0s toallow for setup of ZFS:
    - 1 mirror of 2x 500GB drives
    - 1 mirror of 2x 750GB drives
    - 1 mirror of 2x 1TB drives
    - Stripe across all the mirrors for 2TB of usable storage
    - 1 hot spare 750GB drive
- ZFS is configured with compression onand dedup off
- The ZFS pool is called `zbackup`

## Redbrick Special Notes

On each machine where `/storage` is where NFS is mounted, but `/home` and `/webtree` are symlinks into there.

There are 2 scripts used to control quotas, detailed below.

NFS is backed up to Albus via [ZnapZend](znapzend.md).

## `zfsquota` And `zfsquotaquery`

These are two bash scripts that run as systemd services on Icarus to manage quotas. This is achieved through getting and setting the `userquota` and `userused` properties of the ZFS dataset.

### Zfsquota

ZFSQuota will read the `quota` field from LDAP and sync this with the userquota value on the dataset. It is not event driven - it runs on a timer every 3 hours and syncs all LDAP quotas with ZFS. It can be kicked off manually, which is described below. Users with no quota in LDAP will have no quota in `/storage`, and users who have their quota removed will persist on ZFS.

Changing user names has no impact on this since it is synced with `uidNumber`.

### Zfsquotaquery

ZFSQuotaQuery returns the quota and used space of a particular user. This is used to then inform `rbquota` which provides the data for the MOTD used space report. Both of these scripts are defined and deployed in the Nix config repo. It runs on port 1995/tcp.

## Operation

In general, there isn't too much to do with NFS. Below are some commands of interest for checking its status.

```bash
# On the NFS server, list the exported filesystems
showmount -e

# Get the real space usage + fragmentation percent from ZFS
zpool list zbackup

# Check a user's quota
zpool get userquota@m1cr0man zbackup
zpool get userused@m1cr0man zbackup

# Delete a quota from ZFS (useful if a user is deleted)
zpool set userquota@123456=none zbackup

# Get all user quota usage, and sort it by usage
zfs userspace -o used,name zbackup | sort -h | tee used_space.txt

# Resync quotas (this command will not return until it is finished)
systemctl start zfsquota

# Check the status of zfsquotaquery
systemctl status zfsquotaquery
```

## Troubleshooting

In the event where clients are unable to read from NFS, your priority should be restoring the NFS server, rather than

unmounting NFS from clients. This is because NFS is mounted in `hard` mode everywhere, meaning that it will block on IO until a request can be fulfilled.

### Check The Server

```bash
# Check the ZFS volume is readable and writable
ls -l /zbackup/home
touch /zbackup/testfile

# Check that rpc.mountd, rpc.statd and rpcbind are running and lisening
ss -anlp | grep rpc

# Check the above services for errors (don't worry about blkmap)
systemctl status nfs-{server,idmapd,mountd}
journalctl -fu nfs-server -u nfs-idmapd -u nfs-mountd
```

### Check The Client

```bash
# Check for connection to NFS
ss -atp | grep nfs

# Check the fstab entry
grep storage /etc/fstab

# Check if the NFS server port can be reached
telnet 192.168.0.150 2049
# Entering gibberish should cause the connection to close

# Remount read-only
mount -o remount,ro /storage

# Not much left you can do but remount entirely or reboot
```

### Rolling Back or Restoring a Backup

See [znapzend](znapzend.md)
