---
id: policies
aliases:
  - Redbrick System Administrator Policies
tags: []
created: 2023-12-05T01:36:11
modified: 2024-01-30T01:31:37
title: Systems Administrator Policies
---

# Redbrick System Administrator Policies

The purpose of this is to brief new Redbrick system administrators on the current setup, policies and practices in place and to serve as the place to record all such information for current and future administrators.

## Admin Account Priviliges

- By default, all admin accounts will remain the same as the rest of the committee.
- Each admin will recieve a local account on each machine that will be in the root group. This allows you to log on if ldap goes down.
- Accounts should not be placed into any other 'system' or privileged accounts (e.g. pgSQL, mail, news, etc.) but by all accounts (hah, bad pun!) can be placed into useful groups (e.g. cvs, webgroup, helpdesk etc.)

## Root account

When su'ing to root, please observe the following:

- Wait for the password prompt before typing in the password! Sometimes lag/terminal freezes or whatever can kick in. The other classic mistake is typing the password in place of the username (say for a console login).
- Make sure LOGNAME is set to your UNIX name. The Linux boxes will prompt you for this. On OpenBSD you can use 'su -m' to keep the environment.
- Don't change the root account/finger information!
- If you wish to use another shell, place customisations in your own file. For bash, `/root/.bash_profile.<USERNAME>` and for zsh `/root/.zshrc.<USERNAME>`.

`/root/.zshrc` and `/root/.bash_profile` source in the appropriate file as long as `$LOGNAME` is set right (see above). Do not put personal customisations into the default root account setup, remember other people have to use it.

Common aliases can be put in /root/.profile, familiarise yourself with the existing ones, they can come in handy.

- Please keep `/root` tidy. Don't leave stuff strewn about the place!
- Make sure to check permissions and ownership on files you work on **constantly** especially files with important or sensitive information in them (e.g. always use `cp -p` when copying stuff about).
- Only use root account when absolutely necessary. Many admin tasks can be done or tested first as a regular user.

## Gotchas

Couple of things to look out for:

- `killall` command, never ever use it!
- Alias `cp`, `mv` & `rm` with the `-i` option.
- If you're ever unsure, don't! Ask another admin or check the docs.
- Always always double check commands before firing them off!

## Admin Mailing Lists

[lists.redbrick.dcu.ie](https://lists.redbrick.dcu.ie) (`Postorius`)

- All accounts in the root group must be on the admin mailing list and vice versa. Admins who leave/join the root group must be added/removed from the list respectively.
- Elected Admins should also be on the elected-admins list. This address is mainly used for mail to PayPal, user renewals, registration, and general administration tasks.
- It is the responsibility of the Elected Admins to ensure that all mailing lists (committee, helpdesk, webmaster, elected-admins, admins, etc) are all up-to-date.

## Admin Account Responsibilities

As an administrator, your new local account has extra privileges *(namely being in the root group)*.

For this reason, you should not run _any_ untrusted or unknown programs or scripts.

If you must, and source code is available you should check it before running it. Compile your own versions of other user's programs you use regularly. It is far too easy for other users to trojan your account in this manner and get root.

Do not use passwordless ssh keys on any of your accounts. When using an untrusted workstation (i.e. just about any PC in DCU!) always check for keyloggers running on the local machine and never use any non system or non personal copies of PuTTY/ssh - there's no way of knowing if they have been trojaned.

## General Responsibilities

Look after and regularly monitor all systems, network, hardware and user requests (ones that fall outside of helpdesk's realm, of course!).

Actively ensure system and network security. We can't police all user accounts and activities, but basic system security is paramount! Keep up to date with bugtraq/securityfocus etc. Check system logs regularly, process listings, network connections, disk usage, etc.

## Downtime

All downtime must be scheduled and notified to the members well in advance by means of motd & _announce_. If it's really important, a mail to announce-redbrick and socials post may be necessary.

All unexpected/unscheduled downtime (as a result of a crash or as an emergency precaution) must be explained to the members as soon as possible after the system is brought back. A post to announce, notice in motd or possibly a mail to committee/admins is sufficient.

When performing a shutdown, start the shutdown 5 or 10 minutes in advance of the scheduled shutdown time to give people a chance to logout. It may also be useful to disable logins at this stage with a quick explanation in `/etc/nologin`.

## Documentation

Please read all the documentation before you do anything, but remember that the docs aren't complete and are sometimes out of date. Please update them as you go :D
