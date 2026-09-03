---
id: storage
aliases:
  - Storage
tags:
created: 2026-09-03T01:44:40
modified: 2026-09-03T04:49:14
title: Storage
---

# Storage

## What is our storage?

Our storage is currently hosted on two identical PowerEdge R730s that run TrueNAS. They are configured to be in sync with each other so that if one fails, we can just switch over to using the other with minimal downtime.

## What does it do?

The only service hosted on our storage boxes is NFS. This is how we share storage across the network to all of our servers.

## Hardware
- [Mirage](mirage)
- [Anubis](anubis)