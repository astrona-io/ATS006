# Solution Guide: tar Backup Strategy

This guide builds a full backup, a true incremental backup, and two verified restores.

---

## Step 1: Take the full backup, preserving permissions and excluding cache

```bash
sudo tar -czpf /backup/full-backup.tar.gz \
  --listed-incremental=/backup/snapshot.snar \
  --exclude=srv/appdata/cache \
  -C / etc srv/appdata
```

`-p` preserves ownership, mode bits, and symlinks — without it, `/etc`'s restored files would fall back to the extracting process's default ownership instead of the original's. `-C /` archives `etc` and `srv/appdata` as *relative* paths, which is what makes the archive safely extractable into a scratch directory later. `--exclude` patterns match against that same relative, stored path — so the exclude pattern has to be `srv/appdata/cache` (no leading slash) to actually match; a leading-slash pattern here would silently match nothing and `cache/` would sail straight into the archive. Including `--listed-incremental=/backup/snapshot.snar` here too is what makes this full backup *also* level 0 of the incremental chain — the snapshot file doesn't exist yet, so this run necessarily captures everything, but it leaves behind a real baseline for Step 4's incremental run to compare against. Skipping this on the full backup and only adding it later would mean Step 4 has no baseline either, and would silently produce a second full copy instead of a true incremental.

---

## Step 2: Confirm cache was actually excluded

```bash
tar -tzf /backup/full-backup.tar.gz | grep cache
# (no output)
```

---

## Step 3: Simulate a day passing

```bash
echo "Q3 restock complete" | sudo tee -a /srv/appdata/notes.txt
sudo touch /srv/appdata/new-shipment.csv
```

---

## Step 4: Take the true incremental backup

```bash
sudo tar -czpf /backup/incr-backup.tar.gz \
  --listed-incremental=/backup/snapshot.snar \
  --exclude=srv/appdata/cache \
  -C / etc srv/appdata
```

Because Step 1 already established `/backup/snapshot.snar` as a real baseline, this run compares the current filesystem state against it and archives only what's new or changed.

```bash
ls -lh /backup/full-backup.tar.gz /backup/incr-backup.tar.gz
tar -tzf /backup/incr-backup.tar.gz
```

Check that the incremental listing contains `srv/appdata/notes.txt` and `srv/appdata/new-shipment.csv` (the changed/new files) but not the untouched `srv/appdata/reports/` file — that absence is the proof only real changes were captured. `/etc` itself didn't change at all, so it should show up only as directory bookkeeping entries, not a full re-copy of every file inside it — which is also why the incremental archive ends up so much smaller than the full one.

---

## Step 5: Restore the full backup alone

```bash
sudo mkdir -p /restore/full
sudo tar -xzpf /backup/full-backup.tar.gz -C /restore/full
```

This reconstructs the state **as of Step 1** — before the notes.txt change and before `new-shipment.csv` existed.

---

## Step 6: Restore the full backup, then layer the incremental on top

```bash
sudo mkdir -p /restore/incremental
sudo tar -xzpf /backup/full-backup.tar.gz -C /restore/incremental
sudo tar -xzpf /backup/incr-backup.tar.gz  -C /restore/incremental
```

Incremental archives are designed to be extracted on top of the full restore they were taken after, in order. This reconstructs the state **as of Step 3**.

---

## Step 7: Verify with real comparisons, not exit codes

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

> **Note:** A successful `tar -x` exit code only means nothing errored during extraction — it says nothing about whether content, permissions, or structure actually match. Only an explicit `diff`/`stat` comparison against the known-good original proves the restore is correct.
