# Overview: PLAYGROUND - Backups with tar

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh tar-backup-playground`.
- The folder `/srv/appdata` with `notes.txt`, a `reports` folder with two files, and a `cache` folder with temporary files.
- An empty folder `/backup`, owned by `candidate`.

## Things to try

- Make a full backup of `/srv/appdata` that skips `cache` with `--exclude`.
- Change one file, then make an incremental backup with `--listed-incremental`.
- Restore both archives, in order, into a new folder and compare it with the original.

## When you are done

```sh
astrona destroy tar-backup-playground
```
