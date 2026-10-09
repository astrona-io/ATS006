# Solution Walkthrough

Two separate jobs: repack an archive with a different compressor and prove nothing was lost, then run a full and incremental backup and prove both restores. `tar` does the archiving, `bzip2` and `gzip` do the compression, and the snapshot file `/backup/services.snar` makes the second backup incremental.

`/exports` was created by `root`. If your user cannot write files there, run the archive steps from a root shell (`sudo -i`); the commands stay the same.

## Step 1: List the bzip2 archive, sorted

```bash
tar -tjf /exports/reports-2026-08.tar.bz2 | sort > /exports/reports-2026-08.tar.bz2_list
```

`-t` lists the archive without extracting it, and `sort` puts the lines in a fixed order so the two listings can be compared.

## Step 2: Extract into a throwaway staging directory

```bash
mkdir -p /tmp/reports-extract
tar -xjf /exports/reports-2026-08.tar.bz2 -C /tmp/reports-extract
```

`-C` keeps the original archive untouched: `tar` only ever opens it for reading. The grader checks the original against a checksum taken when the machine was set up.

## Step 3: Repack as gzip at maximum compression

```bash
cd /tmp/reports-extract
tar --use-compress-program="gzip -9" -cf /exports/reports-2026-08.tar.gz .
```

`tar -czf` alone would silently use the default `gzip` level (6). `--use-compress-program="gzip -9"` forces level 9. The grader reads the gzip header's extra flags byte and expects `2`, which only level 9 produces.

## Step 4: List the gzip archive, sorted

```bash
tar -tzf /exports/reports-2026-08.tar.gz | sort > /exports/reports-2026-08.tar.gz_list
```

## Step 5: Clean up and check the conversion

```bash
rm -rf /tmp/reports-extract

diff /exports/reports-2026-08.tar.bz2_list /exports/reports-2026-08.tar.gz_list
# (no output)

ls -la /exports/reports-2026-08.tar.bz2
# unchanged size/mtime
```

No output from `diff` means both archives hold the same files. You can also read the header byte yourself with `od -An -tu1 -j8 -N1 /exports/reports-2026-08.tar.gz`; it should be `2`.

## Step 6: Create the backup directory

The machine does not have `/backup` yet, so create it first:

```bash
sudo mkdir -p /backup
```

## Step 7: Take the full backup

```bash
sudo tar -czpf /backup/services-full.tar.gz \
  --listed-incremental=/backup/services.snar \
  --exclude=opt/services/data/tmp \
  -C / opt/services
```

Here is what each option does:

- **`-p`** keeps ownership and mode bits. That matters here, because `/opt/services/config/secrets.conf` is locked down to `600`, and a restore without `-p` would quietly lose that.
- **`-C /`** stores the relative path `opt/services`, not an absolute one. The grader fails the backup if any stored path starts with `/`.
- **`--exclude=opt/services/data/tmp`** must match the stored, relative path. A pattern with a leading slash matches nothing, and a bare `tmp` could also leave out unrelated directories with that name.
- **`--listed-incremental=/backup/services.snar`** makes this full backup level 0 of the incremental chain. The snapshot file does not exist yet, so this run captures everything, but it leaves a real starting point for the incremental run. Without it here, the incremental run would silently make a second full copy.

## Step 8: Simulate a change

```bash
echo "feature_flag=rollout-42" | sudo tee -a /opt/services/config/app.conf
echo "2026-Q3,pending" | sudo tee /opt/services/data/ledger-2026-Q3.csv
```

## Step 9: Take the true incremental backup

```bash
sudo tar -czpf /backup/services-incr.tar.gz \
  --listed-incremental=/backup/services.snar \
  --exclude=opt/services/data/tmp \
  -C / opt/services
```

Check the result. It should be much smaller than the full backup, and its listing should include `app.conf` and `ledger-2026-Q3.csv` but not the untouched `data/ledger-2026-Q2.csv`:

```bash
ls -lh /backup/services-full.tar.gz /backup/services-incr.tar.gz
tar -tzf /backup/services-incr.tar.gz
```

## Step 10: Restore the full backup alone

```bash
sudo mkdir -p /restore/services-full
sudo tar -xzpf /backup/services-full.tar.gz -C /restore/services-full
```

## Step 11: Restore the full backup, then layer the incremental on top

```bash
sudo mkdir -p /restore/services-current
sudo tar -xzpf /backup/services-full.tar.gz  -C /restore/services-current
sudo tar -xzpf /backup/services-incr.tar.gz  -C /restore/services-current
```

The full backup goes first, and the incremental goes on top of the same directory.

## Step 12: Prove both restores and submit

A clean `tar -x` exit code only proves that extraction did not fail. It says nothing about whether content or permissions match. These comparisons are the real proof:

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

Both `stat` lines should show `600 root:root`, the mode and owner the setup gave `secrets.conf`. The grader also checks that the restored `ledger-2026-Q2.csv` matches the live file, and that the layered `app.conf` matches the live `app.conf` exactly.

When every check passes, send the mission for grading from your own computer:

```bash
astrona submit -c labs/lab-050
```
