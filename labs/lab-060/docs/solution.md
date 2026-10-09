# Solution Walkthrough

This capstone puts two skills together. First you free the space a deleted-but-open file is holding. Then you build a local backup rotation with `rsync --link-dest`, where the second snapshot shares its unchanged files with the first.

## Step 1: Confirm that the filesystem is full and du disagrees

```bash
df -h /var/log/audit-svc
du -xsh /var/log/audit-svc
```

`df` reads the filesystem's own count of blocks in use. `du` adds up the files it can find by name, and `-x` keeps it on this one filesystem. The three legitimate log files are 4 MB each, so `du` reports a total of roughly that size. If that is far below the "Used" value from `df`, something is holding space that the directory tree cannot show.

## Step 2: Find the process that holds a deleted file open

```bash
sudo lsof +L1 | grep -i audit
```

`+L1` lists open files with a link count below 1: deleted, but still held by a running process. The file is `/var/log/audit-svc/current.log`. Write down the PID and the file descriptor number (the `FD` column, the number without the letter after it).

## Step 3: Reclaim the space without deleting real data

Replace `<PID>` and `<N>` with the numbers from Step 2. Check the target first, then empty the file through the process's own descriptor:

```bash
sudo ls -l /proc/<PID>/fd/<N>
sudo truncate -s 0 /proc/<PID>/fd/<N>
```

The link target ends with `(deleted)`. Truncating empties the file while the process keeps running. If a restart is acceptable, this works as well:

```bash
sudo systemctl restart audit-svc
```

Either way, check afterwards that `audit.log.1`, `audit.log.2` and `audit.log.3` are still there. The fix must never touch them.

## Step 4: Confirm that the space came back

```bash
df -h /var/log/audit-svc
```

Usage should now be far below the near-full value from Step 1. The grader wants 50% or less.

## Step 5: Take the full local backup

```bash
sudo rsync -a /var/log/audit-svc/ /backup/audit-svc-full/
```

A local `rsync` works like the remote form, only without `-e ssh` and without a `host:` in front of the path. The trailing slash on the source copies its **contents** straight into `/backup/audit-svc-full/`.

## Step 6: Add the new audit batch file

```bash
echo "new audit batch" | sudo tee /var/log/audit-svc/audit.log.4 > /dev/null
```

The file is new after the full backup, so the full backup must not contain it.

## Step 7: Take the space-efficient snapshot with link-dest

```bash
sudo rsync -a --link-dest=/backup/audit-svc-full /var/log/audit-svc/ /backup/audit-svc-snap2/
```

The three unchanged log files are hard-linked to the copies in `/backup/audit-svc-full` instead of copied again. `audit.log.4` is new since the full backup, so `rsync` sends it fresh. The `--link-dest` reference and the destination must be on the same filesystem; here both are under `/backup`.

## Step 8: Check the snapshot

```bash
stat -c '%n %h' /backup/audit-svc-snap2/*
ls /backup/audit-svc-full
```

Check two things:

- `audit.log.1`, `.2` and `.3` in the snapshot show a link count greater than 1.
- `audit.log.4` is in the snapshot, but **not** in the full backup, because you created it after Step 5.

Never solve the space problem by deleting more files in the visible directory. Nothing there is attached to the missing space.

## Step 9: Submit

```sh
astrona submit -c labs/lab-060
```
