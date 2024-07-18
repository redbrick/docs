---
title: icarus
created: 2021-06-28T23:17:10
modified: 2024-03-13T04:49:14
tags:
  - nixos
  - hardware
  - icarus
  - daedalus
  - details
---

# Icarus

Daedalus and Icarus ~~are~~ were twins ~~and thus share documentation.~~

However, Daedalus is now ***Dead***alus and Icarus lives on *for now* albeit a little sick.

## Details

- **Type**: Dell PowerEdge 2950
- **OS**: NixOS
- **CPU**: 2x Intel Xeon L5335 @ 2.00GHz
- **RAM**: 32GB (Daedalus), 16GB (Icarus)
- **Storage**: Dell Perc 6/i Integrated RAID controller
- **Disks**:
    - 2 x 73GB SAS disks in RAID 1 (hardware)
    - 3 x 600GB SAS disks in passthrough (3x RAID 0)
- **Drives**: Internal SATA DVD±RW
- **Network**: 2x Onboard Ethernet, 802.3ad bonding
- iDRAC NIC: Shared on port 1

## Where to Find

- **Internal**:
	- `192.168.0.150`

## Services

- LDAP
- [NFS](../../services/nfs.md), (a.k.a `/storage`)
- GlusterFS, eventually, or some other distributed storage to replace NFS
