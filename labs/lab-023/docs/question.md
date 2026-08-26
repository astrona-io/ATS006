# Question

Solve this question on: `terminal` (playing the role of `data-001` from the scenario)

There is a backup folder at `/var/backup/backup-015` that needs to be cleaned up:

1. Delete all files modified before `01/01/2020`.
2. Then, for the remaining files: find all files smaller than `3KiB` and move them to `/var/backup/backup-015/small/`.
3. Find all files larger than `10KiB` and move them to `/var/backup/backup-015/large/`.
4. Find all files with permission `777` and move them to `/var/backup/backup-015/compromised/`.

Perform these steps in the order given — later steps should only ever act on whatever is still left in the top level of `/var/backup/backup-015` after the previous steps ran.
