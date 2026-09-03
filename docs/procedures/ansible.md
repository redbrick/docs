---
id: ansible
aliases:
  - Ansible
tags: []
created: 2022-11-08T04:34:34
modified: 2026-09-03T21:17:25
title: Ansible
---
# Ansible

Redbrick maintains some ansible scripts that make some tasks easier.

## Getting Started

### Installing Ansible

You can install ansible using your package manager of choice. Because ansible is a python package it can also be installed using `pip` or `uv`.
### Add an SSH Key

Ansible uses ssh to connect to the remote hosts. You'll need to set up your ssh key so that you can connect to the hosts without constant prompts for passwords.

### Create a Hosts File

This is used a phonebook of sorts for ansible. It tells ansible which hosts to connect to, and what user to use.

```ini
glados ansible_host=10.10.10.4
wheatley ansible_host=10.10.10.5
chell ansible_host=10.10.10.6

[nomad]
glados
wheatley
chell
```

### Test it out

```bash
ansible all -m ping
```

This should connect to all the hosts in the `aperture` group, and run the `ping` module. If it works, you're good to go!

## Playbooks

Ansible playbooks are a set of instructions for ansible to run. They're written in YAML, and are usually stored in a file called `playbook.yml`.

### Writing a Playbook

Ansible playbooks are written in YAML. The basic structure is:

```yaml
- hosts: <group name>
  tasks:
    - name: <task name>
      <module name>:
        <module options>
```

#### Example

```yaml
- hosts: nomad
  tasks:
    - name: Install curl
      apt:
        name: curl
        state: present
```

This playbook will connect to all the hosts in the `aperture` group, and run the `apt` module with the `name` and `state` options.

### Running a Playbook

```bash
ansible-playbook playbook.yml -i hosts
```

## More Information

Redbrick's ansible configuration is stored in the [ansible](https://github.com/redbrick/nomad/tree/master/ansible) folder in the `redbrick/nomad` repository. There's some more documentation there on each playbook.

Ansible's documentation is available [here](https://docs.ansible.com/ansible/latest/index.html).

## Common Errors

### Hashicorp Apt Key

Sometimes, when running a playbook, you'll get an error like this:

```bash
TASK [apt : apt update packages to their latest version and autoclean] ***************************************************************************************************
fatal: [wheatley]: FAILED! => {"changed": false, "msg": "Failed to update apt cache: unknown reason"}
fatal: [chell]: FAILED! => {"changed": false, "msg": "Failed to update apt cache: unknown reason"}
fatal: [glados]: FAILED! => {"changed": false, "msg": "Failed to update apt cache: unknown reason"}
```

This is because the Hashicorp apt key has expired. To fix this, uncomment the `hashicorp-apt` task in the playbook.
