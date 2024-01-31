# Roadmap

## Operating Systems Of Choice

- NixOS -> Used on Motherlode
- Ubuntu -> Login boxes
- Debian -> Used for all other machines

Why?

- Sensible defaults (/etc/resolve.conf etc.)
- No snap
- Debian is as close to the most popular distribution as possible

## Important (Core) Services

_In order of priority._

- DNS
  - Migrate to **Fred**
  - Set up on new server
  - Clean up the zone file
- /storage/
  - NFS, backups, database (from Icarus) and failover (from Daedalus)
- LDAP (Daedalus, Icarus read-only slave)
- pwsafe (look at changing to hashcorp vault/bitwarden)

---

### -> Login Machines (Ubuntu)

- Azazel
- Pygmalion
- Zeus (Non-login -> Designated Docker Host)

### -> Multipurpose Machines (Debian)

- Halfpint
- Paphos
- Daedalus
- Icarus
- Albus
- Clyde
- Hardcase
- Metharme
- Fred

### -> Designated Nix Machine

**Motherlode.**

Why?

- Clubs and Socs and other services like Mail are quite honestly easiest done using Nix configs (even though it can be disgusting). It is a viable choice to solve a hard problem.

#### Services Using Nix to Be Moved to Motherlode

- Mailman
- Certs
- Grafana **(X)**
- Httpd (Apache)
- ircd
- LDAP
- Postfix
- zfsquota
- bitlbee
- git
- glusterfs
- libvrt
- Loki **(X)**
- postgres
- prometheus **(X)**
- promtail
- rbbackup
- redis
- squid
- sshnix (ssh keys)
- thelounge **(X)**
- znapsend

## Docs

- Update [fucking.readthedocs.io](https://fucking.readthedocs.io) to new home, [docs.redbrick.dcu.ie](https://docs.redbrick.dcu.ie)

## TODO

In order of priority.

- Update docs
  - Material for MkDocs
- Make passwordsafe redundant
  - Migrate to BitWarden
  - Use Fred as a temporary host while we decide what to make it's permanent host
- Azazel needs to be functional
  - Authentication missing local users
- Fred becomes new DNS host
  - Remove DNS from Paphos
- Databases moved to Master/Redundancy Machines
  - Databases are dependancies for the services to come
  - Hardcase and Metharme
- Move all services to remain to Motherlode/Nix
  - Remove redundant services (marked X)
- Firewall cleanup
  - Assign IP's
- Stable Monitoring setup for all servers and services
