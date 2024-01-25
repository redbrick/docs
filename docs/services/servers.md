# Servers

Redbrick provides two main servers ([Azazel](../hosts/azazel.md) and [Pygmalion](../hosts/pygmalion.md)) for it's members to use for various use cases, for example running applications or user programs.

## Entrypoints

The main login server used in Redbrick is [Azazel](../hosts/azazel.md). You may also log in to [Pygmalion](../hosts/pygmalion.md) if you wish at `pyg.redbrick.dcu.ie` 

**2 Factor Authentication is required to log in to Redbrick servers.** This is done via an SSH key and your Redbrick username/password combination. For more information on how to create an SSH key, and configure your account for 2FA, please read below.

## Logging in

You've set up 2FA on your account with an SSH key, right? [_If not, you really have to, I'm sorry._](#setting-up-an-ssh-key)

You can log in using SSH in your command prompt or terminal application of choice with your Redbrick username and password like so:

```bash
ssh YOUR_USERNAME@redbrick.dcu.ie -i SSH_KEY_LOCATION_PATH

# When prompted for the password, please input your Redbrick account password.
# NOTE: The "-i" flag specifies the location of your private ssh key.
```

### Alternatives

If you are an unbothered king/queen that simply does not mind using a web interface, let me introduce you to [wetty.redbrick.dcu.ie](https://wetty.redbrick.dcu.ie/). You do not need an SSH key here.

### Logging in to other servers

Your home directory is synced (i.e the same) on all public Redbrick servers. Thus the `authorized_keys` file will be the same on [Azazel](../hosts/azazel.md) as it is on [Pygmalion](../hosts/pygmalion.md), meaning you can log in to `pyg.redbrick.dcu.ie` too, and so on.


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

### 2. Providing some extra details
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

### 3. Copying the public key to the server

In this step we store our **public** key on the server we intend to log in to. This key will be used against our secret private key to authenticate our login. 

For the purposes of this tutorial we will be using [Pygmalion](../hosts/pygmalion.md) (`pyg.redbrick.dcu.ie`) as our server.

#### Logging in to Wetty

In order to access the server to actually place our keys in it, we need to log in via Wetty - a shell interface for [Pygmalion](../hosts/pygmalion.md) on the web.

- Head to <a href="https://wetty.redbrick.dcu.ie/" target="_blank">wetty.redbrick.dcu.ie</a>.

    You should see this prompt:
    ```
    pygmalion.redbrick.dcu.ie login:
    ```
    Enter your Redbrick username and press <kbd>ENTER</kbd>. When prompted, enter your Redbrick password. [*Forgot either of these?*](#forgot-your-password)

#### Adding the key into the `authorized_keys` file

- Add the key

    Grab the contents of your public key. You may use the `cat filepath` command for this:
    ```bash
    cat /home/bob/.ssh/id_ed25519.pub
    ```

    On Wetty, enter the following command in the shell, with `YOUR_KEY` replaced with your **public** ssh key.
    
    ```bash
    echo "YOUR_KEY" >> ~/.ssh/authorized_keys
    ```
    This command will append your public key to the end of the `authorized_keys` file.

    --- *NOTE: The speech marks surrounding YOUR_KEY are important!*

    ##### *PSSST... Made a mistake?*

    *You can manually edit the authorized_key file in a text editor with the following command to fix any issues:*

    ```bash
    nano ~/.ssh/authorized_keys
    ```

Congratulations! If you've made it this far, [you're ready to login](#logging-in) now. 

## Forgot your password?

[Contact an admin](../contact.md) on our [Discord Server](https://discord.gg/3D8kTX9auY) or at [elected-admins@redbrick.dcu.ie](mailto:elected-admins@redbrick.dcu.ie)
