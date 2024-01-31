# Preface

Here you will find a list of all the services Redbrick runs, along with some configs and some important information

surrounding them.

- [api](api.md)
- [bind](bind.md)
- [codimd](codimd.md)
- [gitea](gitea.md)
- [irc](irc.md)
- [nfs](nfs.md)
- [traefik](traefik.md)
- [znapzend](znapzend.md)

## Adding More Services

In order to add a new service, you will need to edit the [docs](https://github.com/redbrick/docs) repository.

Adding a new service is as easy as creating a new file in `docs/services/` with an appropriate name, and adding the reference to `mkdocs.yml` in the root of the repository.

The style guide for a service file should be as follows:

```md
# ServiceName - `username`

Short description on how the service works and where it is running

## Configuration

Add some possible useful configs here, like a docker-compose file,
certain command you may have had to run, or something that is not very obvious.
Look at other services for hints on this.
```
