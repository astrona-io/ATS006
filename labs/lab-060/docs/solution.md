# Solution Guide: Diskspace & Sync Capstone

This capstone combines both of this section's skills: reclaiming space from a deleted-but-open file, then building a space-efficient local snapshot rotation with `rsync --link-dest`.

---

## Step 1: Confirm the filesystem is full and du disagrees

```bash
df -h /var/log/audit-svc
du -xsh /var/log/audit-svc
```

If `du`'s total is far below the "used" figure `df` reports for the same mount, that gap means something is holding space open that isn't visible in the directory tree.

---

## Step 2: Find the process holding a deleted file open

```bash
sudo lsof +L1 | grep -i audit
```

`+L1` lists open files with a link count under 1 — deleted, but still referenced by a running process. Note the PID and file descriptor number.

---

## Step 3: Reclaim the space without deleting real data

```bash
sudo ls -l /proc/<PID>/fd/<N>
sudo truncate -s 0 /proc/<PID>/fd/<N>
```

This zeroes the file's content live through the process's own descriptor, with zero downtime. Alternatively:

```bash
sudo systemctl restart audit-svc
```

Either way, confirm afterward that `audit.log.1`, `audit.log.2`, and `audit.log.3` are still present — the fix must never touch them.

---

## Step 4: Confirm space was reclaimed

```bash
df -h /var/log/audit-svc
```

Usage should now be well below the near-full baseline.

---

## Step 5: Take the full local backup

```bash
sudo rsync -a /var/log/audit-svc/ /backup/audit-svc-full/
```

Local-to-local `rsync` works exactly like the remote form, just without `-e ssh` or a `host:` prefix. The trailing slash on the source syncs its *contents* directly into `/backup/audit-svc-full/`.

---

## Step 6: Add the new audit batch file

```bash
echo "new audit batch" | sudo tee /var/log/audit-svc/audit.log.4 > /dev/null
```

---

## Step 7: Take the space-efficient link-dest snapshot

```bash
sudo rsync -a --link-dest=/backup/audit-svc-full /var/log/audit-svc/ /backup/audit-svc-snap2/
```

The three unchanged log files get hardlinked against `/backup/audit-svc-full` instead of recopied; `audit.log.4` — new since the full backup — gets transferred fresh. Both `--link-dest`'s reference directory and the destination must live on the same filesystem for the hardlinking to actually happen.

---

## Step 8: Verify the snapshot

```bash
stat -c '%n %h' /backup/audit-svc-snap2/*
ls /backup/audit-svc-full
```

`audit.log.1`/`.2`/`.3` inside the snapshot should show a link count greater than 1; `audit.log.4` should exist in the snapshot but **not** in the full backup, since it was created after Step 5.

**Note:** never solve Step 2 by deleting more files in the visible directory — there's nothing left there that the missing space is attached to.
