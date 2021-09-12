# API

## Redbrick Administrator Web API

The source code for the API can be found [here](https://github.com/redbrick/api/).

The Redbrick web API serves as an easy interface to carry out administrator tasks (mainly LDAP related), and for use in automation. 

This saves time instead of accessing machines, and formulating and executing manual LDAP queries or scripts.

The server code for the API is hosted on Zeus in a docker container called 'api-redbrick', written in Python with [FastAPI](https://fastapi.tiangolo.com/).
This container is then served to the public using traefik, you can view the dashboard [here](https://traefik.zeus.redbrick.dcu.ie/dashboard/#/).

### Reference

For the most up to date, rich API reference please visit [https://api.redbrick.dcu.ie/docs](https://api.redbrick.dcu.ie/docs)

All requests are validated with Basic Auth for access. [See example.](https://docs.python-requests.org/en/master/user/authentication/#basic-authentication)


|   Method   |         Route          |           URL Parameters             |        Body       |
| :--------: | :--------------------: | :----------------------------------: | :---------------: |
|  GET       |  **/users/**`username` | `username` - Redbrick username       | N/A               |
|  PUT       |  **/users/**`username` | `username` - Redbrick username       | `ldap_key`   |
|  POST      |  **/users/register**   | N/A                                  | `ldap_value` |

#### Examples

GET a user's LDAP data
```python
import requests

url = "https://api.redbrick.dcu.ie/users/USERNAME_HERE"

headers = {
  'Authorization': 'Basic <ENCODED_USERANDPASS_HERE>'
}

response = requests.request("GET", url, headers=headers)

print(response.text)
```

PUT a user's LDAP data to change their `loginShell` to `/usr/local/shells/zsh`
```python
import requests
import json

url = "https://api.redbrick.dcu.ie/users/USERNAME_HERE"
payload = json.dumps({
  "ldap_key": "loginShell",
  "ldap_value": "/usr/local/shells/zsh"
})
headers = {
  'Authorization': 'Basic <ENCODED_USERANDPASS_HERE>',
  'Content-Type': 'application/json'
}

response = requests.request("GET", url, headers=headers, data=payload)

print(response.text)
```

### Important Notes and Caveats

As the FastAPI server for the API is hosted inside of a Docker container, there are limitations to the commands we can execute that affect the "outside" world.

*This is especially important with commands that rely on LDAP.* 

For example inside the `ldap-register.sh` script used by the `/register` endpoint.

- Commands like `chown` which require a user group or user to be passed to them will not work because they cannot access these users/groups in the container.

- This is prevalent in our implementation of the API that creates and modifies users' `webtree` directory.

As a result, the API has a hard dependancy on manually granting the user permissions to their webtree directory - when the `webtree` dir is created it is owned by root.

**Why not just do this inside** `/scripts/ldap-register.sh`?

- The creation of the `webtree` directory for the user requires `chown` to be run, to give the user permissions for their respective directory (i.e `/storage/webtree/U/USER_NAME`)

- In the command `chown USER_NAME:member /storage/webtree/U/USER_NAME`, the `USER_NAME:member` arg is dependant on the LDAP user and group (member) being available. 

- This is not possible inside the docker container.

For this reason, the webtree permissions portion of `/register` is outsourced to being done manually (usually at the same time as when an account is created).

A possible current solution is to run this permissions updating on a job at some interval, and setting permissions for anyone with 'NEWBIE: TRUE' in their ldap data.


&emsp;