# Solution Walkthrough

This walkthrough builds a full backup, a true incremental backup and two restores, and proves each one. `tar` does all the archiving and restoring; the snapshot file `/backup/snapshot.snar` is what makes the second backup incremental.

## Step 1: Create the backup directory

The machine does not have `/backup` yet, so create it first:

```bash
sudo mkdir -p /backup
```

## Step 2: Take the full backup

```bash
sudo tar -czpf /backup/full-backup.tar.gz \
  --listed-incremental=/backup/snapshot.snar \
  --exclude=srv/appdata/cache \
  -C / etc srv/appdata
```

Here is what each option does:

- **`-p`** keeps ownership, mode bits and symbolic links. Without it, the restored files in `etc` would get the extracting process's default ownership instead of the original's.
- **`-C /`** stores `etc` and `srv/appdata` as *relative* paths, which makes the archive safe to extract into a scratch directory later.
- **`--exclude=srv/appdata/cache`** matches the same relative, stored path. A pattern with a leading slash would silently match nothing, and `cache/` would end up in the archive.
- **`--listed-incremental=/backup/snapshot.snar`** makes this full backup also level 0 of the incremental chain. The snapshot file does not exist yet, so this run captures everything, but it leaves a real starting point behind for the incremental run. Without it here, the incremental run would have nothing to compare against and would silently make a second full copy.

## Step 3: Confirm the cache was left out

```bash
tar -tzf /backup/full-backup.tar.gz | grep cache
```

There should be no output. Any line here means the exclude pattern did not match.

## Step 4: Simulate a day passing

```bash
echo "Q3 restock complete" | sudo tee -a /srv/appdata/notes.txt
sudo touch /srv/appdata/new-shipment.csv
```

`tee -a` appends the line and also prints it on the terminal.

## Step 5: Take the true incremental backup

```bash
sudo tar -czpf /backup/incr-backup.tar.gz \
  --listed-incremental=/backup/snapshot.snar \
  --exclude=srv/appdata/cache \
  -C / etc srv/appdata
```

Because the full backup already created `/backup/snapshot.snar`, `tar` compares the files on disk with it and archives only what is new or changed.

Check the sizes and the contents:

```bash
ls -lh /backup/full-backup.tar.gz /backup/incr-backup.tar.gz
tar -tzf /backup/incr-backup.tar.gz
```

The incremental listing should contain `srv/appdata/notes.txt` and `srv/appdata/new-shipment.csv` (the changed and new files), but not the untouched file in `srv/appdata/reports/`. That missing file is the proof that only real changes were captured. `/etc` did not change, so it shows up only as directory bookkeeping entries, not a full copy of every file inside it. That is also why the incremental archive is so much smaller than the full one.

## Step 6: Restore the full backup alone

```bash
sudo mkdir -p /restore/full
sudo tar -xzpf /backup/full-backup.tar.gz -C /restore/full
```

This rebuilds the state as of the full backup: before the change to `notes.txt`, and before `new-shipment.csv` existed.

## Step 7: Restore the full backup, then layer the incremental on top

```bash
sudo mkdir -p /restore/incremental
sudo tar -xzpf /backup/full-backup.tar.gz -C /restore/incremental
sudo tar -xzpf /backup/incr-backup.tar.gz  -C /restore/incremental
```

Incremental archives are made to be extracted on top of the full restore they follow, in order. This rebuilds the state after the changes in Step 4.

## Step 8: Prove both restores and submit

A clean exit code from `tar -x` only means nothing went wrong during extraction. It says nothing about whether content, permissions or structure match. Compare explicitly:

```bash
# /etc should be byte-for-byte identical either way
sudo diff -r /etc /restore/full/etc
sudo diff -r /etc /restore/incremental/etc

# The full-only restore should NOT have the Step 2 change yet
grep "Q3 restock complete" /restore/full/srv/appdata/notes.txt   # expect no match
test -e /restore/full/srv/appdata/new-shipment.csv               # expect false

# The layered restore SHOULD have the Step 2 change
grep "Q3 restock complete" /restore/incremental/srv/appdata/notes.txt   # match
test -e /restore/incremental/srv/appdata/new-shipment.csv               # true

# cache/ must be absent from both
test ! -e /restore/full/srv/appdata/cache
test ! -e /restore/incremental/srv/appdata/cache

# Permissions really were preserved on a security-sensitive file
stat -c '%a %U:%G' /etc/shadow
stat -c '%a %U:%G' /restore/full/etc/shadow
# both lines should match
```

The comments in the block say what to expect from each check (the "Step 2 change" is the change you made in Step 4 of this walkthrough). Both `diff -r` commands should print nothing, and the two `stat` lines must be identical.

When every check passes, send the mission for grading from your own computer:

```bash
astrona submit -c labs/lab-052
```
