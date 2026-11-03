# Overview: PLAYGROUND - Mirroring with rsync

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh rsync-playground`.
- `rsync` installed.
- The folder `/srv/appdata` with `notes.txt` and a `reports` folder with two files.
- An empty folder `/backup/appdata`, owned by `candidate`.

## Things to try

- Preview a mirror with `rsync -av --dry-run /srv/appdata/ /backup/appdata/`, then run it.
- Delete a file in the source and mirror again with and without `--delete`.
- Build two dated snapshots with `--link-dest` and compare the inode numbers with `ls -li`.

## When you are done

```sh
astrona destroy rsync-playground
```
