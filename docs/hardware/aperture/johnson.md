---
title: johnson
created: 2023-12-06T01:22:03
modified: 2024-03-13T04:49:14
tags:
  - aperture
  - hardware
  - johnson
  - details
---

# Johnson

## Details

Formerly `albus` (in a different life)

- **Type**: Dell PowerEdge R515
- **OS**: NixOS
- **CPU**: 2 x Opteron 4334 6 core @ 3.2GHz
- **RAM**: 32GB
- **Storage**: LSI MegaRAID SAS 2108 RAID controller
- **Disks**: 2 x 300gb SAS for boot, 8x 1tb SATA ZFS
- **Drives**: Internal SATA DVD±RW
- **Network**: 4x Onboard Ethernet, 802.3ad bonding
- **iDRAC NIC**: Shared on port 1

Part of [aperture](index.md)

## Where to Find

- **Internal**:
	- `10.10.0.7`
- 2nd NIC is currently unused, would be a good idea to make a bond for more throughput and redundancy on the same ip

## Services

- `NFS` for [aperture](index.md)

![](../../res/johnson.png)
