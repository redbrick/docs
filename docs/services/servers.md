---
id: servers
aliases:
  - Servers
tags: []
created: 2021-08-14T23:47:50
modified: 2024-01-31T08:23:37
title: Servers
---

# Servers

Redbrick provides two main servers ([Azazel](../hardware/azazel.md) and [Pygmalion](../hardware/pygmalion.md)) for it's members to use for various use cases, for example running applications or user programs.

## Entrypoints

The main login server used in Redbrick is [Azazel](../hardware/azazel.md). You may also log in to [Pygmalion](../hardware/pygmalion.md) if you wish at `pyg.redbrick.dcu.ie`

**2 Factor Authentication is required to log in to Redbrick servers.** This is done via an SSH key and your Redbrick username/password combination. For more information on how to create an SSH key, and configure your account for 2FA, please read below.

## Logging in

You've set up 2FA on your account with an SSH key, right? [_If not, you really have to, I'm sorry._](#setting-up-an-ssh-key)

You can log in using SSH in your command prompt or terminal application of choice with your Redbrick username like so:

```bash
ssh YOUR_USERNAME@login.redbrick.dcu.ie -i SSH_KEY_LOCATION_PATH

# NOTE: The "-i" flag specifies the location of your private ssh key.
```

### Logging in to other Servers

Your home directory is synced (i.e the same) on all public Redbrick servers. Thus your public key will be the same on [Callisto](../hardware/login/callisto.md) as it is on [Europa](../hardware/login/europa.md), meaning you can log in to `europa.redbrick.dcu.ie` too, and so on.

## Setting up an SSH Key

Generating an SSH key pair creates two long strings of characters: a public and a private key. You can place the public key on any server, and then connect to the server using an SSH client that has access to the private key.

When these keys match up, and your account password is also correct, you are granted authorisation to log in.

### 1. Creating the Key Pair

On your local computer, in the command line of your choice, enter the following command:

```bash
ssh-keygen -t ed25519
```

Expected Output

```
Generating public/private ed25519 key pair.
```

### 2. Providing Some Extra Details

You will now be prompted with some information and input prompts:

- The first prompt will ask where to save the keys.

```
Enter file in which to save the key (e.g /home/bob/.ssh/id_ed25519):
```

You can simply press <kbd>ENTER</kbd> here to save them at the default location (.ssh directory in your home directory). *Alternatively you can specify a custom location if you wish.*

- The second prompt will ask for a new passphrase to protect the key.

```
Enter passphrase (empty for no passphrase):
```

Here you may protect this key file with a passphrase. This is optional and recommended for security.

> [!NOTE] Note
> *If you do not wish to add a passphrase to save you all that typing, simply press <kbd>ENTER</kbd> for the password and confirmation password prompts.*

*The newly generated public key should now be saved* in `/home/bob/.ssh/id_ed25519.pub`. The private key is the same file is at `/home/bob/.ssh/id_ed25519`. *(i.e under the `.ssh` folder in your user home directory.)*

##### NOTE FOR WINDOWS (you heathen)

This key is saved under .ssh under your User directory. (i.e `C:\Users\Bob\.ssh\id_ed25519`)

### 3. Add your Public Key to your Redbrick Account

To do this you will need to run the `/account pubkey` command on the Redbrick Discord server. This will give you a field called "key" where you can paste your public key. You can get the contents of your public key by running the following command in your terminal:

```bash
cat /home/bob/.ssh/id_ed25519.pub
```

Congratulations! If you've made it this far, [you're ready to login](#logging-in) now.

## Forgot Your Password?

[Contact an admin](../contact.md) on our [Discord Server](https://discord.redbrick.dcu.ie) or at [elected-admins@redbrick.dcu.ie](mailto:elected-admins@redbrick.dcu.ie)
