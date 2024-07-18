---
title: exposed
created: 2023-12-02T14:11:33
modified: 2024-07-16T23:41:06
tags:
  - services
  - exposed
aliases:
  - Services Exposed to the Internet - `wizzdom`
author:
  - wizzdom
id: exposed
---

# Services Exposed to the Internet - `wizzdom`

Firstly, it's important to mention that Redbrick is currently split in 2 parts:

- Redbrick 2.0 *a.k.a. "old redbrick"* (on `136.206.15.0/24`)
- New Redbrick which includes [Aperture](../hardware/aperture/index.md) (on `136.206.16.0/24`)

![](../network-divorce.png)

## Old Redbrick

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
                - other websites are mentioned in the [nix-configs repo](https://github.com/redbrick/nix-configs/blob/master/services/httpd/vhosts.nix)
			- legacy websites (pretty much anything that isn't dockerized)
			- [thecollegeview.ie](https://thecollegeview.ie)
			- [thelookonline.dcu.ie](https://thelookonline.dcu.ie)
		- email (`postfix` and `dovecot`)
		- mailing [lists](https://lists.redbrick.dcu.ie) (`mailman`)
		- `*.redbrick.dcu.ie` also points here
- [paphos](../hardware/paphos.md) - `136.206.15.53`
	- **OS**: Ubuntu 14.04 LTS
	- **Services**:
		- DNS ([bind](bind.md))

## New Redbrick

- [**azazel**](../hardware/azazel.md) - `136.206.16.24`
	- **OS**: Debian 12 `bookworm`
	- **Services**:
		- primary ssh login box for users (see [Logging in](servers.md#Logging%20in))
		- jump-box for admins
- [**pygmalion**](../hardware/pygmalion.md) - `136.206.16.25`
	- **OS**: Debian 12 `bookworm`
	- **Services**:
		- secondary ssh login box for users (see [Logging in](servers.md#Logging%20in))
		- jump-box for admins

### [Aperture](../hardware/aperture/index.md)

In aperture, things are done a little differently than on the other network. Instead of having a single host per service, aperture is configured to allow services to be allocated dynamically across all 3 servers using [nomad](nomad.md), [consul](consul.md) and [traefik](traefik.md).

- [glados](../hardware/aperture/glados.md) - `136.206.16.4`
- [wheatley](../hardware/aperture/wheatley.md) - `136.206.16.5`
- [chell](../hardware/aperture/chell.md) - `136.206.16.6`
- all 3 boxes are identical
- **OS**: Debian 11 `bullseye`
- **Services**:
	- simple `nginx` containers with the mascot of each server in aperture:
		- [glados](https://glados.redbrick.dcu.ie)
		- [wheatley](https://wheatley.redbrick.dcu.ie)
		- [chell](https://chell.redbrick.dcu.ie)
	- the [amikon.me](https://amikon.me) website for DCU AMS in an `nginx` container
	- [timetable.redbrick.dcu.ie](https://timetable.redbrick.dcu.ie) a timetable that actually works, 10x better than the [official DCU timetable](https://mytimetable.dcu.ie)
	- Redbrick main site [redbrick.dcu.ie](https://redbrick.dcu.ie)
	- [HedgeDoc](md.md) at: [md.redbrick.dcu.ie](https://md.redbrick.dcu.ie)
	- [Admin API](api.md) at: [api.redbrick.dcu.ie](https://api.redbrick.dcu.ie)
	- [Wetty](servers.md#Logging%20in%20to%20Wetty) at: [wetty.redbrick.dcu.ie](https://wetty.redbrick.dcu.ie)
	- DCU Solar Racing Website [solarracing.ie](https://solarracing.ie)
	- [Redbrick Password Vault](vault.md) (Vaultwarden) at: [vault.redbrick.dcu.ie](https://vault.redbrick.dcu.ie)
	- [URL Shortener](shlink.md)
	- [Plausible Analytics](plausible.md) at [plausible.redbrick.dcu.ie](https://plausible.redbrick.dcu.ie)
- **Notes**:
	- All web traffic is routed through [traefik](traefik.md) on the [bastion VM](./bastion-vm.md)
	- All new services will be deployed here
	- Most services here are deployed as docker containers but there's no reason you couldn't use any of the other [nomad drivers](https://developer.hashicorp.com/nomad/docs/drivers)
	- For more information see redbrick's [Nomad repo](https://github.com/redbrick/nomad)
