# Nomad on Aperture - `distro`, `wizzdom`

> Adapted from the [redbrick/nomad repo's README](https://github.com/redbrick/nomad/README.md)

## What is Nomad?

Good question!

> Nomad is a simple and flexible scheduler and orchestrator to deploy and manage
> containers and non-containerized applications
> \- [Nomad Docs](https://developer.hashicorp.com/nomad)

## Deploying a Nomad Job

All Nomad job related configurations are stored in the `nomad` directory.

The terminology used here is explained [here](https://developer.hashicorp.com/nomad/tutorials/get-started/get-started-vocab). This is **required reading**.

All of the job files are stored in the `nomad` directory. To deploy a Nomad job manually, connect to a host and run

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

```bash
nomad job stop -purge name-of-running-job
```

```bash
nomad system gc
```

```bash
nomad system reconcile summaries
```

```bash
nomad system gc # (yes, again)
```

```bash
nomad job plan path/to/job/file.hcl
```
