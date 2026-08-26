# Question

Solve this question on: `terminal`

You've been handed two unrelated tasks for this host. Solve both.

## Part 1: Archive Conversion

There is an archive `/exports/reports-2026-08.tar.bz2`. Create a new gzip-compressed archive with its raw contents:

1. Store the new archive at `/exports/reports-2026-08.tar.gz`, using the best possible gzip compression.
2. Write sorted content listings for both archives to `/exports/reports-2026-08.tar.bz2_list` and `/exports/reports-2026-08.tar.gz_list`.
3. Do not modify or delete the original `/exports/reports-2026-08.tar.bz2`.

## Part 2: Backup Strategy

This host also runs a service rooted at `/opt/services`, which includes a `data/tmp/` subdirectory that regenerates itself and should never be backed up.

1. Take a full backup of `/opt/services`, preserving permissions/ownership correctly, excluding `/opt/services/data/tmp`, into `/backup/services-full.tar.gz` (paths stored relative, not absolute), using a snapshot file at `/backup/services.snar` so this full backup establishes the baseline for the incremental chain below.
2. Simulate a change: append the exact line `feature_flag=rollout-42` to `/opt/services/config/app.conf`, and create a new file `/opt/services/data/ledger-2026-Q3.csv` containing the exact line `2026-Q3,pending`.
3. Take a true incremental backup capturing only what changed since the full backup (not a second full copy). Reuse the same snapshot file at `/backup/services.snar` from Step 1 and store the incremental archive at `/backup/services-incr.tar.gz`, with the same exclude and permission-preservation as Step 1.
4. Restore the full backup **alone** into `/restore/services-full`.
5. Restore the full backup **and then layer the incremental backup on top of it** into `/restore/services-current`, reconstructing the state as of Step 2's changes.
6. Prove both restores are correct with an explicit comparison — not just a clean exit code.
