---
title: API
tags:
  - services
  - api
  - ldap
---

# Redbrick Administrative Web API

The source code for the API can be found [here](https://github.com/redbrick/api/).

The Redbrick web API serves as an easy interface to carry out administrator tasks *(mainly LDAP related)*, and for use in automation. This saves time instead of accessing machines, and formulating and executing manual LDAP queries or scripts.

The server code for the API is hosted on [`aperture`](../hardware/aperture/index.md) in a docker container deployed with [`nomad`](nomad.md), the job file for which is [here](https://github.com/redbrick/nomad/blob/master/jobs/services/api.hcl). It is written in Python with [FastAPI](https://fastapi.tiangolo.com/). This container is then served to the public using [`traefik`](traefik.md).

## Nomad Job File

The [nomad job for Redbrick's API](https://github.com/redbrick/nomad/blob/master/jobs/services/api.hcl) is similar to most other web servers for the most part. As always, all secrets are stored in [`consul`](consul.md). Some things to watch out for are:

- The docker image on ghcr.io is private and therefore requires credentials to access.

```hcl title="Nomad"
auth {
    username = "${DOCKER_USER}"
    password = "${DOCKER_PASS}"
}
```

```hcl title="Nomad"
template {
  data        = <<EOH
DOCKER_USER={{ key "api/ghcr/username" }}
DOCKER_PASS={{ key "api/ghcr/password" }}
...
EOH
```

- The docker container must access `/home` and `/storage` on [`icarus`](../hardware/nix/icarus.md) to configure users' home directory and webtree. This is mounted onto the [`aperture`](../hardware/aperture/index.md) boxes at `/oldstorage` and is mounted to the containers like this:

```hcl title="Nomad"
volumes = [
          "/oldstorage:/storage",
          "/oldstorage/home:/home",
]
```

- The container requires the LDAP secret at `/etc/ldap.secret` to auth with LDAP. This is stored in [`consul`](consul.md), placed in a template and mounted to the container like this:

```hcl title="Nomad"
template {
    destination = "local/ldap.secret"
    data = "{{ key \"api/ldap/secret\" }}" # this is necessary as the secret has no EOF
    }
```

- The container is quite RAM intensive, regularly using `700-800MB`. The job has been configured to allocate `1GB` RAM to the container so it does not OOM. The default `cpu` allocation of `300` is fine.

```hcl title="Nomad"
resources {
    cpu = 300
    memory = 1024
    }
```

## Reference

For the most up to date, rich API reference please visit [https://api.redbrick.dcu.ie/docs](https://api.redbrick.dcu.ie/docs)

All requests are validated with Basic Auth for access. [See example.](https://docs.python-requests.org/en/master/user/authentication/#basic-authentication)

| Method |         Route         |         URL Parameters         |     Body     |
| :----: | :-------------------: | :----------------------------: | :----------: |
|  GET   | **/users/**`username` | `username` - Redbrick username |     N/A      |
|  PUT   | **/users/**`username` | `username` - Redbrick username |  `ldap_key`  |
|  POST  |  **/users/register**  |              N/A               | `ldap_value` |

## Examples

- `GET` a user's LDAP data

```python
import requests

url = "https://api.redbrick.dcu.ie/users/USERNAME_HERE"

headers = {
  'Authorization': 'Basic <ENCODED_USERANDPASS_HERE>'
}

response = requests.request("GET", url, headers=headers)

print(response.text)
```

- `PUT` a user's LDAP data to change their `loginShell` to `/usr/local/shells/zsh`

```python
import requests
import json

url = "https://api.redbrick.dcu.ie/users/USERNAME_HERE"
payload = json.dumps({
  "ldap_key": "loginShell",
  "ldap_value": "/usr/local/shells/zsh"
})
headers = {
  'Authorization': 'Basic <ENCODED_USERANDPASS_HERE>',
  'Content-Type': 'application/json'
}

response = requests.request("GET", url, headers=headers, data=payload)

print(response.text)
```

## Important Notes and Caveats

As the FastAPI server for the API is hosted inside of a Docker container, there are limitations to the commands we can execute that affect the "outside" world.

*This is especially important with commands that rely on LDAP.* 

For example inside the `ldap-register.sh` script used by the `/register` endpoint.

- Commands like `chown` which require a user group or user to be passed to them will not work because they cannot access these users/groups in the container.

- This is prevalent in our implementation of the API that creates and modifies users' `webtree` directory.

*How do we fix this?*

Instead of relying on using users/group names for the `chown` command, it is advisable to instead use their unique id's. 

```bash
# For example, the following commands are equivalent.
chown USERNAME:member /storage/webtree/U/USERNAME

chown 13371337:103 /storage/webtree/U/USERNAME
# Where 13371337 is userid and 103 is the id for the 'member' group.
```

> Note that `USERNAME` can be used to refer to the user's web directory here since it is the name of the directory and doesn't refer to the user object.
