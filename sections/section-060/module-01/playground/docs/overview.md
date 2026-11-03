# Overview: PLAYGROUND - Diskspace Troubleshooting

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh disk-space-playground`.
- The folder `/srv/space-practice` with three files of 50 MiB, 20 MiB and 1 MiB.
- The service `log-hog.service`. It deletes its own log file but keeps writing to it, so the space is used and no file name shows it.

## Things to try

- Compare `df -h /` with `du -sh /srv/space-practice`.
- Find the deleted file with `sudo lsof +L1`.
- Free the space by truncating the open file through `/proc` or by restarting the service.

## When you are done

```sh
astrona destroy disk-space-playground
```
