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

## Servers

The three servers are named [`glados`](glados.md), [`wheatley`](wheatley.md) and [`chell`](chell.md).

## Networks

The firewall is called [`mordor`](../network/mordor.md), and the two 24-port switches are called [`rivendell`](../network/rivendell.md) and [`isengard`](../network/isengard.md).

> [!NOTE] Note!
> **Blue** cables are used for **production network**.

## KVM

`nexus` is the name of the KVM switch. It's internal IP address is `10.10.0.100`. This is used to directly access the machines from the server room.

> [!ERROR] Note!
> **Red** cables are used for **KVM network**.


## IDRAC

The new servers are all equipped with IDRACs. These are configured for access through the vpn. The ips assigned for these are a bit all over the place
so you need to find it on mordor.

> [!WARNING] Note!
> **Yellow** cables are used for **iDRAC network**.

## [Images (click me)](images.md)
