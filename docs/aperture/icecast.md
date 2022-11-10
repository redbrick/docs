# Icecast

Icecast is a streaming server that we currently host on aperture.

We stream DCUFm's Broadcasts to their apps via a stream presented on `dcufm.redbrick.dcu.ie`.

## Procedure

The configuration file for icecast is located in the [nomad config repo](https://github.com/redbrick/nomad).

It should just be a case of running `nomad job plan clubs-socs/dcufm.hcl` to plan and run the job.

## Streaming to Icecast

DCUfm use [butt](https://danielnoethen.de/butt/) on a desktop in their studio to stream to Icecast.

The desktop must be connected to the vpn to ensure the stream stays up, and traefik doesn't reset the connection every
10 seconds. The current icecast configuration for the server is 10.10.0.5:2333. Read more about it in [this issue](https://github.com/redbrick/issue-tracker/issues/4).

A shortcut to the VPN is available on the desktop (change a shortcut to the binary to include `--connect profile.ovpn`.
See [here](https://munkjensen.net/wiki/index.php/Connect_OpenVPN_on_Windows_startup)).

## DCUfm Cheat Sheet

This is a cheat sheet for DCUfm to help them stream to icecast.

### Connecting to the VPN

You'll need to connect to the Redbrick VPN to stream to icecast. You can do this by double clicking the shortcut on the desktop.
You'll then need to go to bottom right corner of the screen and right click this icon:
![Disconnected OpenVPN icon](https://i.dbyte.xyz/2022-11-I9.png)

A popup will appear, click connect. This will connect you to the VPN. It may take a second, but a window will pop up with
a lot of text. The VPN will connect and then it'll close.
![Connect to OpenVPN](https://i.dbyte.xyz/2022-11-AV.png)

You should end up with an icon like this:
![Connected OpenVPN icon](https://i.dbyte.xyz/2022-11-16.png)

You're now connected to the VPN.

### Connecting to Icecast

You'll need to connect to icecast to stream to it. BUTT is the software we use to stream to icecast. You'll also find this
on the desktop. Once its open, (and you're connected to the VPN), press the small "play" button in the top left corner. This
will start your stream to the server.

The username and password should already be configured in the software. If not, ask a [redbrick sysadmin](../../contact)
for the login details.

### Saving your stream

Your stream will be saved automatically onto the desktop into a folder called `Recordings 2022`, with the date and time
of the recording, and the format `.mp3`. Take this file with you if you want to keep it for later, it will not be kept
on the desktop for long!

### Further Information

If you have any questions, please ask a [redbrick sysadmin](../../contact).
