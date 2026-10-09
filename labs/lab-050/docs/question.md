# Question

Solve this question on: `terminal`

Astronaut, mission control has handed you two separate jobs on this training ship. Solve both.

## Part 1: Archive conversion

There is an archive `/exports/reports-2026-08.tar.bz2`, vacuum-packed with `bzip2`. Create a new gzip-compressed archive with its raw contents:

1. Store the new archive at `/exports/reports-2026-08.tar.gz`, using the best possible gzip compression (level 9).
2. Write sorted content listings for both archives to `/exports/reports-2026-08.tar.bz2_list` and `/exports/reports-2026-08.tar.gz_list`.
3. Do not modify or delete the original `/exports/reports-2026-08.tar.bz2`.

## Part 2: Backup strategy

This ship also runs a service rooted at `/opt/services`. It has a `data/tmp/` subdirectory that rebuilds itself and must never be backed up.

1. Take a full backup of `/opt/services` into `/backup/services-full.tar.gz`:
   - Keep permissions and ownership.
   - Leave out `/opt/services/data/tmp`.
   - Store relative paths, not absolute ones.
   - Use the snapshot file `/backup/services.snar`, so this full backup is the starting point of the incremental chain below.
2. Simulate a change: append the exact line `feature_flag=rollout-42` to `/opt/services/config/app.conf`, and create a new file `/opt/services/data/ledger-2026-Q3.csv` containing the exact line `2026-Q3,pending`.
3. Take a true incremental backup that captures only what changed since the full backup, not a second full copy. Reuse the same snapshot file `/backup/services.snar`, store the archive at `/backup/services-incr.tar.gz`, and use the same exclude and permission handling as in step 1. It must be smaller than the full backup, and it must not contain the untouched `data/ledger-2026-Q2.csv`.
4. Restore the full backup **alone** into `/restore/services-full`.
5. Restore the full backup **and then layer the incremental backup on top of it** into `/restore/services-current`, so it shows the state after the changes in step 2.
6. Prove both restores are correct with an explicit comparison, not just a clean exit code. The restored `config/secrets.conf` must keep the mode and owner of the live file.
