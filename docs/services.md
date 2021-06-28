# Services

## Bind9

Bind9 is our DNS provider. Currently it runs on Paphos, but is being moved to Fred during the restructuring.00GHz

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

## HackMD

HackMD lives on Zeus as a docker container. It is accessible through [md.redbrick.dcu.ie](md.redbrick.dcu.ie)

HackMD is built locally and is based on [docker-hackmd](https://github.com/hackmdio/docker-hackmd)

Clone the repo and modify `.sequlize`, `Dockerfile` and `config.json` so anywhere it said `hackmdPostgres` it now says `hackmd_db_1.hackmd_default` assuming this is all done in the hackmd folder.

Hackmd auths against ldap and its configuration is controlled from docker-compose. See [docker-sevices repo](https://github.com/redbrickCmt/docker-compose-services) for configs.

See [hackmd github](https://github.com/hackmdio/hackmd/#environment-variables-will-overwrite-other-server-configs) for more info on configuration. The important points are disabling anonymus users and the ldap settings.
