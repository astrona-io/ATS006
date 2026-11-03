# Overview: PLAYGROUND - Files, Links and Ownership

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh file-ops-links-playground`.
- The folder `~/cargo` with `manifest.txt`, `crew.txt` and a subfolder `crates` that holds two small files.
- The group `loaders` and the user `loadmaster`, who is a member of `loaders`.

## Things to try

- Copy `manifest.txt` with plain `cp` and with `cp -p`, and compare the timestamps.
- Make a hard link and a symbolic link to `crew.txt`, then compare them with `ls -li`.
- Change the group of `crates` to `loaders` with `sudo chgrp -R` and check it.

## When you are done

```sh
astrona destroy file-ops-links-playground
```
