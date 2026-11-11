# Backup Strategy with tar

Astronaut, there is a big difference between "I ran a backup command" and "I have a backup strategy". One `tar -czf` command captures one sealed shipping container of crates. A strategy is a repeatable process: it keeps the crates' locks and owners, it knows which crates to leave behind, it does not ship unchanged crates again every night, and it has been proven to unpack correctly.

That last point is the one almost everyone skips. A backup nobody has ever restored is only a hope. In this module you build the whole chain with `tar`: a full backup, a true incremental backup, and two restores you prove with real comparisons.

## Learning objectives

After this module you can:

- Keep ownership and permission bits in a backup and in a restore with `-p`, and explain why both ends need it.
- Leave a directory out of a backup with `--exclude`, and write the pattern so it really matches.
- Store relative paths in an archive with `-C /`, so you can restore it anywhere.
- Take a full backup that also starts an incremental chain with `--listed-incremental`.
- Take a true incremental backup that holds only new and changed files, and prove it is smaller.
- Explain why a lost snapshot file silently turns every incremental backup back into a full one.
- Restore a full backup alone, and a full backup with the incremental layered on top.
- Prove a restore with `diff -r` and `stat`, not with an exit code.

## Before you start

Every mission starts with a pre-flight check, astronaut. Make sure you know the basics below and have a terminal ready.

### What you should already know

- **How to read permissions.** You can read the mode and owner of a file with `ls -l` or `stat -c '%a %U:%G' <file>`.
- **How to create an archive and look inside it.** `tar -czf` creates a gzip-compressed archive, and `tar -tzf` lists what is inside it.
- **How to use `sudo`.** Backing up and restoring system files needs the captain's authority (`root`).

### What you need

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The folder `/srv/appdata` with `notes.txt`, a `reports` folder with two files, and a `cache` folder with temporary files.
- An empty folder `/backup`, owned by `candidate`.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh tar-backup-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

1. [Permissions And Excludes](./course-01-permissions-and-excludes.md): keep the locks on every crate, leave the disposable ones behind, and store relative paths.
2. [Full And Incremental Backups](./course-02-full-and-incremental-backups.md): ship everything once, then ship only what changed, and guard the inventory list that makes it work.
3. [Restore And Prove](./course-03-restore-and-prove.md): unpack the chain in order and prove the result.
   - Mission: tar Backup Strategy Lab
4. [Wrap-Up: Mission Debrief](./course-04-wrap-up.md)

## Why this matters

Backups are only tested on the worst day: when something is gone. On that day you need the right files, with the right owners and permissions, without waiting for a week of full copies to unpack. The exam checks the same thing a real incident does: not that you ran `tar`, but that the restore matches the original.

<!-- curriculum-practice -->
## Practice and assessment

- [tar Backup Strategy Lab](../../../labs/lab-052/docs/question.md): Take a full backup with a snapshot file, permissions kept and a cache directory excluded; Take a true incremental backup and layer it over the full backup on restore; Prove both restores with an explicit comparison.
- [Archiving & Backup Capstone Lab](../../../labs/lab-050/docs/question.md): Convert a bzip2 archive to gzip at the best level and prove both hold the same files; Take a full and a true incremental tar backup with a snapshot file and an exclude; Restore the full backup alone and with the increment, and prove both restores.
