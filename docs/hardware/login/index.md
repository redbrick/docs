---
id: index
aliases:
  - Login
tags:
  - login
  - details
  - getting-started
created: 2022-05-16T01:44:40
modified: 2026-09-03T04:49:14
title: Login Boxes
---

# Login Boxes

## What are the login boxes?

These are the servers that we have open to use for all brickies. You can use them to play games, store files, or do any work that you need a linux system for (like compiling projects).

## New Login Boxes

If you need to reset or setup a new login box, there are quite a few things that need to be done. You need:
- Setup NFS mounts to give the login boxes access to both the home and webtree shares from truenas.
- Run the [ansible](../../procedures/ansible.md) scripts for new login boxes. This will install most of the packages you need and load some configs.
- Check that SSSD is working for logins.
- Check that SSSD is correctly mapping ssh keys from LDAP.
- Check that user storage quotas are applied correctly.
- Check that users cannot access or view other user folders (including admin home dirs).
- Check that users can change their own passwords.
- Check that users have permissions for their webtree.

## Hardware
- [Europa](europa)
- [Callisto](callisto)