# Icecast

Icecast is a streaming server that we currently host on aperture.

We stream DCUFm's Broadcasts to their apps via a stream presented on `dcufm.redbrick.dcu.ie`.

## Procedure

The configuration file for icecast is located in the [nomad config repo](https://github.com/redbrick/nomad).

It should just be a case of running `nomad job plan clubs-socs/dcufm.hcl` to plan and run the job.

## Streaming to Icecast

DCUfm use [butt](https://danielnoethen.de/butt/) on a desktop in their studio to stream to Icecast.

The desktop must be connected to the vpn to ensure the stream stays up, and traefik doesn't reset the connection every
10 seconds. The current icecast configuration for the server is 10.10.0.5:2333. Read more about it in [this issue](https://github.com/redbrick/issue-tracker/issues/4).
