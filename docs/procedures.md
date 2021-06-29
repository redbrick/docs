# Procedures

## Redbrick System Administrator Policies

The purpose of this is to brief new Redbrick system administrators on
the current setup, policies and practices in place and to serve as the place to
record all such information for current and future administrators.

### Admin Account Priviliges

- By default, all admin accounts will remain the same as the rest of the
  committee.
- Each admin will recieve a local account on each machine that will be
  in the root group. This allows you to log on if ldap goes down.
- Accounts should
  not be placed into any other 'system' or priviliged accounts (e.g. pgsql, mail,
  news, etc.) but by all accounts (hah, bad pun!) can be placed into useful groups
  (e.g. cvs, webgroup, helpdesk etc.)

### Root account

When su'ing to root, please observe the following:

- Wait for the password prompt before typing in the password! Sometimes
  lag/terminal freezes or whatever can kick in. The other classic mistake is
  typing the password in place of the username (say for a console login).
- Make sure LOGNAME is set to your unix name. The linux boxes will prompt you
  for this. On OpenBSD you can use 'su -m' to keep the environment.
- Don't change the root account/finger information!
- If you wish to use another shell, place customisations in your own file. For
  bash, `/root/.bash_profile.<USERNAME>` and for zsh `/root/.zshrc.<USERNAME>`.

`/root/.zshrc` and `/root/.bash_profile` source in the appropriate file as long
as `$LOGNAME` is set right (see above). Do not put personal customisations into
the default root account setup, remember other people have to use it.

Common aliases can be put in /root/.profile, familiarise yourself with the
existing ones, they can come in handy.

- Please keep `/root` tidy. Don't leave stuff strewn about
  the place!
- Make sure to check permissions and ownership on files you work on
  **constantly** especially files with important or sensitive information in
  them (e.g. always use `cp -p` when copying stuff about).
- Only use root account when absolutely necessary. Many admin tasks can be done
  or tested first as a regular user.

### Gotchas

Couple of things to look out for:

- `killall` command, never ever use it!
- Alias `cp`, `mv` & `rm` with the `-i` option.
- If you're ever unsure, don't! Ask another admin or check the docs.
- Always always double check commands before firing them off!

### Admin Mailing Lists

[lists.redbrick.dcu.ie](lists.redbrick.dcu.ie) (Postorius)

- All accounts in the root group must be on the admin mailing list and vice
  versa. Admins who leave/join the root group must be added/removed from the
  list respectively.
- Elected Admins should also be on the elected-admins list. This address is
  mainly used for mail to PayPal, user renewals, registration, and general administration tasks.
- It is the responsibility of the Elected Admins to ensure that all mailing lists (committee, helpdesk, webmaster, elected-admins, admins, etc) are all up-to-date.

### Admin Account Responsibilities

As an adminisitrator, your new local account has extra priviliges (namely being
in the root group). For this reason, you should not run _any_ untrusted or
unknown programs or scripts.

If you must, and source code is available you
should check it before running it. Compile your own versions of other user's
programs you use regularly. It is far too easy for other users to trojan your
account in this manner and get root.

Do not use passwordless ssh keys on any of your accounts. When using an
untrusted workstation (i.e. just about any PC in DCU!) always check for
keyloggers running on the local machine and never use any non system or non
personal copies of PuTTY/ssh - there's no way of knowing if they have been
trojaned.

### General Responsibilities

