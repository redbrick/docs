# Admin VPN

The admin VPN is set up to allow admins to access the network from outside of DCU, giving them an IP address on the
internal network for troubleshooting, testing and integrating.

If you just want to create a new client configuration, go here: [adding a new client](#adding-a-new-client)

## Setup

We need to set up a CA (certificate authority) and PKI (public key infrastructure) to issue certificates to the clients.

We use [EasyRSA](https://github.com/OpenVPN/easy-rsa) on both the VPN server and the CA server.

!!!important
    When configuring and setting up the infrastructure, use the `root` account.

### Download EasyRSA

> CA & VPN Server (glados, wheatley)

```bash
wget -P ~/ https://github.com/OpenVPN/easy-rsa/releases/download/v3.1.0/EasyRSA-3.1.0.tgz
```

```bash
tar xvf EasyRSA-3.1.0.tgz
```

### Initialise CA

> CA Server (wheatley)

```bash
cd ~/EasyRSA-3.1.0
```

```bash
cp vars.example vars
```

```bash
$ cat vars
. . .
set_var EASYRSA_REQ_COUNTRY     "IE"
set_var EASYRSA_REQ_PROVINCE    "Dublin"
set_var EASYRSA_REQ_CITY        "Dublin"
set_var EASYRSA_REQ_ORG         "Redbrick"
set_var EASYRSA_REQ_EMAIL       "elected-admins@redbrick.dcu.ie"
set_var EASYRSA_REQ_OU          "sysadmins"
. . .
```

```bash
./easyrsa init-pki
```

```bash
rm vars
```

```bash
./easyrsa build-ca nopass
```

At the prompt, enter the CA server name, in this case, `wheatley`.

### Creating the Server Cert and Key

> VPN Server (glados)

```bash
cd ~/EasyRSA-3.1.0
```

No need to configure the `vars` file like before, as we're not creating a CA. We can just initialise the PKI.

```bash
./easyrsa init-pki
```

```bash
./easyrsa gen-req [server_name] nopass
```

You will be asked to provide a common name, which is the server name. In this case, `glados`.

```bash
cp pki/private/[server_name].key /etc/openvpn/
```

```bash
scp pki/reqs/[server_name].req wheatley:/tmp
```

### Sign the Server Request

> CA Server (wheatley)

```bash
./easyrsa import-req /tmp/[server_name].req [server_name]
```

```bash
./easyrsa sign-req server [server_name]
```

At the prompt, ensure you type `yes` to sign the request, assuming all information is correct.

```bash
scp pki/issued/[server_name].crt glados:/tmp
```

```bash
scp pki/ca.crt glados:/tmp
```

Before moving back to the VPN server, ensure you delete the signed request from the CA server.

```bash
rm /tmp/[server_name].req
```

### Install the Server Cert

> VPN Server (glados)

```bash
mv /tmp/{[server_name].crt,ca.crt} /etc/openvpn/
```

```bash
cd EasyRSA-3.1.0
```

```bash
./easyrsa gen-dh
```

```bash
openvpn --genkey secret ta.key
```

```bash
cp ta.key /etc/openvpn/
cp pki/dh.pem /etc/openvpn/
```

### Setting up Client Certificate Generation Infrastructure

> VPN Server (glados)

The reason generating a client certificate is done on the VPN server is to allow a script to be used to generate the
configs quickly, the certifcate can then be sent to the client.

```bash
mkdir -p ~/vpn-client-configs/keys
```

```bash
chmod -R 700 ~/vpn-client-configs/
```

### Generating the Client Certificate

> VPN Server (glados)

```bash
cd ~/EasyRSA-3.1.0
```

```bash
./easyrsa gen-req [client_name] nopass
```

```bash
cp pki/private/[client_name].key ~/vpn-client-configs/keys/
```

```bash
scp pki/reqs/[client_name].req wheatley:/tmp
```

### Signing the Client Certificate

> CA Server (wheatley)

```bash
cd ~/EasyRSA-3.1.0
```

```bash
./easyrsa import-req /tmp/[client_name].req [client_name]
```

```bash
./easyrsa sign-req client [client_name]
```

```bash
scp pki/issued/[client_name].crt glados:/tmp
```

Don't forget to clean up the signed request on the CA server.

```bash
rm /tmp/[client_name].req
```

### Store the Client Certificate on the VPN Server

> VPN Server (glados)

```bash
mv /tmp/[client_name].crt ~/vpn-client-configs/keys/
```

```bash
cd ~/EasyRSA-3.1.0
```

```bash
cp ta.key ~/vpn-client-configs/keys/
cp /etc/openvpn/ca.crt ~/vpn-client-configs/keys/
```

## OpenVPN Server Config

```bash
cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf /etc/openvpn/
```

```bash
vim /etc/openvpn/server.conf
```

```bash
$ cat /etc/openvpn/server.conf
. . .
tls-auth ta.key 0 # This file is secret
cipher AES-256-CBC
auth SHA256
dh dh.pem
user nobody
group nogroup
cert [server_name].crt
key [server_name].key  # This file is secret
. . .
```

## Server Networking Configuration

```bash
vim /etc/sysctl.conf
```

```bash
$ cat /etc/sysctl.conf
. . .
net.ipv4.ip_forward=1
. . .
```

```bash
$ sysctl -p
net.ipv4.ip_forward = 1
```

```bash
vim /etc/ufw/before.rules
```

```bash
$ cat /etc/ufw/before.rules
. . .
# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0] 
# Allow traffic from OpenVPN client to eth0 (change to the interface you discovered with `ip route | grep default`)
-A POSTROUTING -s 10.8.0.0/8 -o [default interface name] -j MASQUERADE
COMMIT
# END OPENVPN RULES

# Don't delete these required lines, otherwise there will be errors
*filter
. . .
```

```bash
vim /etc/default/ufw
```

```bash
$ cat /etc/default/ufw
. . .
DEFAULT_FORWARD_POLICY="ACCEPT"
. . .
```

## Starting and Enabling OpenVPN

```bash
systemctl start openvpn@server
```

!!!Note
    Despite using the server name everywhere else, this uses the "@server" option to start the vpn server, rather than
    start the client.

```bash
$ ip addr show tun0
. . .
3: tun0: ......
. . .
```

```bash
systemctl enable openvpn@server
```

## OpenVPN Client Config

### Creating the Client Config Infrastructure

> VPN Server (glados)

```bash
mkdir -p ~/vpn-client-configs/files
```

```bash
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf ~/vpn-client-configs/base.conf
```

```bash
vim ~/vpn-client-configs/base.conf
```

```bash
$ cat ~/vpn-client-configs/base.conf
. . .
remote [server_ip_address] 1194
user nobody
group nogroup
#ca ca.crt
#cert client.crt
#key client.key  # This file is secret
#tls-auth ta.key 0 # This file is secret
cipher AES-256-CBC
auth SHA256
key-direction 1
script-security 2
up /etc/openvpn/update-resolv-conf
down /etc/openvpn/update-resolv-conf
. . .
```

```bash
vim ~/vpn-client-configs/make_config.sh
```

```bash
$ cat ~/vpn-client-configs/make_config.sh
#!/bin/bash

# First argument: Client identifier

KEY_DIR=/root/vpn-client-configs/keys
OUTPUT_DIR=/root/vpn-client-configs/files
BASE_CONFIG=/root/vpn-client-configs/base.conf

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEY_DIR}/${1}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/${1}.key \
    <(echo -e '</key>\n<tls-auth>') \
    ${KEY_DIR}/ta.key \
    <(echo -e '</tls-auth>') \
    > ${OUTPUT_DIR}/${1}.ovpn
```

```bash
chmod 700 ~/vpn-client-configs/make_config.sh
```

### Generating Client Configs

> VPN Server (glados)

```bash
./vpn-client-configs/make_config.sh [client_name]
```

The client config file will be located at `~/vpn-client-configs/files/[client_name].ovpn` and this file can be copied
to the client machine.

## Adding a new Client

> VPN Server (glados)

Generate a new client request with name `[client_name]`, specifying `nopass` to avoid a password prompt.

```bash
/root/EasyRSA-3.1.0/easyrsa gen-req [client_name] nopass
```

Copy the client key to the client config directory for later use.

```bash
cp /root/EasyRSA-3.1.0/pki/private/[client_name].key /root/vpn-client-configs/keys/
```

Copy the client request to the CA server to be signed.

```bash
scp /root/EasyRSA-3.1.0/pki/reqs/[client_name].req wheatley:/tmp
```

> CA Server (whetley)

Import the request from the VPN server.

```bash
/root/EasyRSA-3.1.0/easyrsa import-req /tmp/[client_name].req [client_name]
```

Sign the request, making sure to specify the correct client name.

```bash
/root/EasyRSA-3.1.0/easyrsa sign-req client [client_name]
```

Copy the signed certificate to the VPN server.

```bash
scp /root/EasyRSA-3.1.0/pki/issued/[client_name].crt glados:/tmp
```

> VPN Server (glados)

Copy the signed certificate to the client config directory.

```bash
cp /tmp/[client_name].crt /root/vpn-client-configs/keys
```

Also copy the `ca.crt` and `ta.key` files to the client config directory.

```bash
cp /root/EasyRSA-3.1.0/ta.key /root/vpn-client-configs/keys
cp /etc/openvpn/ca.crt /root/vpn-client-configs/keys
```

Finally run the `make_config.sh` script to generate the client config file.

```bash
/root/vpn-client-configs/make_config.sh [client_name]
```

The `[client_name].ovpn` file is then found at `/root/vpn-client-configs/files/[client_name].ovpn` and can be copied to your
client machine.

## Revoking a Client Certificate

> CA Server (whetley)

```bash
/root/EasyRSA-3.1.0/easyrsa revoke [client_name]
```

```bash
/root/EasyRSA-3.1.0/easyrsa gen-crl
```

```bash
scp /root/EasyRSA-3.1.0/pki/crl.pem glados:/tmp
```

> VPN Server (glados)

```bash
mv /tmp/crl.pem /etc/openvpn
```

Make sure the openvpn server config has the following line:

```bash
crl-verify crl.pem
```

to ensure the CRL is used.

```bash
systemctl restart openvpn@server
```
