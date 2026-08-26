# Question

Solve this question on: `terminal`

An internal audit service on this host writes to `/var/log/audit-svc`, which is now reporting close to 100% full despite `du` showing barely anything in the directory — the classic deleted-but-still-open file problem. Ops also wants a space-efficient local backup rotation of this directory started immediately once the space issue is resolved.

Complete, in order:

1. Diagnose why `/var/log/audit-svc` is full (confirm `df` and `du` disagree on the same filesystem) and identify the process holding a deleted file open.
2. Reclaim the space — via `/proc/<pid>/fd/<n>` truncation or by restarting the `audit-svc` service — **without** deleting any of the three legitimate files already present: `audit.log.1`, `audit.log.2`, `audit.log.3`.
3. Once the filesystem has room again, take a full local backup of `/var/log/audit-svc` to `/backup/audit-svc-full` using `rsync -a` (everything here is local to this host — no SSH needed).
4. Create a new file `/var/log/audit-svc/audit.log.4` containing the text `new audit batch`, representing freshly collected audit data gathered after the recovery.
5. Take a second, space-efficient snapshot at `/backup/audit-svc-snap2`, using `rsync -a --link-dest=/backup/audit-svc-full`, so that the three unchanged log files are hardlinked from the first backup instead of recopied, while `audit.log.4` is transferred fresh.
