---
title: index
created: 2026-09-03T01:44:40
modified: 2026-09-17T17:55:53
tags:
aliases:
  - Storage
id: storage
---

# Storage

## What is Our Storage?

Our storage is currently hosted on two identical PowerEdge R730s that run TrueNAS. They are configured to be in sync with each other so that if one fails, we can just switch over to using the other with minimal downtime.

## What Does it Do?

The only service hosted on our storage boxes is NFS. This is how we share storage across the network to all of our servers.

## Hardware

- [Mirage](mirage.md)
- [Anubis](anubis.md)
