---
title: HedgeDoc
author:
  - wizzdom
tags:
  - aperture
  - nomad
  - docker
---

# HedgeDoc - `wizzdom`

HedgeDoc is deployed with [nomad](nomad.md) on [`aperture`](../hardware/aperture/index.md) as a docker container. It is accessible through [md.redbrick.dcu.ie](https://md.redbrick.dcu.ie).

HedgeDoc auths against LDAP and its configuration is available [here](https://github.com/redbrick/nomad/blob/master/jobs/services/hedgedoc.hcl)

All sensitive variables are stored in the [`consul`](consul.md) KV store. 

The important points are as follows:

- connecting to the database:

```bash
CMD_DB_URL = "postgres://{{ key "hedgedoc/db/user" }}:{{ key "hedgedoc/db/password" }}@{{ env "NOMAD_ADDR_db" }}/{{ key "hedgedoc/db/name" }}"
```

- disabling anonymous users and email signup:

```bash
CMD_ALLOW_EMAIL_REGISTER = "false"
CMD_ALLOW_ANONYMOUS      = "false"
CMD_EMAIL                = "false"
```

- LDAP configuration:

```bash
CMD_LDAP_URL             = "{{ key "hedgedoc/ldap/url" }}"
CMD_LDAP_SEARCHBASE      = "ou=accounts,o=redbrick"
CMD_LDAP_SEARCHFILTER    = "{{`(uid={{username}})`}}"
CMD_LDAP_PROVIDERNAME    = "Redbrick"
CMD_LDAP_USERIDFIELD     = "uidNumber"
CMD_LDAP_USERNAMEFIELD   = "uid"
```

See the [HedgeDoc docs](https://docs.hedgedoc.org/configuration/) for more info on configuration. 

## Backups

The HedgeDoc database is backed up periodically by a [nomad](nomad.md) job, the configuration for which is [here](https://github.com/redbrick/nomad/blob/master/jobs/services/hedgedoc-backup.hcl).

The bulk of this job is this script which:

- grabs the `alloc_id` of the currently running HedgeDoc allocation from nomad
- execs into the container running `pg_dumpall` dumping the database into a file with the current date and time
- if the backup is unsuccessful the script notifies the admins on discord via a webhook.

```bash
#!/bin/bash

file=/storage/backups/nomad/postgres/hedgedoc/postgresql-hedgedoc-$(date +%Y-%m-%d_%H-%M-%S).sql

mkdir -p /storage/backups/nomad/postgres/hedgedoc

alloc_id=$(nomad job status hedgedoc | grep running | tail -n 1 | cut -d " " -f 1)

job_name=$(echo ${NOMAD_JOB_NAME} | cut -d "/" -f 1)

nomad alloc exec -task hedgedoc-db $alloc_id pg_dumpall -U {{ key "hedgedoc/db/user" }} > "${file}"

find /storage/backups/nomad/postgres/hedgedoc/postgresql-hedgedoc* -ctime +3 -exec rm {} \; || true

if [ -s "$file" ]; then # check if file exists and is not empty
  echo "Backup successful"
  exit 0
else
  rm $file
  curl -H "Content-Type: application/json" -d \
  '{"content": "<@&585512338728419341> `PostgreSQL` backup for **'"${job_name}"'** has just **FAILED**\nFile name: `'"$file"'`\nDate: `'"$(TZ=Europe/Dublin date)"'`\nTurn off this script with `nomad job stop '"${job_name}"'` \n\n## Remember to restart this backup job when fixed!!!"}' \
  {{ key "postgres/webhook/discord" }}
fi
```
