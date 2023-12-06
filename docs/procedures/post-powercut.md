# Post-powercut Todo List

A list of things that should be done/checked immediately after a power cut:

- Check KVM, hit ctrl+D on minerva to make sure it boots.
- Check KVM, hit F1 on sprout to make sure it boots
- Check KVM, sometimes you need to press F1 on carbon for it to boot
- Stop Exim on the mail server (Morpheus) until minerva (NFS) is online.
- If LDAP is down, you'll need to use the ALOM to do the next step.
- Check that ldapclient started (svcs -xv). If it didn't, run svcadm clear ldap/client to make it start. This usually happens because murphy comes back before morpheus does, and the LDAP client won't start due to lack of an LDAP server.
- Apache on [hardcase](../hosts/nix/hardcase.md) sometimes tries to start before networking is finished starting. To fix it, disable/re-enable it a few times. This usually makes it turn on.
- [paphos](../hosts/paphos.md) is old and sometimes its time will become out of sync. To make sure its time is accurate, run:
```bash
sudo service ntp restart
```
and ensure you have the correct time with `date`