Look after and regularly monitor all systems, network, hardware and user
requests (ones that fall outside of helpdesk's realm, of course!).

Actively ensure system and network security. We can't police all user accounts
and activities, but basic system security is paramount! Keep uptodate with
bugtraq/securityfocus etc. Check system logs regularly, process listings,
network connections, disk usage, etc.

### Downtime

All downtime must be scheduled and notified to the members well in advance by
means of motd & _announce_. If it's really important, a mail to
announce-redbrick and socials post may be necessary.

All unexpected/unscheduled downtime (as a result of a crash or as an emergency
precaution) must be explained to the members as soon as possible after the
system is brought back. A post to announce, notice in motd or possibly a mail
to committee/admins is sufficient.

When performing a shutdown, start the shutdown 5 or 10 minutes in advance of the
scheduled shutdown time to give people a chance to logout. It may also be useful
to disable logins at this stage with a quick explanation in `/etc/nologin`.

### Documentation

Please read all the documentation before you do anything, but remember that the
docs aren't complete and are sometimes out of date. Please update them as you go
:D

---

## Post-powercut Todo List

A list of things that should be done/checked immediately after a power cut:

- Check KVM, hit ctrl+D on minerva to make sure it boots.
- Check KVM, hit F1 on sprout to make sure it boots
- Check KVM, sometimes you need to press F1 on carbon for it to boot
- Stop Exim on the mail server (Morpheus) until minerva (NFS) is online.
- If LDAP is down, you'll need to use the ALOM to do the next step.
- Check that ldapclient started (svcs -xv). If it didn't, run svcadm clear ldap/client to make it start. This usually happens because murphy comes back before morpheus does, and the LDAP client won't start due to lack of an LDAP server.
- Apache is stupid and tries to start before networking is finished starting. To fix it, disable/re-enable it a few times. This usually makes it turn on.

---

## NixOS

Familiarise yourself with the layout of the following. Bookmarking the page is also a good shout.
[NixOS documentation](https://nixos.org/nixos/manual/)

### Who is NixOS and what does he do

NixOS is a distribution of linux that is focused on having a config-first operating system to
run services. The advantages of such an approach are the following:

- Files dictate how an installation is set up, and as such, can be versoined and
  tracked in your favorite VCS.
- New configs can be tested, and safely rolled back.
- Can be used for both physical and virtual machines in the same way.

Further reading on this can be found on the [about page](https://nixos.org/nixos/about.html).

### Being an admin: NixOS and you

There's a couple of things you'll need to do before you get started with NixOS
First and foremost is to get set up to contribute to the [Redbrick nix-configs repo](https://github.com/redbrick/nix-configs).

Depending on the powers that be, some sort of normal pr contribution will be acceptable,
if you have access a branch is appropriate, in all other cases make a fork and pr back to
Redbrick's repo. This will be case by case for those of you reading.

Here's a quick hit list of stuff that's worthy of book marking also as you work with Nix:

- [NixOS Wiki](https://nixos.wiki/wiki/Main_Page)
- [NixOS Manual](https://nixos.org/nixos/manual/)
- [Nixpkgs index](https://nixos.org/nixos/packages.html?channel=nixpkgs-unstable)
  (unstable means changing, not buggy)
- [Grafana config options](https://nixos.org/nixos/options.html#services.grafana)
  (as an example of how to configure an individual service)

Nix is pretty small as an OS so setting yourself up a node, either as a home server, or as a VM
is a solid way to practice how stuff works in an actual environment and lets you work
independantly of Redbrick. A service you configure at home should be able to run on Redbrick,
and vice versa.

#### Getting set up to start deploying stuff

The first step is to navigate to the ssh service config in the nix-config repo
[here](https://github.com/redbrick/nix-configs/blob/master/services/ssh.nix).

Make a pull request asking to add the **PUBLIC KEY** of your ssh key pait to the config file.
The best thing to do is to copy the previous line and modify it to contain your details instead.
At time of writing, it is expected for you to generate a `ssh-ed25519` key. This is subject to
change with new cryprographic standards.

Once this is done, contact one of the currently set up users to pull and reload the given machines
and you'll have access right away using the accompanying key.

---

## IRC Ops

This is a mirror of:
[Redbrick cmt Wiki entry](https://www.redbrick.dcu.ie/cmt/wiki/index.php?title=IRC_Op_Guide)

##### Channel Modes

It's easy to bugger up the channel with the MODE command, so here's a nice
copied and pasted summary of how to use it:

- `/mode {channel} +b {nick|address}` - ban somebody by nickname or address mask
  (nick!account@host)
- `/mode {channel} +i` - channel is invite-only
- `/mode {channel} +l {number}` - channel is limited, with {number} users
  allowed maximal
- `/mode {channel} +m` - channel is moderated, only chanops and others with
  'voice' can `talk/mode {channel} +n` external `/MSG`s to channel are not
  allowed.
- `/mode {channel} +p` - channel is private
- `/mode {channel} +s` - channel is secret
- `/mode {channel} +t topic` - limited, only chanops may change it
- `/mode {channel} +o {nick}` - makes `{nick}` a channel operator
- `/mode {channel} +v {nick}` - gives `{nick}` a voice

##### Other Commands

Basically what you'll be using is:

- To kick someone: `/kick username`
- To ban someone: `/mode #lobby +b username`
- To set the topic: `/topic #lobby whatever`
- To op someone: `/mode #lobby +o someone`
- To op two people: `/mode #lobby +oo someone someone_else`

Or:

- To kick someone: `/k username`
- To ban someone: `/ban username`
- To unban someone: `/unban username`
- To set the topic: `/t whatever`
- To op someone: `/op someone`
- To op two people: `/op someone someone_else`
- To deop someone: `/deop someone`

##### Sysop specific commands

These commands can only be run by sysops (i.e. admins in the ircd config file).

- Enter BOFH mode (required for all sysop commands): `/oper`
- Peer to another server\*: `/sconnect <node name>`
- Drop a peer with another server: `/squit <node name>`
- Force op yourself (**do not abuse**): `/quote opme <channel name>`
- Barge into a channel uninvited (**again, do not abuse**):
  `/quote ojoin #channel`
- Barge into a channel uninvited with ops (**same again**):
  `/quote ojoin @#channel`
- Force someone to join a channel: `/quote forcejoin nick #channel`
- Kill someone: /kill `<username>` `<smartassed kill messsage>`
- Ban someone from this server: `/kline <username>` (there may be more params on
  this)
- Ban someone from the entire network: `/gline <username>` (there may be more
  params on this)

(thanks to atlas for the quick overview)

- Don't try connect to intersocs. Due to crazy endian issues or something they
  have to connect to us.

##### Bots

It has now become a slight problem with so many bots 'littering' #lobby that
anyone wishing to add a new bot to the channel must request permission from the
Committee. The main feature wanted is a time limit on bot commands.

##### Services

The IRC services run by Trinity for all the netsocs. The two services are
`NickServ` and `ChanServ`.

- `/msg NickServ HELP`
- `/msg ChanServ HELP`

for more details.

---
