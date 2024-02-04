# Nomad on Aperture - `distro`, `wizzdom`

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

- Connect to the [admin VPN](vpn.md)
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

- Run a garbage collection of jobs, evaluations, allocations, and nodes ad reconcile summaries of all registered jobs.

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
