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

Part of [aperture](../../aperture/index.md)

## Where to find
- **Internal**:
	- `10.10.0.7`
- 2nd NIC is currently unused, would be a good idea to make a bond for more throughput and redundancy on the same ip
## Services
- `NFS` for [aperture](../../aperture/index.md)


![](../../assets/johnson.png)