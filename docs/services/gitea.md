# Gitea

Redbrick uses [Gitea](https://gitea.io/en-US/) as an open source git host.

- [Gitea docs](https://docs.gitea.io/en-us/)
- [Gogs docs](https://gogs.io/docs), not really important, but Gitea is built on [Gogs](https://gogs.io/)
- [Link to Redbrick deployment](https://git.redbrick.dcu.ie/)

## Deployment

Gitea and its database are deployed to [Hardcase](../hardware/nix/hardcase.md) which runs [NixOS](../procedures/nixos.md)

- The actual repositories are stored in `/zroot/git` and most other data is stored in `/var/lib/gitea`
- The `SECRET_KEY` and `INTERNAL_TOKEN_URI` are stored in `/var/secrets`. They are not automatically created and must be
copied when setting up new hosts. Permissions on the `gitea_token.secret` must be 740 and owned by `git:gitea`
- Make sure that the `gitea_token.secret` does NOT have a newline character in it.

## Other Notes

The Giteadmin credentials are in the passwordsafe.

## Operation

Gitea is very well documented in itself. Here's a couple of special commands when deploying/migrating Gitea to a
different host.

```bash
# Regenerate hooks which fixes push errors
/path/to/gitea admin regenerate hooks

# If you didn't copy the authorized_keys folder then regen that too
/path/to/gitea admin regenerate keys
```
