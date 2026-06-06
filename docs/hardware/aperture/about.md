---
id: about
aliases:
  - About Aperture
tags:
  - aperture
  - hardware
created: 2022-05-16T01:44:40
modified: 2026-06-06T04:49:14
title: About Aperture
---

# About Aperture

Aperture is Redbrick's fleet of hardware that was installed in May 2022 by `distro`, `pints`, `skins`, `cawnj`, `ymacomp` and `arkues`.

It consists of:

- 3x Dell R6515 - [`glados`](glados.md), [`wheatley`](wheatley.md), [`chell`](chell.md)

- 2x Ubiquiti USW Pro - `rivendell`, `isengard`
- 1x Ubiquiti UDM Pro - `mordor`

## Servers

The three servers are named [`glados`](glados.md) , [`wheatley`](wheatley.md) and [`chell`](chell.md).

## Networks

The firewall is called [`mordor`](../network/mordor.md), and the two 24-port switches are called [`rivendell`](../network/rivendell.md) and [`isengard`](../network/isengard.md).

> [!NOTE] Note!
> **Blue** cables are used for **production network**.

## KVM

`nexus` is the name of the KVM switch. It's internal IP address is `10.10.0.100`.

> [!ERROR] Note!
> **Red** cables are used for **KVM network**.


## IDRAC

The new servers are all equipped with IDRACs. These still need to be configured.

> [!WARNING] Note!
> **Yellow** cables are used for **iDRAC network**.

## [Images (click me)](images.md)

## Switching from the Old Network to the New

We have two address ranges that come in on a single redundant link, so we're exchanging that redundant link for two separate links, each taking responsibility for an address range (`136.26.15.0/24` and `136.206.16.0/24`). So we're surrendering redundancy to gain uptime/connectivity during the switchover only. Once the new servers are production ready, we can recombine the link to regain the redundancy.
