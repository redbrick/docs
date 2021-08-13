# API

## Redbrick Administrator Web API

The Redbrick web API serves as an easy interface to carry out administrator tasks (mainly LDAP related), and for use in automation. 

This saves time instead of accessing machines, and formulating and executing manual LDAP queries or scripts.

The server code for the API is hosted on Zeus in a docker container called 'api-redbrick', written in Python with [FastAPI](https://fastapi.tiangolo.com/).

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

&emsp;