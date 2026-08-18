---
id: api
aliases:
  - Redbrick Administrative Web API
tags:
  - services
  - api
  - ldap
created: 2021-08-13T23:28:49
modified: 2026-08-18T10:01:49
title: Admin API
---

# Redbrick Administrative Web API

The source code for the API can be found [here](https://github.com/redbrick/api/). The repository is private and accessible only to committee.

The Redbrick web API serves as an easy interface to carry out administrator tasks *(mainly LDAP related)*, and for use in automation. This saves time instead of accessing machines, and formulating and executing manual LDAP queries or scripts.

The API is hosted on [`aperture`](../hardware/aperture/index.md) in a docker container deployed with [`nomad`](nomad.md), the job is deployed automatically by github workflows and to trigger redeployment the action needs to be re-run. It is written in Python with [FastAPI](https://fastapi.tiangolo.com/). This container is then served to the public using [`traefik`](traefik.md).

## Nomad Job File

The [nomad job for Redbrick's API](https://github.com/redbrick/nomad/blob/master/jobs/services/api.hcl) is used as a template for deployment by github workflows and attempting to deploy the template directly **will not work.** This uses a similar system to [atlas](https://docs.redbrick.dcu.ie/webgroup/atlas/) and [blockbot](https://docs.redbrick.dcu.ie/webgroup/blockbot/). To redeploy the API you need to trigger the deployment workflow. The production deployment workflow will run if it's triggered in the master branch, and the review deployment will run in any other branch.

- The docker image on ghcr.io is private and therefore requires credentials to access.

```hcl title="Nomad"
auth {
    username = "${DOCKER_USER}"
    password = "${DOCKER_PASS}"
}
```

```hcl title="Nomad"
      template {
        destination = "local/.env"
        env         = true
        change_mode = "restart"
        data        = <<EOH
DOCKER_USER={{ key "api/ghcr/username" }}
DOCKER_PASS={{ key "api/ghcr/password" }}
...
EOH
```

- The api must have access to the `home` and `webtree` shares on [`mirage`](../hardware/storage/mirage.md) (or it's backup, [`anubis`](../hardware/storage/anubis.md)) to configure users' home and webtree directories. This is mounted onto the [`aperture`](../hardware/storage/mirage.md) boxes at `/storage/home` and `/storage/webtree` and is mounted to the containers like this:

```hcl title="Nomad"
        volumes = [
          "/storage/webtree:/storage/webtree",
          "/storage/home:/home",
          "/storage/nomad/api/data:/data",
        ]
```

- The container is not very RAM intensive, regularly using `90-100MB`. The job has been configured to allocate `1GB` RAM to the container so it does not OOM. The default `cpu` allocation of `300` is fine.

```hcl title="Nomad"
resources {
    cpu = 300
    memory = 1024
    }
```

## Reference

All endpoints, as well as the parameters and responses for them are documented at [https://api.redbrick.dcu.ie/docs](https://api.redbrick.dcu.ie/docs).

Most endpoints require [HTTP basic auth](https://docs.python-requests.org/en/master/user/authentication/#basic-authentication) to use them. There is a default admin account with the username `root` and a password that is stored in the `root` folder in [vaultwarden](./vaultwarden.md). This user has permissions for every endpoint, and so should not be used in any service that requires access to the API.

Instead, you should create an account with the specific permissions you need for that service. You can do this by going onto the allocation for the API on [nomad](./nomad.md) and execing into the allocation with a shell. You can then run `python -m app account -h` to see a list of commands for account creation and management.

```
Select a task to start your session.

Customize your command, then hit ‘return’ to run.

$ nomad alloc exec -i -t -task api b8395f6f /bin/sh
/usr/src # python -m app account -h
Usage:
    python -m app account register <username> <description>
    python -m app account delete <username>
    python -m app account list
    python -m app account permission add <username> <permission>
    python -m app account permission remove <username> <permission>
    python -m app account permission list <username>

Example:
    python -m app account permission add blockbot admin:getuser,admin:updateuser
/usr/src # 
```

Valid permissions include `admin:getuser` for the admin get user endpoints, `admin:updateuser` for any endpoints that modify user LDAP data, `admin:registeruser` for creating new LDAP users and `admin:deleteuser` for deleting LDAP users. Any of the commands that take permissions as an input support comma seperated lists of permissions for bulk operations.


## Important Notes and Caveats

While the API can be used to change a users name on LDAP, it is not recommended to do so. This has caused issues in the past, so the better way is to simply delete the users old account and make a new one, and manually move the old home and webtree directories.