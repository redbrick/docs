---
id: vpn
aliases:
  - Admin VPN
tags: []
created: 2022-09-05T04:00:22
modified: 2026-09-03T21:17:25
title: Admin VPN
---
# Admin VPN

The admin VPN is set up to allow admins to access the network from outside of DCU, giving them an IP address on the internal network for troubleshooting, testing and integrating.

If you just want to create a new client configuration, go here: [adding a new client](#adding-a-new-client)

## Setup

We use a `WireGuard` VPN managed by [mordor](hardware/network/mordor). 
## Adding a New Client

To add a new client simply select the Aperture VPN and click add client on the [mordor](hardware/network/mordor) webui.

## Revoking a Client

To revoke a client just select it and click remove.

## Connecting to the VPN

To connect to the VPN, you will need to download the client configuration file or scan the qr code from [mordor](hardware/network/mordor) and load it onto `WireGuard`.

If you use `NetworkManager` on your machine and have `WireGuard` installed you can import the client file to `NetworkManager` with:

```bash
nmcli connection import type wireguard file /path/to/file
```

It can then be toggled on and off with `nmtui` or your desktop environments network configuration screen.