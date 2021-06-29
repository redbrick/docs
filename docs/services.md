# Services

## Bind9 - `distro`, `ylmcc`

Bind9 is our DNS provider. Currently it runs on Paphos, but is being moved to Fred during the restructuring.

## Git

Redbrick uses [Gitea](https://gitea.io/en-US/) as an open source git host.

- [Gitea docs](https://docs.gitea.io/en-us/)
- [Gogs docs](https://gogs.io/docs), not really important, but Gitea is built on [Gogs](https://gogs.io/)
- [Link to Redbrick deployment](https://git.redbrick.dcu.ie/)

### Deployment

Gitea and its database are deployed to Hardcase which runs NixOS

- The actual repositories are stored in `/zroot/git` and most other data is stored in `/var/lib/gitea`
- The `SECRET_KEY` and `INTERNAL_TOKEN_URI` are stored in `/var/secrets`. They are not automatically created and must be copied when setting up new hosts. Permissions on the `gitea_token.secret` must be 740 and owned by `git:gitea`
- Make sure that the `gitea_token.secret` does NOT have a newline character in it.

### Other Notes

The Giteadmin credentials are in the passwordsafe.

### Operation

Gitea is very well documented in itself. Here's a couple of special commands when deploying/migrating Gitea to a different host

```bash
# Regenerate hooks which fixes push errors
/path/to/gitea admin regenerate hooks

# If you didn't copy the authorized_keys folder then regen that too
/path/to/gitea admin regenerate keys
```

## HackMD - `distro`

HackMD lives on Zeus as a docker container. It is accessible through [md.redbrick.dcu.ie](md.redbrick.dcu.ie).

HackMD is built locally and is based on [docker-hackmd](https://github.com/hackmdio/docker-hackmd)

Clone the repo and modify `.sequlize`, `Dockerfile` and `config.json` so anywhere it said `hackmdPostgres` it now says `hackmd_db_1.hackmd_default` assuming this is all done in the hackmd folder.

Hackmd auths against ldap and its configuration is controlled from docker-compose. See [docker-sevices repo](https://github.com/redbrickCmt/docker-compose-services) for configs.

See [hackmd github](https://github.com/hackmdio/hackmd/#environment-variables-will-overwrite-other-server-configs) for more info on configuration. The important points are disabling anonymus users and the ldap settings.

## IRC

### Redbrick InspIRCd

In 2016/2017 we began work to move to InspIRCd. This was due to the complications in ircd-hybrid and how old it was. These complications stopped new netsocs joining us so we all agreed to move irc. $ 4 years later after multiple attempts we had not migrated. Until TCD decided to shutdown their server breaking the network.

We run Inspircd v3 on Metharme. InspIRCd's docs can be found [here](https://docs.inspircd.org/) for configuration specifics.

IRC is available at `irc.redbrick.dcu.ie` on port `6697`. SSL is required for connection, we do not support non-SSL.

When connecting from a redbrick server a user will be automatically logged in. If connecting from an external server a user must pass their password on login.

For the purpose of external peering of other servers the port `7001` is expose as well. Similarly to clients we only support SSL on this port

For docs on connecting and using an IRC client please refer to the [wiki](https://wiki.redbrick.dcu.ie/index.php/IRC)

### Installation

InspIRCd is installed with Nix. There is no Nix package for InspIRCd so we compile a specific git tag from source. See [Nix package](https://github.com/redbrick/nix-configs/tree/master/packages/inspircd) for details on how it is compiled.

Given we only support SSL and require LDAP, we need to enable both at compile time.

### Configuration

InspIRCd's configuration is in Nix [here](https://github.com/redbrick/nix-configs/blob/master/services/ircd/inspircd/conf.nix). This config will be converted to xml on disc.

#### Important Configuration

*oper* is a list of admin users on the irc server. Their `OPER` password will need to be manually hashed with `hmac-sha256`, and placed in a secret on the server to be read in by inspircd.

*ldapwhitelist* is a list of cidr addresses that do no require authentication. The list consists of Redbrick public and private addresses as well as `oldsoc`.

*link* is a list of all servers we peer with including the anope services server that runs on the same box.

#### oldsoc.net

`oldsoc.net` is a server run by old TCD netsocers. All the users on it are the remaining TCD associates following the shutdown of TCD IRCd. This server is maintained by its own users and has explicit permission to join IRC without LDAP auth.

### Anope

Redbrick runs Anope services for the entire network. As with [inspircd we compile](https://github.com/redbrick/nix-configs/tree/master/packages/inspircd) from source. Refer to anopes [github docs](https://github.com/anope/anope/tree/2.0/docs) for configuration specifics.

Our current Anope is configured with standard mods of chanserv, nickserv and operserv. All config is in [here](https://github.com/redbrick/nix-configs/tree/master/services/ircd/anope/confs)

Anope stores all info in a custom db file on disk.

### Discord Bridge - `butlerx`

We run a [bridge](https://github.com/qaisjp/go-discord-irc) between the Redbrick Discord and irc. The configuration for this is [here](https://github.com/redbrick/nix-configs/tree/master/services/ircd/discord/conf.nix).

The bridge adds all users from discord with the suffix `_d2` and all irc users appear as them self but tagged as a bot in discord. Not all discord channels are on IRC, the config above contains a mapping of irc channels to discord channels id's. This needs to be manually updated to add more channels.

## Icecast - `mcmahon`

Icecast is a streaming server that we currently host on paphos

We stream DCUFm's Broadcasts to their apps via a stream presented on `dcufm.redbrick.dcu.ie:80`

They serve an audio stream (stream128.mp3) via butt on a desktop in their studio to `icecast2`.

Icecast requires root privilege to bind to Port 80; normally icecast2 runs as the `icecast2` user and binds to `8001`.

### Procedure

Change configuration.

`/etc/icecast2/icecast.xml`

```bash
<!-- Sources log in with username 'source' --> <-- This is the audio source.
<source-password>$password1</source-password> <-- This must be copied for the DCUFM buttrc.
<!-- Relays log in username 'relay' -->
<relay-password>$password2</relay-password>
<admin-user>admin</admin-user> <-- This is for the WebUI frontend
<admin-password>$password3</admin-password>

<hostname>dcufm.redbrick.dcu.ie</hostname>

<listen-socket>
<port>80</port>
<bind-address>136.206.15.101</bind-address> <-- i.p. addr for dcufm.redbrick.dcu.ie A Record.
```

After that you must configure the default behaviour for the icecast server to allow icecast2 to bind to port 80.

Set `USERID` & `GROUPID` in `/etc/defaults/icecast2` to `root`.

## NFS / Network File Storage
