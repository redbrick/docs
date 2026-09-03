---
id: cheatsheet
aliases:
  - Cheatsheet
tags: []
created: 2021-06-28T23:17:10
modified: 2026-09-03T06:05:10
title: Cheatsheet
---

# Cheatsheet

While we primarily use the API for LDAP operations, these commands may come in useful. These commands were for a previous version of our LDAP schema and may not work as-is.

## LDAP

- Query a user

```sh
ldapsearch -x uid="USERNAME_HERE"
```

- Query user as root for more detailed info

```sh
ldapsearch -D "cn=root,ou=services,o=redbrick" -y /etc/ldap.secret uid=user
```

- Find all users emails created by `USERNAME`

```sh
ldapsearch -x createdby="user" uid | awk '/uid:/ {print $2"@redbrick.dcu.ie"}'
```

- Check if something is backed up on NFS (`/storage/path/to/file`)

All useful LDAP scripts (*edit user quota, reset user password, renew user accounts, etc*) are located in the home directory of `root` on Azazel.

*Log in as `root` on a server with local accounts:*

```bash
ssh localaccount@redbrick.dcu.ie
sudo -i # (same password as localaccount account)
```

___

## Authentication/Passwords

### Onboarding New Admins

New admins should have a local account created on each box with an ssh key loaded onto them.
They should also be given a config file to access the [admin VPN](procedures/vpn) on [mordor](hardware/network/mordor)
## Minecraft Servers

The Redbrick Minecraft server's are dockerized applications running on [Aperture](hardware/aperture/index) on a server-per-container basis, using the tools on this [GitHub Repo](https://github.com/itzg/docker-minecraft-server): .

Repo is very well documented so have a look at the [docs](https://docker-minecraft-server.readthedocs.io/en/latest/) but here's the basics:

The configuration for these minecraft servers is almost entirely managed through environment variables. The exception to this is individual configs for mods or plugins that are installed on the server. To edit those you need to modify the config files directly.

We use [Gate](services/gate) as our minecraft proxy. This lets us host multiple minecraft servers with just one exposed port.

[Gate](services/gate) is configured to automatically work for any nomad job that has the prefix `minecraft-` in it's name.

To execute commands on one of our minecraft servers you need to go onto [nomad](services/nomad) and exec into one of the allocations. Once you have a shell open, you can run `rcon-cli` and you will be able to execute commands on the serverl.