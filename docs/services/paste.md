---
title: Pastebin
author:
  - wizzdom
tags:
  - aperture
  - nomad
  - docker
---

# Pastebin - `wizzdom`

Redbrick currently uses [Privatebin](https://github.com/PrivateBin/PrivateBin) as a paste utility accessible at [paste.redbrick.dcu.ie](https://paste.redbrick.dcu.ie) and [paste.rb.dcu.ie](https://paste.rb.dcu.ie)

## Privatebin

The Privatebin instance is deployed with [nomad](nomad.md) on [`aperture`](../hardware/aperture/index.md). Its configuration is available [here](https://github.com/redbrick/nomad/blob/master/jobs/services/privatebin.hcl). Privatebin doesn't support full configuration via environment variables but instead uses a `conf.php` file. This is passed in using [nomad templates](https://developer.hashicorp.com/nomad/docs/job-specification/template).

All sensitive variables are stored in the [`consul`](consul.md) KV store. 

The main points are as follows:

- configure URL shortener ([`shlink`](shlink.md))

```php
urlshortener = "https://s.rb.dcu.ie/rest/v1/short-urls/shorten?apiKey={{ key "privatebin/shlink/api" }}&format=txt&longUrl="
```

- enable file upload, set file size limit and enable compression

```php
fileupload = true
sizelimit = 10485760
compression = "zlib"
```

- Connect to PostgreSQL database

```php
[model]
class = Database
[model_options]
dsn = "pgsql:host=postgres.service.consul;dbname={{ key "privatebin/db/name" }}"
tbl = "privatebin_"     ; table prefix
usr = "{{ key "privatebin/db/user" }}"
pwd = "{{ key "privatebin/db/password" }}"
opt[12] = true    ; PDO::ATTR_PERSISTENT ; use persistent connections - default
```
