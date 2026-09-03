---
id: gate
aliases:
  - Gate
tags: []
created: 2026-09-03T12:00:14
modified: 2026-09-03T21:17:25
title: Gate
---

# Gate

Gate is our reverse proxy for minecraft. It allows us to run multiple minecraft servers using just one exposed port. It is configured to automatically proxy any job thats name has the prefix `minecraft-`. Because of this it is very rare that you will need to touch it's configuration.