# Mordor

<!-- Access through 192.168.1.1 -->

## Setup

This UDM Pro is set up using the personal setup type, using the elected-admins@redbrick.dcu.ie account (stored in pwsafe
2FA is stored on the same device as the Github 2FA code.

### Automatic Updates

The UDM Pro is not set up for automatic updates for reliability reasons.

### Network Speeds

The speeds our ISP (ISS) has promised us is a 2 GB/s link to DCU's core, however, we only use 1 GB/s
right now. The UDM Pro will notify if the speed dips below the 1GB/s threshold.

### Users

Every elected admin should hold an account on the UDM Pro to configure its rules. Rootholders **should not** have access
to the firewall unless they are explicity granted access.

The owner account of the unifi equipment is `rbadmins` (email: elected-admins@redbrick.dcu.ie) with the password stored
in pwsafe under `unifi`.

There is a "super admin" account that can be used for **local access only**, details are stored in pwsafe under
`udmpro-super-admin`.

### Updates

The UDM Pro should be kept up to date at all times using the web interface. Please ensure there are no breaking changes before
updating.

!!! error
    ### AUTO UPDATES SHOULD NEVER BE ENABLED!

    This is to prevent a bad update from breaking the UDM Pro and thus the entire network.
    If you are confident that Unifi can produce stable updates, you may turn it on, however please let the next admins 
    know that you have done this (and update these docs with a comment!).

### Advanced Settings

SSH is enabled to allow for rollbacks in case of a bad update (I warned you!).

Remote access is disabled as it should not be needed, if it is enabled in future, please update these docs with your reasons.

### Backups

Backups are configured to run every week  at 1am on a Sunday. 20 backups are stored at a time, therefore storing 20 weeks
of configuration. This should be plenty of time to recover from a bad configuration change.
