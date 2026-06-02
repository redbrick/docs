---
id: index
aliases:
  - Redbrick Network Architecture
tags: []
title: Redbrick Network Architecture
---

# Redbrick Network Architecture

## VLANs

Redbrick has a number of VLANs in use, which are used to separate different types of traffic and to apply different rules to different types of devices. The VLANs in use are:

- **VLAN 0** (Internal): Used for legacy reasons and for management.
- **VLAN 10** (Internal Prod): Used for production servers that need to be accessible from the rest of the network.
- **VLAN 16** (External Prod): Used for production servers that need to be accessible from the internet.
- **VLAN 20** (Login): Used for login boxes and other devices that need to be accessible from the rest of the network.
- **VLAN 30** (Storage): Used for storage servers to be able to communicate with the rest of the network.
- **VLAN 40** (Management): Used for management of the servers by the sysadmins.
- **VLAN 99**: *SCP-CLASSIFIED* - Access Denied. Danger: Unstable Network.