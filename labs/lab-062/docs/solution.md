# Solution Walkthrough

This mission is a supply run between two ships. You mirror the working tree from `data-001` to `data-002` over SSH, safely, with a dry run first. Then you take a snapshot on `data-002` that shares its unchanged files with the mirror through hard links. Run every command on `data-001`.

## Step 1: Check the SSH connection from data-001

```bash
ssh data-002 'echo connected'
```

```text
connected
```

Key-based access to `data-002` is already set up, so no password prompt appears. `rsync -e ssh` needs this to run without asking for a password.

## Step 2: Preview the mirroring sync with a dry run

```bash
rsync -avzn --delete --exclude=tmp/ -e ssh /srv/appdata/ data-002:/backup/appdata/
```

`-n` (`--dry-run`) shows every transfer and every deletion without changing anything on `data-002`. Read every deleting line before you go on. One of them names `decommissioned-report.txt`, the stale file from the old mirror, and nothing else should be listed for deletion. This check is the safety habit `--delete` always needs.

## Step 3: Run the real mirroring sync

```bash
rsync -avz --delete --exclude=tmp/ -e ssh /srv/appdata/ data-002:/backup/appdata/
```

Here is what each part does:

- The trailing slash on `/srv/appdata/` copies its **contents** straight into `/backup/appdata/`, not into a nested `appdata/appdata/`.
- `--delete` removes the stale file that no longer exists on the source.
- `--exclude=tmp/` keeps the scratch directory out of the mirror entirely.

## Step 4: Check that the mirror matches the source

```bash
ssh data-002 'ls /backup/appdata'
rsync -avzn --delete --exclude=tmp/ -e ssh /srv/appdata/ data-002:/backup/appdata/
```

The listing shows `app.conf`, `data1.txt` and `data2.txt`, with no `tmp` and no `decommissioned-report.txt`. A second dry run that lists no files to transfer or delete proves that the mirror is fully in sync.

## Step 5: Take a space-efficient snapshot with link-dest

```bash
ssh data-002 'mkdir -p /backup/snapshots/snap2'
rsync -avz --exclude=tmp/ -e ssh --link-dest=/backup/appdata /srv/appdata/ data-002:/backup/snapshots/snap2/
```

For every file that is unchanged since `/backup/appdata`, `rsync` makes a hard link in the snapshot instead of copying it again. The `--link-dest` path is read on `data-002`, the receiving side. The reference and the destination must be on the same filesystem, or `rsync` silently falls back to full copies.

## Step 6: Check that the snapshot is really hard-linked

```bash
ssh data-002 "stat -c '%n %h' /backup/snapshots/snap2/*"
ssh data-002 "du -sh /backup/appdata /backup/snapshots/snap2"
```

Each unchanged file shows a link count (`%h`) greater than 1. When `du` measures both folders in one command, it counts each shared inode only once, so the snapshot adds very little.

Never drop `-n` from a `--delete` command before you have read its dry run. It is the one command in this mission that can permanently remove data if the source and the destination are ever swapped.

## Step 7: Submit

```sh
astrona submit -c labs/lab-062
```
