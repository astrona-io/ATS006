# Question

Solve this question on: `terminal` (playing the role of `data-001` from the scenario)

Astronaut, the backup compartment `/var/backup/backup-015` has turned into a junk drawer. Clean it up with these four steps, in this exact order:

1. Delete all files modified before `01/01/2020`.
2. Then, from the remaining files, move all files smaller than `3KiB` to `/var/backup/backup-015/small/`.
3. Move all files larger than `10KiB` to `/var/backup/backup-015/large/`.
4. Move all files with permission `777` to `/var/backup/backup-015/compromised/`.

Each later step must only act on the files still left in the top level of `/var/backup/backup-015` after the earlier steps ran. A file that fits more than one rule goes where the earliest matching step puts it.

The grader checks that no file older than the cutoff is left anywhere under the folder, that each destination holds exactly the files that belong there, and that the files no rule matches stay in the top level.
