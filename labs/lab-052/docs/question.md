# Question

Solve this question on: `terminal` (playing the role of `data-001` from the scenario)

This host holds `/etc` (configuration worth protecting) and a data directory `/srv/appdata` that includes a `cache/` subdirectory that regenerates itself and should never be backed up.

1. Take a full backup of both `/etc` and `/srv/appdata`, preserving permissions/ownership/symlinks correctly, excluding `/srv/appdata/cache`. Store it at `/backup/full-backup.tar.gz`, with paths stored relative (not absolute), and use a snapshot file at `/backup/snapshot.snar` so this full backup establishes the baseline for the incremental chain below.
2. Simulate a day passing: append the exact line `Q3 restock complete` to `/srv/appdata/notes.txt`, and create a new empty file `/srv/appdata/new-shipment.csv`.
3. Take a true incremental backup capturing only what changed since the full backup — not a second full copy. Reuse the same snapshot file at `/backup/snapshot.snar` from Step 1 and store the incremental archive at `/backup/incr-backup.tar.gz`, with the same exclude and permission-preservation as Step 1.
4. Restore the full backup **alone** into `/restore/full`.
5. Restore the full backup **and then layer the incremental backup on top of it** into `/restore/incremental`, reconstructing the state as of Step 2's changes.
6. Prove with an explicit comparison (not just a clean exit code) that both restores are correct.
