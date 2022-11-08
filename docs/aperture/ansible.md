# Ansible

Redbrick uses ansible to manage its infrastructure. This document describes the procedures and some tips to get the most
out of it.

## Getting started

### Installing ansible

Ansible is a python package, so you'll need to install python first. On Debian/Ubuntu, you can do this with:

```bash
pip install ansible
```

### Add an SSH key

Ansible uses ssh to connect to the remote hosts. You'll need to set up your ssh key so that you can connect to the hosts
without constant prompts for passwords.

### Create a hosts file

This is used a phonebook of sorts for ansible. It tells ansible which hosts to connect to, and what user to use.

```ini
[aperture]
glados
wheatley
chell

[aperture:vars]
ansible_user= <your username>
```

### Test it out

```bash
ansible all -m ping
```

This should connect to all the hosts in the `aperture` group, and run the `ping` module. If it works, you're good to go!

## Playbooks

Ansible playbooks are a set of instructions for ansible to run. They're written in YAML, and are usually stored in a file
called `playbook.yml`.

### Writing a playbook

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
- hosts: aperture
  tasks:
    - name: Install curl
      apt:
        name: curl
        state: present
```

This playbook will connect to all the hosts in the `aperture` group, and run the `apt` module with the `name` and `state`
options.

### Running a playbook

```bash
ansible-playbook playbook.yml -i hosts
```

## More Information

Redbrick's ansible configuration is stored in the [ansible](https://github.com/redbrick/ansible) repository. There's
some more documentation there on each playbook.

Ansible's documentation is available [here](https://docs.ansible.com/ansible/latest/index.html).
