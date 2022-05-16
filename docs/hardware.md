# Hardware

Here is a list of current hardware in Redbrick's suite of servers, switches and other bits

## Servers

### Daedalus + Icarus

These 2 PowerEdge servers are twins and thus share documentation.a

#### Details

- Type: Dell PowerEdge 2950
- Operating System: NixOS
- CPU: 2x Intel Xeon L5335 @ 2.00GHz
- RAM: 32GB (Daedalus), 16GB (Icarus)
- Storage: Dell Perc 6/i Integrated RAID controller
- Disks:
    - 2 x 73GB SAS disks in RAID 1 (hardware)
    - 3 x 600GB SAS disks in passthrough (3x RAID 0)
- Drives: Internal SATA DVD±RW
- Network: 2x Onboard Ethernet, 802.3ad bonding
- iDRAC NIC: Shared on port 1
- Daedalus' IP is 0.50, Icarus' is 0.150
- Their iDRAC IPs are 1.50 and 1.150 respectively

#### Services

- LDAP
- NFS, (a.k.a /storage) from Icarus
- GlusterFS, eventually, or some other distributed storage to replace NFS

## Switches

## UPS

## Other
