---
id: post-powercut
aliases:
  - Post-powercut Todo List
tags:
  - powercut
  - todo
created: 2023-12-05T01:36:11
modified: 2026-06-18T13:24:57
title: Post-powercut Todo List
---

# Post-Powercut Verification Checklist

A list of things that should be done/checked immediately after a power cut:

> [!NOTE] Note!
> An announcement should be made in the Redbrick Discord server to notify members that a power cut has occurred and that the team is working on restoring services.

## 1. Network & VLAN Verification

Run these baseline commands on each [`aperture`](../hardware/aperture/index.md) server to refresh the network states and make sure that all bridges are up and running correctly:
```bash
sudo systemctl daemon-reload
sudo systemctl restart networking
```

### IP Address & Bridge Validation
Ensure all [`aperture`](../hardware/aperture/index.md) servers have their correct IP addresses across **vlan16**, **vlan10**, **vlan30**, and **vlan40**.

#### For [`glados`](../hardware/aperture/glados.md):
* Verify `br0` is up.
* Verify `br0` holds the vlan16 IP: `136.206.16.4`
* Verify `br0` holds the Keepalived IP: `136.206.16.50`

### Troubleshooting Network Bridges

* **If `br0` is down**, force the link:
  ```bash
  sudo ip link set vlan16 master br0
  ```

* **Verify VM communication** link by checking if `br0` is linked to `vnet0` and `vlan16`:
  ```bash
  sudo brctl show br0
  ```

* **If `br0` lacks a link to `vnet0`**, manually bridge them:
  ```bash
  sudo brctl addif br0 vnet0
  ```
  **Note:** You must restart any VMs running on that host after running this command to restore their connectivity.

---

## 2. Storage Mounts

Verify that shared storage is attached before checking any Nomad jobs.

1. Access each [`aperture`](../hardware/aperture/index.md) server.
2. Force mount all entries:
   ```bash
   sudo mount -a
   ```
3. Confirm `/storage` is mounted correctly. 
4. *If mounting fails, inspect `/etc/fstab` for issues.*

---

## 3. Nomad Workloads

If Nomad jobs started while `/storage` was unmounted, they will be in a broken state and must be restarted.

Run this loop script to automatically reschedule and fix all active Nomad jobs on the host:
```bash
for job in \$(nomad job status | awk 'NR>1 {print \$1}'); do
    echo "Rescheduling job to fix storage: \$job"
    nomad job restart -reschedule "\$job"
done
```

---

## 4. System Time Verification

Ensure you have the correct time on each server.

* Check current system time:
  ```bash
  date
  ```

## 5. Debug current services.

Some services might be in a corrupted or unstable state, especially if they are running with databases like PostgreSQL. Check the status of all services and restart any that are not running correctly.

One useful step is to run pg_resetwal on those databases to reset the write-ahead log and restore them to a consistent state. This should be done with caution and ideally after taking a backup of the database.

```bash
sudo docker run --rm -u <userid> -v "$(pwd)/db:/var/lib/postgresql/data" postgres:17-alpine pg_resetwal -f /var/lib/postgresql/data
```

