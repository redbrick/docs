---
title: plausible
created: 2024-07-26T23:26:42
modified: 2024-08-07T22:45:27
tags:
  - aperture
  - nomad
  - docker
aliases:
  - Plausible - `wizzdom`
author:
  - wizzdom
id: plausible
---

# Plausible - `wizzdom`

Plausible Analytics is a privacy-friendly analytics software. It is deployed with [nomad](nomad.md) on [`aperture`](../hardware/aperture/index.md) as a docker container and is accessible at [plausible.redbrick.dcu.ie](https://plausible.redbrick.dcu.ie).

## Configuration

Redbrick's configuration for plausible is available [here](https://github.com/redbrick/nomad/blob/master/jobs/services/plausible.hcl).

See the [Plausible docs](https://github.com/plausible/community-edition/) for more information on configuration

## Adding Users

Since registrations are disabled from the web UI, users can only be added from the CLI.

To add a new user, [exec](nomad.md#exec-into-container) into the `plausible` container, run `/app/bin/plausible remote` and register the user by filling in the following:

```ex
Plausible.Auth.User.new(%{name: "Test name", email: "test@redbrick.dcu.ie", password: "SuperSecurePassword", password_confirmation: "SuperSecurePassword" }) |> Plausible.Repo.insert
```

## Import/Export Data

- [Exec](nomad.md#Exec-into-Container) into the `clickhouse` container

- verify `plausible_events_db` exists

```bash
clickhouse-client --query "SHOW DATABASES"
```

- verify the tables exist in the db

```bash
clickhouse-client --database="plausible_events_db" --query="SHOW TABLES"
```

- backup the `events` and `sessions` tables from `plausible_events_db`

```bash
clickhouse-client --database="plausible_events_db" --query="SELECT * FROM events FORMAT TSV" > /var/lib/clickhouse/backup/backup_events.tsv
clickhouse-client --database="plausible_events_db" --query="SELECT * FROM sessions FORMAT TSV" > /var/lib/clickhouse/backup/backup_sessions.tsv
```


# plausible data location
has to be owned by:
```bash
chown -R 999:nogroup
```