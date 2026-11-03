# Overview: PLAYGROUND - Overriding a systemd Unit

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh unit-override-playground`.
- `nginx` installed and running, with its packaged unit file `nginx.service`.
- No override yet.

## Things to try

- Read the vendor unit with `systemctl cat nginx`.
- Add a drop-in with `sudo systemctl edit nginx` that sets `Restart=on-failure`.
- Check it with `systemctl show nginx -p Restart`, then remove the drop-in and check again.

## When you are done

```sh
astrona destroy unit-override-playground
```
