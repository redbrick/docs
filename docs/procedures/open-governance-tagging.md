---
id: open-governance-tagging
aliases:
  - Open Governance Tagging - `hypnoant`, `wizzdom`
tags:
  - open-gov
  - gpg
  - tagging
author:
  - hypnoant
  - wizzdom
created: 2024-05-07T00:23:58
modified: 2024-05-07T00:23:58
title: Open Governance Tagging
---

# Open Governance Tagging - `hypnoant`, `wizzdom`

## 1. Before the Tagging Ceremony

### Generating the Key

To tag the Open Governance repo you will need to make a new PGP key on the behalf of redbrick committee. Below are the commands and the inputs for creating this key.

```bash
gpg --full-generate-key
```

```title="Key Generation Menu"
Please select what kind of key you want:
   (1) RSA and RSA
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (9) ECC (sign and encrypt) *default*
  (10) ECC (sign only)
  (14) Existing key from card
Your selection? 1

RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (3072) 4096

Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) {SET FOR DATE AFTER TAGGING CEREMONY}

Key expires at {DATE AFTER TAGGING CEREMONY} IST
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.
Real name: Redbrick Committee
Email Address: committee@redbrick.dcu.ie
Comment: Redbrick Committee (Redbrick Open Governance {YEAR-MONTH-TYPE_OF_MEETING(AGM/EGM)})

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
```

### First Sign

The signatory who has generated the key will then sign this key.

```bash
gpg --sign-key {REDBRICK KEY-ID}
```

You will then publish this public key to a key-server *(e.g. `keyserver.ubuntu.com` or `keys.openpgp.org`)*.

```bash
gpg --keyserver keyserver.ubuntu.com --send-key committee@redbrick.dcu.ie
```

### Second Sign

The other signatory will pull the key from the key-server and will then sign this key and re-publish the key to the key-server. (You can use the more secure method below for general membership if you wish).

```bash
gpg --keyserver keyserver.ubuntu.com --recv-key {REDBRICK KEY-ID}

gpg --sign-key {REDBRICK KEY-ID}

gpg --keyserver keyserver.ubuntu.com --send-keys {REDBRICK KEY-ID}
```

To verify this procedure has worked and that both signatories have signed it. We will have the first signatory pull the key back down and verify the signatures.

```bash
gpg --keyserver-options no-self-sigs-only --keyserver keyserver.ubuntu.com --recv-key {REDBRICK KEY-ID}
```

### General Membership Sign

The society now has the option to publish this key to the general membership for them to also sign this key if the current committee wishes to do so. The committee will have to release an email address or another service for the general membership to send files to.

Below is the process for a member of the general membership to sign the key.

```bash
gpg --recv-keys {REDBRICK KEY-ID}
gpg --sign-key {REDBRICK KEY-ID}
gpg --armor --export {REDBRICK KEY-ID} | gpg --encrypt -r {REDBRICK KEY-ID} --armor --output {REDBRICK KEY-ID}-signedBy-{OWNER KEY ID}.asc
```

They will then send this file to the signatories.

The signatories will then use the following commands to import and publish their key with the new signature. This must be done before the

```bash
gpg -d {REDBRICK KEY-ID}-signedBy-{OWNER KEY ID}.asc  | gpg --import
gpg --send-key {REDBRICK KEY-ID}
```

## 2. During the Tagging Ceremony

The first signatory shall tag the repository with the following command and styling. There shall be at least 2 witnesses separated by commas.

```bash
git tag -as {YYYY-MM-TYPEOFMEETING} {COMMIT ID}
```

```title="Git Tag Message"
Co-authored-by: {Signatory 2}

Witnessed-by: ~{WITNESS}

See `knowledge/tagging.md` for more info.
```

They can then push this tag to the GitHub

```bash
git push --tags origin
```

## 3. After the Tagging Ceremony

### Verifying the Tag

Clone the git repository

```bash
git clone https://github.com/redbrick/open-governance.git
```

View the tag

```bash
git tag -v {YYYY-MM-TYPEOFMEETING}
```

Import the key

There should be a key signature at the bottom of the tag view. This should be imported into your key-ring. There may be a separate key-server used for the given years key so verify with committee that it is on the correct server for importing.

```bash
gpg --keyserver-options no-self-sigs-only --keyserver keyserver.ubuntu.com --recv-key {REDBRICK KEY-ID}
```

Verify the tag

```bash
git tag -v {YYYY-MM-TYPEOFMEETING}
```

Check the signatories

```bash
gpg --list-sigs {REDBRICK KEY-ID}
```

Import the signatories keys

```bash
gpg --list-sigs {REDBRICK KEY-ID} --keyid-format long | grep 'ID not found' | perl -nwe '/([0-9A-F]{16})/ && print "$1\n"' | xargs gpg --keyserver-options no-self-sigs-only --keyserver keyserver.ubuntu.com  --recv-keys
```

Export their key

```bash
gpg --export -a {SIGNATORY KEY-ID}
```

Their key should be available at their GitHub under `https://github.com/{USERNAME}.gpg`

## Externally Hosted Repos

### Uploading the Repo

- First verify that the repo is correctly tagged and signed following the previous steps.
- Download the zip of the tag from GitHub webpage. (Or clone the repo, checkout the tag and zip the folder)
- Sign the Zip and verify it:

```bash
gpg --sign {NAME OF ZIP}.zip
gpg --verify {NAME OF ZIP}.zip.gpg
```

- Export public key:

```bash
gpg --export -a {KEY-ID} > {MYKEYID}
```

- Upload the `.zip.gpg` file and your public key

### Users Verifying the Hosted Zip

```bash
gpg --import {KEYID}
gpg --verify {NAME OF ZIP}.zip.gpg
```

- Exporting the zip file:

```bash
gpg --output {NAME OF ZIP}.zip --decrypt {NAME OF ZIP}.zip.gpg
```
