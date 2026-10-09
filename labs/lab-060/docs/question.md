# Question

Solve this question on: `terminal`

Astronaut, the internal audit service on this ship writes to `/var/log/audit-svc`. That deck now reports close to 100% full, yet `du` finds almost nothing in the directory: a deleted file that is still open. Once the space is back, mission control also wants a space-efficient local backup rotation of this directory.

Complete these steps in order:

1. Find out why `/var/log/audit-svc` is full. Confirm that `df` and `du` disagree on the same filesystem, and identify the process that holds a deleted file open.
2. Reclaim the space, either by truncating through `/proc/<pid>/fd/<n>` or by restarting the `audit-svc` service. Do **not** delete any of the three legitimate files already there: `audit.log.1`, `audit.log.2` and `audit.log.3`.
3. Once the filesystem has room again, take a full local backup of `/var/log/audit-svc` to `/backup/audit-svc-full` with `rsync -a`. Everything is on this one machine, so you do not need SSH.
4. Create a new file `/var/log/audit-svc/audit.log.4` that contains the text `new audit batch`. It stands for fresh audit data collected after the recovery.
5. Take a second, space-efficient snapshot at `/backup/audit-svc-snap2` with `rsync -a --link-dest=/backup/audit-svc-full`. The three unchanged log files must be hard-linked from the first backup instead of copied again, and `audit.log.4` must be sent fresh.

The grader checks that:

- `/var/log/audit-svc` is at most 50% full, and `lsof +L1` no longer lists any deleted `audit-svc` file as open.
- `audit.log.1`, `audit.log.2` and `audit.log.3` are still in `/var/log/audit-svc`.
- `/backup/audit-svc-full` holds the three log files and does **not** hold `audit.log.4`.
- `/backup/audit-svc-snap2` holds the three log files with a link count greater than 1, and an `audit.log.4` that contains `new audit batch`.
