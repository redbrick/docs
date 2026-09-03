---
id: servers
aliases:
  - Servers
  - Logging in
  - Login
tags: []
created: 2021-08-14T23:47:50
modified: 2026-09-03T08:23:37
title: Servers
---
# Servers

Redbrick provides two main servers ([Europa](../hardware/login/europa.md) and [Callisto](../hardware/login/callisto.md)) for it's members to use for various use cases, for example running applications or user programs.

## Entrypoints

**With the introduction of our new login boxes, [Europa](../hardware/login/europa.md) and [Callisto](../hardware/login/callisto.md) we now require public key authentication. You can no longer login with just a password.**
If you had a public ssh key added to your account in the past, it should still work. If not, the prefferred way to add one is to join the redbrick [Discord server](https://discord.redbrick.dcu.ie), link your Discord account with your redbrick account, and add your key using the `/account pubkey <publickey>` blockbot command.

If you have any issues, please contact the admins either by creating a ticket in the Discord server or by [email](mailto:elected-admins@redbrick.dcu.ie).

## Logging in

You've set up your account with an SSH key, right? [_If not, you really have to, I'm sorry._](#setting-up-an-ssh-key)

You can log in using SSH in your command prompt or terminal application of choice with your Redbrick username like so:

```bash
ssh YOUR_USERNAME@login.redbrick.dcu.ie -i SSH_KEY_LOCATION_PATH

# NOTE: The "-i" flag specifies the location of your private ssh key.
```

### Logging in to other Servers

Your home directory and all user information is synced between the login boxes, meaning if you can login to [Europa](../hardware/login/europa.md) with your ssh key, you will also be able to login to [Callisto](../hardware/login/callisto.md) with the same key. This works regardless of how you added your key (Whether through blockbot, or in the `authorized_keys` file)

## Setting up an SSH Key

Generating an SSH key pair creates two long strings of characters: a public and a private key. You can place the public key on any server, and then connect to the server using an SSH client that has access to the private key.

When these keys match up, and your account password is also correct, you are granted authorisation to log in.

**Never share your private key with anyone, or store it anywhere you don't trust completely, because anybody can use this to gain full control over your redbrick account.**

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
Enter file in which to save the key (e.g /home/<user>/.ssh/id_ed25519):
```

You can simply press <kbd>ENTER</kbd> here to save them at the default location (.ssh directory in your home directory). *Alternatively you can specify a custom location if you wish.*

- The second prompt will ask for a new passphrase to protect the key.

```
Enter passphrase (empty for no passphrase):
```

Here you may protect this key file with a passphrase. This is optional but recommended for security.

> [!NOTE] Note
> *If you do not wish to add a passphrase to save you all that typing, simply press <kbd>ENTER</kbd> for the password and confirmation password prompts.*

*The newly generated public key should now be saved* in `/home/<user>/.ssh/id_ed25519.pub`. The private key is the same file is at `/home/<user>/.ssh/id_ed25519`. *(i.e under the `.ssh` folder in your user home directory.)*

##### NOTE FOR WINDOWS (you heathen)

This key is saved under .ssh under your User directory. (i.e `C:\Users\<user>\.ssh\id_ed25519`)

### 3. Add your Public Key to your Redbrick Account

In this step we store our **public** key on the server we intend to log in to. This key will be used against our secret private key to authenticate our login.

For the purposes of this tutorial we will be using [Europa](../hardware/login/europa.md) (`europa.redbrick.dcu.ie`) as our server.

#### Adding the Key into the `authorized_keys` File

If you want to have multiple ssh keys on your redbrick account, you can add them to the `authorized_keys` file.

To do this you **need** to already have access to the login boxes, such as by using the blockbot `/account pubkey <key>` command.

If your key is located at `/home/<user>/.ssh/id_ed25519.pub`, for example, you can run
```bash
ssh-copy-id <user>@europa.redbrick.dcu.ie -i /home/<user>/.ssh/id_ed25519.pub
```

This command will append your public key to the end of the `authorized_keys` file.

##### *PSSST… Made a mistake?*

*You can manually edit the authorized_key file in a text editor with the following command to fix any issues:*

```bash
nano ~/.ssh/authorized_keys
```

Congratulations! If you've made it this far, [you're ready to login](#logging-in) now.

## Forgot Your Password?

If you have any issues, please contact the admins either by creating a ticket in the Discord server or by [email](mailto://elected-admins@redbrick.dcu.ie).
