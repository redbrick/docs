---
title: Services Exposed to the Internet
author:
  - wizzdom
tags:
  - services
  - exposed
---

# Services Exposed to the Internet - `wizzdom`

Firstly, it's important to mention that Redbrick is currently split in 2 parts:

- Redbrick 2.0 *a.k.a. "old redbrick"* (on `136.206.15.0/24`)
- [Aperture](../hardware/aperture/index.md) *a.k.a. "new redbrick"* (on `136.206.16.0/24`)

## Old Redbrick

- [**azazel**](../hardware/azazel.md) - `136.206.15.24`
	- **OS**: Debian 10
	- **Services**:
		- primary ssh login box for users (see [Logging in](servers.md#Logging%20in))
		- jump-box for admins
- [**pygmalion**](../hardware/pygmalion.md) - `136.206.15.25`
	- **OS**: Ubuntu 18.04 LTS
	- **Services**:
		- secondary ssh login box for users (see [Logging in](servers.md#Logging%20in))
		- jump-box for admins
- [**motherlode**](../hardware/nix/motherlode.md) - `136.206.15.250`
	- **OS**: NixOS 22.05
	- **Services**:
		- VM for [dcuclubsandsocs.ie](https://dcuclubsandsocs.ie)
- [**hardcase**](../hardware/nix/hardcase.md) - `136.206.15.3`
	- **OS**: NixOS 22.05
	- **Services**:
		- `apache httpd`:
			- websites from the webtree (including, but not limited to):
				- all user's websites `<user>.redbrick.dcu.ie`
				- [redbrick.dcu.ie](https://redbrick.dcu.ie)
                - other websites are mentioned in the [nix-configs repo](https://github.com/redbrick/nix-configs/blob/master/services/httpd/vhosts.nix)
			- legacy websites (pretty much anything that isn't dockerized)
		- email (`postfix` and `dovecot`)
		- mailing [lists](https://lists.redbrick.dcu.ie) (`mailman`)
		- `*.redbrick.dcu.ie` also points here
- [**zeus**](../hardware/zeus.md) - `136.206.15.31`
	- **OS**: Ubuntu 18.04 LTS
	- **Note**: this is a docker host, everything on here is in a container
	- **Services**:
		- [Wetty](servers.md#Logging%20in%20to%20Wetty) at: [wetty.redbrick.dcu.ie](https://wetty.redbrick.dcu.ie)
		- [Admin API](api.md) at: [api.redbrick.dcu.ie](https://api.redbrick.dcu.ie)
		- Secretary's email generator  at: [generator.redbrick.dcu.ie](https://generator.redbrick.dcu.ie)
		- [CodiMD](md.md) at: [md.redbrick.dcu.ie](https://md.redbrick.dcu.ie)
		- all of this is routed through [traefik](traefik.md) as a reverse proxy
- [paphos](../hardware/paphos.md) - `136.206.15.53`
	- **OS**: Ubuntu 14.04 LTS
	- **Services**:
		- DNS ([bind](bind.md))

## [Aperture](../hardware/aperture/index.md)

In aperture, things are done a little differently than on the other network. Instead of having  a single host per service, aperture is configured to allow services to be allocated dynamically across all 3 servers using [nomad](nomad.md), [consul](consul.md) and [traefik](traefik.md).

- [glados](../hardware/aperture/glados.md) - `136.206.16.4`
- [wheatley](../hardware/aperture/wheatley.md) - `136.206.16.5`
- [chell](../hardware/aperture/chell.md) - `136.206.16.6`
- all 3 boxes are identical
- **OS**: Debian 11
- **Services**:
	- simple `nginx` containers with the mascot of each server in aperture:
		- [glados](https://glados.redbrick.dcu.ie)
		- [wheatley](https://wheatley.redbrick.dcu.ie)
		- [chell](https://chell.redbrick.dcu.ie)
	- the [amikon.me](https://amikon.me) website for DCU AMS in an `nginx` container
	- [timetable.redbrick.dcu.ie](https://timetable.redbrick.dcu.ie) a timetable that actually works, 10x better than the [official DCU timetable](https://mytimetable.dcu.ie)
- **Notes**:
	- all web traffic is routed through [traefik](traefik.md)
	- all new services will be deployed here
	- Most services here are deployed as docker containers but there's no reason you couldn't use any of the other [nomad drivers](https://developer.hashicorp.com/nomad/docs/drivers)
	- For more information see redbrick's [Nomad repo](https://github.com/redbrick/nomad)
