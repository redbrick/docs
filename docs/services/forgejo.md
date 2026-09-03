---
id: forgejo
aliases:
  - Forgejo
tags: []
created: 2021-06-29T04:44:29
modified: 2026-09-03T08:23:37
title: Forgejo
---

# Forgejo

Redbrick uses [Forgejo](https://forgejo.org/) for git hosting.

- [Forgejo docs](https://forgejo.org/docs/latest/)
- [Gitea docs](https://docs.gitea.com/), Forgejo was forked from [Gitea](https://about.gitea.com/), so a lot of their docs are still relevant.
- [Link to Redbrick deployment](https://git.redbrick.dcu.ie/)

## Deployment

Forgejo is deployed and managed by [nomad](./nomad.md) on [aperture](../hardware/aperture)

## Management

The main admin account for forgejo is `rb-admins` and it's password is stored in the password vault. This account is both a site administrator and
an owner for the Redbrick organisation. It can be used to add people to the any team.

Committee members should have their redbrick accounts added to their respective teams on the Redbrick organisation when they are elected.