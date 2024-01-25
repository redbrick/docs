# CodiMD - `distro`

CodiMD lives on [`zeus`](../hosts/zeus.md) as a docker container. It is accessible through [md.redbrick.dcu.ie](https://md.redbrick.dcu.ie).

CodiMD is built locally and is based on [codimd](https://github.com/hackmdio/CodiMD), the docs for which are [here](https://hackmd.io/c/codimd-documentation/%2Fs%2Fcodimd-docker-deployment).

Hackmd auths against LDAP and its configuration is controlled from docker-compose. Go to `/etc/docker-compose/services/hackmd` on [`zeus`](../hosts/zeus.md) to find the configuration.

See [CodiMD github](https://github.com/hackmdio/hackmd/#environment-variables-will-overwrite-other-server-configs) for more info on configuration. 
The important points are disabling anonymous users and the LDAP settings.
