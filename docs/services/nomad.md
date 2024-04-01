---
title: Nomad
author:
  - distro
  - wizzdom
tags:
  - nomad
  - aperture
---

# Nomad - `distro`, `wizzdom`

> Adapted from [redbrick/nomad README](https://github.com/redbrick/nomad/README.md)

## What is Nomad?

Good question!

> Nomad is a simple and flexible scheduler and orchestrator to deploy and manage
> containers and non-containerized applications
> \- [Nomad Docs](https://developer.hashicorp.com/nomad)

## Deploying a Nomad Job

All Nomad job related configurations are stored in the `nomad` directory.

The terminology used here is explained [here](https://developer.hashicorp.com/nomad/tutorials/get-started/get-started-vocab). This is **required reading**.

- Install Nomad on your machine [here](https://developer.hashicorp.com/nomad/docs/install)
- Clone this repo

```bash
git clone git@github.com:redbrick/nomad.git
```

- Connect to the [admin VPN](../procedures/vpn.md)
- Set the `NOMAD_ADDR` environment variable:

```bash
export NOMAD_ADDR=http://<IP-ADDRESS-OF-HOST>:4646
```

- Check you can connect to the nomad cluster:

```bash
nomad status
```

- You should receive a list back of all jobs, now you are ready to start deploying!

```bash
nomad job plan path/to/job/file.hcl
```

This will plan the allocations and ensure that what is deployed is the correct version.

If you are happy with the deployment, run

```bash
nomad job run -check-index [id from last command] path/to/job/file.hcl
```

This will deploy the planned allocations, and will error if the file changed on disk between the plan and the run.

You can shorten this command to just

```bash
nomad job plan path/to/file.hcl | grep path/to/file.hcl | bash
```

This will plan and run the job file without the need for you to copy and paste the check index id. Only use this once you are comfortable with how Nomad places allocations.

## Restart a Nomad Job

- First, stop and purge the currently-running job

```bash
nomad job stop -purge name-of-running-job
```

- Run a garbage collection of jobs, evaluations, allocations, nodes and reconcile summaries of all registered jobs.

```bash
nomad system gc

nomad system reconcile summaries

nomad system gc # (yes, again)
```

- Plan and run the job

```bash
nomad job plan path/to/job/file.hcl

nomad job run -check-index [id from last command] path/to/job/file.hcl
```

## Exec into Container

At times it is necessary to exec into a docker container to complete maintenance, perform tests or change configurations. The syntax to do this on nomad is similar to `docker exec` with some small additions:

```bash
nomad alloc exec -i -t -task <task-name> <nomad-alloc-id> <command>
```

Where:

- `<task-name>` is the name of the task you want to exec into *(only needed when there is more than one task in job)*
- `<nomad-alloc-id>` is the id for the currently running allocation, obtained from the web UI, nomad CLI, or nomad API
- `<command>` is the command you want to run. e.g. `sh`, `rcon-cli`

## Cluster Configuration

[`nomad/cluster-config`](https://github.com/redbrick/nomad/tree/master/cluster-config) contains configuration relating to the configuration of the cluster including:

- [Node Pools](#node-pools)
- agent config

### Node Pools

[Node pools](https://developer.hashicorp.com/nomad/docs/concepts/node-pools) are a way to group nodes together into logical groups which jobs can target that can be used to enforce where allocations are placed.

e.g. [`ingress-pool.hcl`](https://github.com/redbrick/nomad/blob/master/cluster-config/ingress-pool.hcl) is a node pool that is used for ingress nodes such as the [bastion-vm](bastion-vm). Any jobs that are defined to use `node_pool = "ingress"` such as `traefik.hcl` and `gate-proxy.hcl` will only be assigned to one of the nodes in the `ingress` node pool (i.e. the [bastion VM](bastion-vm))
