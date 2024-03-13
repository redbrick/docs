# Cheatsheet

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

- Create `root` ssh key for [NixOS](../procedures/nixos.md) Machines
Following creation of the key, add to the whitelist in *[nix configs](https://github.com/redbrick/nix-configs/blob/master/services/ssh.nix)*.

```bash
ssh-keygen -t ed25519 # Generate key
cat ~/.ssh/id_ed25519.pub # Verify it's been created
ssh-copy-id -i ~/.ssh/id_ed25519 user@redbrick.dcu.ie # Copy to local account's ssh dir
ssh -i ~/.ssh/mykey user@redbrick.dcu.ie # Verify that this key was copied
```

### Access Passwordsafe (pwsafe)

Location of master password vault.

> [!NOTE] Note:
> `getpw` will prompt you for the Master root password.

```bash
ssh localroot@halfpint
sudo -i # to log in as root with local user password
pwsafe # to list passwords
getpw <name_of_pass> # Grab password by name key | getpw pygmalion
```

___

## SSH to Root on a [NixOS](../procedures/nixos.md) Machine

- From the account you generated your ssh key on (in nix configs) type:

```bash
ssh root@hardcase.internal
```

___

## NixOS

- Install a temporary program

```bash
nix-shell -p [space seperated package names]
```

- Run brickbot2 (running on Metharme)

```bash
cd brickbot2
nix-shell
source venv/bin/activate
python3 main.py config.toml
```

Brickbot runs in `tmux a -t 0` and can be restarted by pressing ctrl+c and running the above python command

## Minecraft Servers

The Redbrick Minecraft server's are dockerized applications running on [`zeus`](../hardware/zeus.md) on a server-per-container basis, using the tools on this GitHub Repo: https://github.com/itzg/docker-minecraft-server#interacting-with-the-server

Repo is very well documented so have a look at the README but here's the basics:

**NOTE:** *Local Root accounts must be added to the docker group before they can run the docker commands.* `usermod -a -G docker ACCOUNT_NAME`

You can `docker ps | grep minec` to find the docker containers running the servers.

The docker compose files are located in `/etc/docker-compose/services`, Unmodded Vanilla compose for example is in `/etc/docker-compose/services/minecraft_unmodded/`

To see the configuration for the container you can do `docker inspect CONTAINER_NAME_OR_ID`

- Interacting with the Server Console
    - https://github.com/itzg/docker-minecraft-server#interacting-with-the-server
