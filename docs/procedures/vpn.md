---
id: vpn
aliases:
  - Admin VPN
tags: []
created: 2022-09-05T04:00:22
modified: 2024-03-01T21:17:25
title: Admin VPN
---

# Admin VPN

The admin VPN is set up to allow admins to access the network from outside of DCU, giving them an IP address on the internal network for troubleshooting, testing and integrating.

If you just want to create a new client configuration, go here: [adding a new client](#adding-a-new-client)

## Setup

Installed OpenVPN using [this script](https://github.com/Nyr/openvpn-install) on [`glados`](../hardware/aperture/glados.md).

## Adding a New Client

To add a new client, run the following command (as root) on Glados:

```bash
bash /root/ovpn/openvpn-install.sh
```

You will be prompted to add a new client, enter a name for the client and then the script will generate a new client.

It will be saved in `/root/[client name].ovpn`.

## Revoking a Client

To revoke a client, run the following command (as root) on Glados:

```bash
bash /root/ovpn/openvpn-install.sh
```

You will be prompted to revoke a client, enter the name of the client you want to revoke.

## Connecting to the VPN

To connect to the VPN, you will need to download the client configuration file from [glados](../hardware/aperture/glados.md) and then import it into your OpenVPN client.
