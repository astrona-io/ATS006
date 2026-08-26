# Solution Guide: Archiving & Backup Capstone

Two independent tasks: convert an archive's compression format with proof, and run a verified full+incremental backup.

---

## Part 1: Archive Conversion

### Step 1: List the bzip2 archive's contents, sorted

```bash
tar -tjf /exports/reports-2026-08.tar.bz2 | sort > /exports/reports-2026-08.tar.bz2_list
```

### Step 2: Extract into a disposable staging directory

```bash
mkdir -p /tmp/reports-extract
tar -xjf /exports/reports-2026-08.tar.bz2 -C /tmp/reports-extract
```

`-C` keeps the original archive untouched — it is only ever opened for reading.

### Step 3: Re-archive as gzip at maximum compression

```bash
cd /tmp/reports-extract
tar --use-compress-program="gzip -9" -cf /exports/reports-2026-08.tar.gz .
```

`tar -czf` alone would silently use gzip's default level (6). `--use-compress-program="gzip -9"` forces level 9 explicitly.

### Step 4: List the new gzip archive's contents, sorted

```bash
tar -tzf /exports/reports-2026-08.tar.gz | sort > /exports/reports-2026-08.tar.gz_list
```

### Step 5: Clean up and verify

```bash
rm -rf /tmp/reports-extract

diff /exports/reports-2026-08.tar.bz2_list /exports/reports-2026-08.tar.gz_list
# (no output)

ls -la /exports/reports-2026-08.tar.bz2
# unchanged size/mtime
```

---

## Part 2: Backup Strategy

### Step 1: Take the full backup

```bash
sudo tar -czpf /backup/services-full.tar.gz \
  --listed-incremental=/backup/services.snar \
  --exclude=opt/services/data/tmp \
  -C / opt/services
```

`-p` preserves ownership and mode bits — this matters here because `/opt/services/config/secrets.conf` is deliberately locked down to `600`, and a restore without `-p` would quietly lose that. `--exclude` patterns match against the *stored* (relative) path, not the absolute filesystem path — since `-C /` makes the stored path `opt/services/data/tmp`, the exclude pattern has to match that exact relative form (no leading slash) so no unrelated `tmp`-named directory elsewhere gets swept up by accident, and so the pattern actually matches anything at all. Including `--listed-incremental=/backup/services.snar` here makes this full backup level 0 of the incremental chain: the snapshot file doesn't exist yet so this run captures everything, but it leaves a real baseline behind for Step 3 to diff against — skip it here and Step 3 would have no baseline either, silently producing a second full copy instead of a true incremental.

### Step 2: Simulate a change

```bash
echo "feature_flag=rollout-42" | sudo tee -a /opt/services/config/app.conf
echo "2026-Q3,pending" | sudo tee /opt/services/data/ledger-2026-Q3.csv
```

### Step 3: Take the true incremental backup

```bash
sudo tar -czpf /backup/services-incr.tar.gz \
  --listed-incremental=/backup/services.snar \
  --exclude=opt/services/data/tmp \
  -C / opt/services
```

Check the result — it should be dramatically smaller than the full backup and its listing should include `app.conf` and `ledger-2026-Q3.csv` but not the untouched `data/ledger-2026-Q2.csv`:

```bash
ls -lh /backup/services-full.tar.gz /backup/services-incr.tar.gz
tar -tzf /backup/services-incr.tar.gz
```

### Step 4: Restore the full backup alone

```bash
sudo mkdir -p /restore/services-full
sudo tar -xzpf /backup/services-full.tar.gz -C /restore/services-full
```

### Step 5: Restore the full backup, then layer the incremental on top

```bash
sudo mkdir -p /restore/services-current
sudo tar -xzpf /backup/services-full.tar.gz  -C /restore/services-current
sudo tar -xzpf /backup/services-incr.tar.gz  -C /restore/services-current
```

### Step 6: Verify both restores explicitly

```bash
# Full-only restore should predate the change
grep feature_flag /restore/services-full/opt/services/config/app.conf   # expect no match
test -e /restore/services-full/opt/services/data/ledger-2026-Q3.csv     # expect false

# Layered restore should include the change
grep feature_flag /restore/services-current/opt/services/config/app.conf   # match
test -e /restore/services-current/opt/services/data/ledger-2026-Q3.csv     # true

# Neither restore should contain the excluded tmp/ directory
test ! -e /restore/services-full/opt/services/data/tmp
test ! -e /restore/services-current/opt/services/data/tmp

# Permissions preserved on the restricted secrets file
stat -c '%a %U:%G' /opt/services/config/secrets.conf
stat -c '%a %U:%G' /restore/services-full/opt/services/config/secrets.conf
# both should read the same mode/owner
```

> **Note:** A clean `tar -x` exit code only proves extraction didn't error — it says nothing about whether content or permissions actually match. The `grep`/`test`/`stat` comparisons above are what actually prove the restore is correct.
