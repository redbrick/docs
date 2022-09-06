# Network

## External Addresses

`Mordor` is natted when it accesses the Internet. This is because the link address between it and DCU is on a private address.
This natting is used *only* for the UDM pro device itself, not for the 136.206.16.0/24 network, and is to allow the UDM
box itself to access the Internet.

The 136.206.16.0/24 network is routed down to the UDM pro box, within the DCU network. Essentially there is a route in
DCU's network that says "if you want to access 136.206.16.0/24 go to mordor".

## Internal Addresses
