---
id: nfs
aliases:
  - NFS / Network File Storage
tags: []
created: 2021-06-29T04:44:29
modified: 2026-09-03T08:23:37
title: NFS
---

# NFS / Network File Storage

NFS is the protocol we use to share our storage drive over the network to all our servers. It is managed by TrueNAS on [mirage](../hardware/storage/mirage.md) with [anubis](../hardware/storage/anubis.md) as an active backup.

## Deployment

- NFS is deployed with TrueNAS on [mirage](../hardware/storage/mirage.md)
- The drives are setup like this:

| VDEV Type   | RAID Type  | Array Width | Drive Size |
| ----------- | ---------- | ----------- | ---------- |
| Data VDEVs  | 2 x RAIDZ2 | 6 wide      | 3.64 TiB   |
| Log VDEVs   | 1 x DISK   | 1 wide      | 931.51 GiB |
| Cache VDEVs | 2 x DISK   |             | 465.76 GiB |

- ZFS is configured with compression onand dedup off
- [Anubis](../hardware/storage/anubis.md) is an active backup of mirage. They are identical machines and are configured to sync with each other. All our services are configured to use [mirage](../hardware/storage/mirage.md). If mirage were to fail, you would need to manually switch all our servers over to using [anubis](../hardware/storage/anubis.md).
- The storage dataset is split into a number of different smaller datasets, which can each be individually mounted on servers so that you don't, for example, mount all of our service databases to the login boxes.

## Redbrick Special Notes

Storage quotas are managed by a python script that runs once every hour. It queries LDAP for user storageQuota fields then sends it off to the TrueNAS API which applies those quotas to the `webtree` and `home` datasets using the users `uidNumber`

## Troubleshooting

In the event where clients are unable to read from NFS, your priority should be restoring the NFS server, rather than unmounting NFS from clients. Usually it's a networking or permissions issue which can be resolved through the TrueNAS control panel.
