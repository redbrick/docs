---
title: Wetty
created: 2024-07-16T23:52:13
modified: 2024-07-18T23:08:33
tags:
  - aperture
  - nomad
  - docker
author:
  - wizzdom
---

# Wetty - `wizzdom`

Redbrick uses [Wetty](https://github.com/butlerx/wetty) as our web terminal of choice. It is accessible at [wetty.redbrick.dcu.ie](https://wetty.redbrick.dcu.ie), [wetty.rb.dcu.ie](https://wetty.rb.dcu.ie),[term.redbrick.dcu.ie](https://term.redbrick.dcu.ie), [anyterm.redbrick.dcu.ie](https://anyterm.redbrick.dcu.ie) and [ajaxterm.redbrick.dcu.ie](https://ajaxterm.redbrick.dcu.ie).

*Why all the different domains?* - ***For legacy reasons!*** 

The configuration is located [here](https://github.com/redbrick/nomad/blob/master/jobs/services/wetty.hcl)

The configuration for Wetty is pretty straightforward:

- `SSHHOST` - the host that Wetty will connect to (one of the [Login](servers.md#Logging%20in) boxes), defined in [`consul`](consul.md)
- `SSHPORT` - the port used for ssh
- `BASE` - the base path for Wetty (default is `/wetty`)
	- *This isn't very well documented but trust the process. It works!!*

```hcl title="Nomad"
SSHHOST={{ key "wetty/ssh/host" }}
SSHPORT=22
BASE=/
```
