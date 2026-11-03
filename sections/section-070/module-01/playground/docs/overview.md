# Overview: PLAYGROUND - Creating a systemd Service

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh service-unit-playground`.
- The script `/usr/local/bin/collector.sh`. It writes one line with the time to `/var/log/collector.log` every five seconds, until stopped.
- No unit file for it yet. You write that.

## Things to try

- Run the script by hand and stop it with `Ctrl+C`.
- Write `/etc/systemd/system/collector.service`, run `sudo systemctl daemon-reload` and start it.
- Break the `ExecStart` path on purpose and read the reason with `systemctl status` and `journalctl -u`.

## When you are done

```sh
astrona destroy service-unit-playground
```
