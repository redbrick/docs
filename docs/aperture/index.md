# Aperture

Aperture is Redbrick's fleet of hardware that was installed in May 2022 by `distro`, `pints`, `skins` and `cawnj`. It
consists of:

- 3x Dell R6515

    | CPU | RAM | Storage |
    | ---- | ---- | ------- |
    | AMD 7302P 3GHz, 16C/32T, 128M, 155W, 3200 | 2x 16GB RDIMM, 3200MT/s Dual Rank | 4x 2TB SATA HDDs (hardware RAID) |

- 2x Ubiquiti USW Pro
- 1x Ubiquiti UDM Pro

## Servers

The three servers are named `glados`, `wheatley` and `chell`.

## Networks

The firewall is called [`mordor`](firewall.md), and the two 24-port switches are called [`rivendell` and `isengard`](switches.md).

## Networking

The IP address range for the `aperture` subnet is 10.10.0.x, with 10.10.x.x being used for user VMs.

`mordor`'s IP address is 10.10.0.1, `rivendell`'s is 10.10.0.2, and `isengard`'s is 10.10.0.3.

`glados`'s IP address is 10.10.0.4, `wheatey`'s is 10.10.0.5, and `chell`'s is 10.10.0.6.

!!! note
    Blue cables are used for production network.

## KVM

`nexus` is the name of the KVM switch.

`glados` is connected on port 1, `wheatley` on port 2, and `chell` on port 3.

!!! note
    Yellow cables are used for KVM network.

## [Images (click me)](images.md)
