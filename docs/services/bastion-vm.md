# Bastion VM

This VM is an ephemeral machine that can be placed on any nomad client that has the qemu driver enabled.

It acts as the point of ingress for Aperture, with ISS and our [mordor](../hardware/network/mordor.md) allowing traffic to reach it's IP address externally. The VM is configured as a Nomad client itself, in the `ingress` node pool to ensure that only ingress-type allocations are placed there (like [traefik](./traefik.md)). Those services can proxy requests from the Bastion VM to internal services using consul's service DNS resolution, it's service mesh, or by plain IP and port.

`cloud-init` is given a static address during the initialisation phase to configure the interface. This ensures that, even if it is replanned, it will be able to accept traffic.

The base image that the VM uses is a Debian 12 qcow file. After all configuration was done, the size of the image is `~3.2GB`. The image can be used to create replicas of the ingress on other external IP addresses, creating more availability if needed.

## Steps to Deploy

You'll need to ensure the hosts have a bridge device configured to ensure that the networking aspect of the VM can function. See the[`redbrick/nomad`](https://github.com/redbrick/nomad) repo for more information about the steps needed for that.

You'll need a webserver to serve the `cloud-init` configs. There may be another solution to this in the near future, but for now, `wheatley:/home/mojito/tmp/serve` contains the configurations.

Plan the Nomad job and wait for the allocation to be created. If you used the correct image (for example a backup of the qcow file) the virtual machine should be configured and should connect as normal to the Consul and Nomad clusters and become eligible for allocations. If you started from scratch, then use the `ansible/redbrick-ansible.yml` playbook in the [`redbrick/nomad`](https://github.com/redbrick/nomad) repo and ensure that the `hosts` file is up to date.

For security's sake, there is no root login and no user accounts on the bastion VM. This is an attempt to make the node more secure. If you need to make changes, you should change the base image and apply that. The less vulnerabilities that are discovered on the bastion VM, the happier we can keep ISS and the safer Redbrick will be.
