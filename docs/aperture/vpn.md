# Admin VPN

The admin VPN is set up to allow admins to access the network from outside of DCU, giving them an IP address on the
internal network for troubleshooting, testing and integrating.

If you just want to create a new client configuration, go here: [adding a new client](#adding-a-new-client)

## Setup

We need to set up a CA (certificate authority) and PKI (public key infrastructure) to issue certificates to the clients.

We use [EasyRSA](https://github.com/OpenVPN/easy-rsa) on both the VPN server and the CA server.

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

### Creating the Server Cert and Key

> VPN Server (glados)

```bash
cd ~/EasyRSA-3.1.0
```

```bash
./easyrsa init-pki
```

```bash
./easyrsa gen-req [server_name] nopass
```

```bash
sudo cp pki/private/[server_name].key /etc/openvpn/
```

```bash
scp pki/reqs/[server_name].req wheatley:/tmp
```

### Sign the Server Request

> CA Server (wheatley)

```bash
./easyrsa import-req /tmp[server_name].req [server_name]
```

```bash
./easyrsa sign-req server [server_name]
```

```bash
scp pki/issued/[server_name].crt glados:/tmp
```

```bash
scp pki/ca.crt glados:/tmp
```

### Install the Server Cert

> VPN Server (glados)

```bash
sudo cp /tmp/{[server_name].crt,ca.crt} /etc/openvpn/
```

```bash
cd EasyRSA-3.1.0
```

```bash
./easyrsa gen-dh
```

```bash
sudo openvpn --genkey --secret ta.key
```

```bash
sudo cp ta.key /etc/openvpn/
sudo cp pki/dh.pem /etc/openvpn/
```

### Setting up Generation of Client Certificates

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

### Store the Client Certificate on the VPN Server

```bash
cp /tmp/[client_name].crt ~/vpn-client-configs/keys/
```

```bash
cd ~/EasyRSA-3.1.0
```

```bash
sudo cp ta.key ~/vpn-client-configs/keys/
sudo cp /etc/openvpn/ca.crt ~/vpn-client-configs/keys/
```

## OpenVPN Server Config

```bash
sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/
```

```bash
sudo gzip -d /etc/openvpn/server.conf.gz
```

```bash
sudo vim /etc/openvpn/server.conf
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
sudo vim /etc/sysctl.conf
```

```bash
$ cat /etc/sysctl.conf
. . .
net.ipv4.ip_forward=1
. . .
```

```bash
$ sudo sysctl -p
net.ipv4.ip_forward = 1
```

```bash
sudo vim /etc/ufw/before.rules
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
sudo vim /etc/default/ufw
```

```bash
$ cat /etc/default/ufw
. . .
DEFAULT_FORWARD_POLICY="ACCEPT"
. . .
```

## Starting and Enabling OpenVPN

```bash
sudo systemctl start openvpn@[server_name]
```

```bash
$ ip addr show tun0
. . .
3: tun0: ......
. . .
```

```bash
sudo systemctl enable openvpn@[server_name]
```

## OpenVPN Client Config

### Creating the Client Config Infrastructure

> VOP Server (glados)

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

KEY_DIR=/home/mojito/client-configs/keys
OUTPUT_DIR=/home/mojito/client-configs/files
BASE_CONFIG=/home/mojito/client-configs/base.conf

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
cd ~/vpn-client-configs/
```

```bash
./make_config.sh [client_name]
```

The client config file will be located at `~/vpn-client-configs/files/[client_name].ovpn` and this file can be copied
to the client machine.

## Adding a new Client

> VPN Server (glados)

Generate a new client request with name `[client_name]`, specifying `nopass` to avoid a password prompt.

```bash
./EasyRSA-3.1.0/easyrsa gen-req [client_name] nopass
```

Copy the client key to the client config directory for later use.

```bash
cp ~/EasyRSA-3.1.0/pki/private/[client_name].key ~/vpn-client-configs/keys/
```

Copy the client request to the CA server to be signed.

```bash
scp ~/EasyRSA-3.1.0/pki/reqs/[client_name].req wheatley:/tmp
```

> CA Server (whetley)

Import the request from the VPN server.

```bash
./EasyRSA-3.1.0/easyrsa import-req /tmp/[client_name].req [client_name]
```

Sign the request, making sure to specify the correct client name.

```bash
./EasyRSA-3.1.0/easyrsa sign-req client [client_name]
```

Copy the signed certificate to the VPN server.

```bash
scp EasyRSA-3.1.0/pki/issued/[client_name].crt glados:/tmp
```

> VPN Server (glados)

Copy the signed certificate to the client config directory.

```bash
cp /tmp/[client_name].crt ~/vpn-client-configs/keys
```

Also copy the `ca.crt` and `ta.key` files to the client config directory.

```bash
sudo cp ~/EasyRSA-3.1.0/ta.key ~/vpn-client-configs/keys
sudo cp /etc/openvpn/ca.crt ~/vpn-client-configs/keys
```

Finally run the `make_config.sh` script to generate the client config file.

```bash
./vpn-client-configs/make_config.sh [client_name]
```

The `[client_name].ovpn` file is then found at `~/vpn-client-configs/files/[client_name].ovpn` and can be copied to your
client machine.

## Revoking a Client Certificate

> CA Server (whetley)

```bash
./EasyRSA-3.1.0/easyrsa revoke [client_name]
```

```bash
./EasyRSA-3.1.0/easyrsa gen-crl
```

```bash
scp EasyRSA-3.1.0/pki/crl.pem glados:/tmp
```

> VPN Server (glados)

```bash
sudo cp /tmp/crl.pem /etc/openvpn
```

```bash
sudo systemctl restart openvpn@[server_name]
```
