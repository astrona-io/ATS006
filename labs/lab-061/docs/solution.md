# Solution Guide: Diskspace Troubleshooting

This guide shows you how to confirm a `df`-versus-`du` mismatch and reclaim space from a deleted-but-open file without losing real data.

---

## Step 1: Confirm which filesystem is actually full

```bash
df -h /var/log/reporting-app
```

This resolves to the mount point backing that directory. Note the used percentage before doing anything else — you'll compare against it later to prove your fix worked.

---

## Step 2: Confirm du disagrees with df on the same filesystem

```bash
du -xsh /var/log/reporting-app
```

`-x` keeps the walk on this one filesystem, `-s` collapses it to a single total. If this number is dramatically smaller than the "used" figure `df` reported, that gap is your signal to stop looking at the visible tree and start hunting for a held-open deleted file.

---

## Step 3: Find the process holding a deleted file open

```bash
sudo lsof +L1
```

`+L1` lists open files with a link count under 1 — deleted from the directory tree, but still referenced by a running process. Look for an entry under `/var/log/reporting-app`; note its PID and file descriptor number.

---

## Step 4: Reclaim the space live, without restarting

```bash
sudo ls -l /proc/<PID>/fd/<N>
sudo truncate -s 0 /proc/<PID>/fd/<N>
```

Truncating through the process's own open file descriptor zeroes the file's content while the process keeps running uninterrupted — its next write starts appending from a now-empty file.

**Alternative (if a restart is acceptable):**

```bash
sudo systemctl restart reporting-app
```

Restarting closes the old file descriptor entirely, which drops the inode's reference count to zero on both sides and frees the blocks automatically.

---

## Step 5: Confirm the fix

```bash
df -h /var/log/reporting-app
sudo lsof +L1 | grep -i reporting
ls -la /var/log/reporting-app
```

Usage should have dropped substantially, `lsof +L1` should show no more reporting-app entries, and `reporting-app.log.1`/`.2`/`.3` should still be present.

**Note:** never solve this by deleting more files in the visible directory — there's nothing left there that the missing space is attached to. The whole problem is that the space belongs to an inode with no name left in the filesystem.
