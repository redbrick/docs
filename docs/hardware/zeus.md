---
title: zeus
created: 2023-12-02T14:18:51
modified: 2024-03-13T04:49:14
tags:
  - hardware
  - zeus
  - details
  - docker
  - ubuntu
---

# Zeus

## Details

- **Type**: Dell PowerEdge R410
- **OS**: Ubuntu 18.04
- **CPU**: 2x Intel(R) Xeon (R) x5570 @ 2.93 GHz
- **RAM**: 32GB
- **Network**: 2x NetXtreme II BCM5716 Gigabit Ethernet

## Where to Find

- **Internal**:
	- `192.168.0.131`
- **External**:
	- `136.206.15.31`

## Services

- [Wetty](../services/servers.md#Logging%20in%20to%20Wetty) at: [wetty.redbrick.dcu.ie](https://wetty.redbrick.dcu.ie)
- [Admin API](../services/api.md) at: [api.redbrick.dcu.ie](https://api.redbrick.dcu.ie)
- brickbot2
- Secretary's email generator  at: [generator.redbrick.dcu.ie](https://generator.redbrick.dcu.ie)
- [CodiMD](../services/md.md) at: [md.redbrick.dcu.ie](https://md.redbrick.dcu.ie)
- all of this is routed through [traefik](../services/traefik.md) as a reverse proxy
