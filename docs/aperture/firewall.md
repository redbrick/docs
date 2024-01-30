# Firewall

<!-- Access through 10.10.0.1 -->

## Setup

The firewall is set up using the personal setup type, using the elected-admins@redbrick.dcu.ie account (stored in `pwsafe`

2FA is stored on the same device as the Github 2FA code.

### Automatic Updates

The UDM Pro is not set up for automatic updates for reliability reasons.

### Network Speeds

We have a 10 GB/s link to DCU's core.

### Users

The current elected admins should all have access to the rbadmin account on the firewall. Rootholders **should not** have access to the firewall unless they are explicitly granted access.

The owner account of the unifi equipment is `rbadmins` (email: elected-admins@redbrick.dcu.ie) with the password stored in `pwsafe` under `unifi`.

There is a "super admin" account that can be used for **local access only**, details are stored in `pwsafe` under `udmpro-super-admin`.

### Updates

The UDM Pro should be kept up to date at all times using the web interface. Please ensure there are no breaking changes before updating.


> [!ERROR] AUTO UPDATES SHOULD NEVER BE ENABLED!
> This is to prevent a bad update from breaking the UDM Pro and thus the entire network. 
> If you are confident that Unifi can produce stable updates, you may turn it on, however please let the next admins know that you have done this (and update these docs with a comment!).

### Advanced Settings

SSH is enabled to allow for rollbacks in case of a bad update *(I warned you!)*.

Remote access is disabled as it should not be needed, the admin [`VPN`](./vpn.md) should provide enough access for you. If it is enabled in future, please update these docs with your reasons.

### Backups

Backups are configured to run every week at 1am on a Sunday. 20 backups are stored at a time, therefore storing 20 weeks of configuration. This should be plenty of time to recover from a bad configuration change.

## External Addresses

`Mordor` is NATted when it accesses the Internet. This is because the link address between it and DCU is on a private address.
This NATting is used *only* for the UDM pro device itself, not for the `136.206.16.0/24` network, and is to allow the UDM box itself to access the Internet.

The `136.206.16.0/24` network is routed down to the UDM pro box, within the DCU network. Essentially there is a route in DCU's network that says "if you want to access `136.206.16.0/24` go to `mordor`".
