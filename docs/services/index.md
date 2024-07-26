---
id: index
aliases:
  - Preface
tags: []
created: 2021-06-29T04:44:29
modified: 2024-04-02T00:12:41
title: Services
---

# Preface

Here you will find a list of all the services Redbrick runs, along with some configs and some important information surrounding them.

- [api](api.md)
- [bastion-vm](bastion-vm.md)
- [bind](bind.md)
- [md](md.md)
- [consul](consul.md)
- [gitea](gitea.md)
- [irc](irc.md)
- [nfs](nfs.md)
- [nomad](nomad.md)
- [traefik](traefik.md)
- [znapzend](znapzend.md)

## Adding More Services

In order to add a new service, you will need to edit the [docs](https://github.com/redbrick/docs) repository.

Adding a new service is as easy as creating a new file in [`docs/services/`](https://github.com/redbrick/docs/tree/master/docs/services) with an appropriate name, and the page will be automatically added to the navigation pane.

Try to keep file names short and concise, limited to one word if possible and avoid using spaces.

The style guide for a service file should be as follows:

```md
---
title: ServiceName
author:
  - username
tags:
  - relevant
  - tags

---

# ServiceName - `username`

Short description on how the service works and where it is running

## Configuration

Add some possible useful configs here, like a docker-compose file,
certain command you may have had to run, or something that is not very obvious.
Look at other services for hints on this.
```
