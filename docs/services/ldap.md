---
title: ldap
created: 2024-03-13T06:05:23
modified: 2026-09-03T13:52:41
tags:
  - ldap
  - icarus
  - daedalus
aliases:
  - LDAP
author:
  - m1cr0man
  - graggle
id: ldap
---

# LDAP

LDAP is our directory service. It stores usernames, passwords, UIDs, quotas, and other user specific info.

LDAP's structure is different to most other database systems. If you are not familiar with it, I recommend investing some time into looking at how schemas and distinguished names work.

## Deployment

- OpenLDAP is deployed with Nomad to Aperture
- Unlike most services it is specifically assigned to Glados, rather than dynamically assigned. This is so that it always has a static ip address.
- All LDAP data is stored at `/storage/nomad/openldap`
- The majority of all LDAP operations are handled by the [admin API](api.md).
- Our LDAP structure can be viewed, and to a limited degree interacted with, using the [LDAP Account Manager](https://ldap.rb.dcu.ie), the login information for which is in the password vault.

## Redbrick Special Notes

- The admin user password is in the password vault. It should not be used directly as a bind dn, we prefer the use of service accounts for them
- Service accounts, unlike normal user accounts, cannot be managed by the API. The best way to manage them is using [LAM](https://ldap.rb.dcu.ie).
- At the time of writing most of our services are not configured to use TLS with LDAPS. LDAPS does work, however, it is only configured for use with sssd on the [login boxes](../hardware/login/index.md)
- Storage quotas are managed by a python script that runs once every hour. It gets user quotas from LDAP and sends them to the TrueNAS API to apply restrictions on the `home` and `webtree` datasets by uid number.

## LDAP Commands

While we primarily use the API for LDAP operations, these commands may come in useful. These commands were for a previous version of our LDAP schema and may not work as-is.

### Ldapsearch Recipes

```bash
# Dump the entire LDAP database in LDIF form, which can be used as a form of backup
ldapsearch -b o=redbrick -xLLL -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt

# Find a user by name, and print their altmail
ldapsearch -b o=redbrick -xLLL -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt uid=m1cr0man altmail

# Find quotas for all users edited by m1cr0man
ldapsearch -b o=redbrick -xLLL updatedby=m1cr0man quota

# Find all member's usernames
ldapsearch -b o=redbrick -xLLL objectClass=member uid

# Find all expired users. Notice here that you can query by hidden fields, but you can't read them
ldapsearch -b o=redbrick -xLLL 'yearsPaid < 1' uid
```

### Ldapmodify Recipes

You can instead pass a file with `-f` when necessary.

To test a command add `-n` for no-op mode.

Changing `updatedby` and `updated` is added to each command as good practise.

```bash
# Add quota info to a user
ldapmodify -x -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt << EOF
dn: uid=testing,ou=accounts,o=redbrick
changetype: modify
add: quota
quota: 3G
-
replace: updatedby
updatedby: $USER
-
replace: updated
updated: $(date +'%F %X')
EOF

# Change a user's shell
ldapmodify -x -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt << EOF
dn: uid=testing,ou=accounts,o=redbrick
changetype: modify
replace: loginShell
loginShell: /usr/local/shells/disusered
-
replace: updatedby
updatedby: $USER
-
replace: updated
updated: $(date +'%F %X')
EOF

# Update yearsPaid
ldapmodify -x -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt << EOF
dn: uid=testing,ou=accounts,o=redbrick
changetype: modify
replace: yearsPaid
yearsPaid: 1
-
replace: updatedby
updatedby: $USER
-
replace: updated
updated: $(date +'%F %X')
EOF
```

### Ldapadd Recipes

Occasionally you'll need to add people or things to ldap manually, such as a user you're recreating from backups, or a reserved system name such as a new machine. This is where ldapadd comes in.

```bash
# Create a file to read the new entry from
cat > add.ldif << EOF
dn: uid=redbrick,ou=reserved,o=redbrick
uid: redbrick
description: DNS entry
objectClass: reserved
objectClass: top
EOF

# Import the ldif
ldapadd -x -D cn=root,ou=ldap,o=redbrick -y /path/to/passwd.txt -f add.ldif

# Note if you are importing a full ldif onto a new server, use slapadd instead
# Ensure slapd is not running first
slapadd -v -l backup.ldif
```
