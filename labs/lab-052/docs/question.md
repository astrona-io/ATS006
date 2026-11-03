# Question

Solve this question on: `terminal` (playing the role of `data-001` from the scenario)

Astronaut, this training ship carries two kinds of cargo worth protecting: its configuration in `/etc`, and a data directory `/srv/appdata`. Inside `/srv/appdata` there is a `cache/` subdirectory that rebuilds itself and must never be backed up. Mission control wants a real backup strategy, not a single copy: a full backup, a true incremental backup, and two restores you can prove.

1. Take a full backup of both `/etc` and `/srv/appdata`:
   - Keep permissions, ownership and symbolic links.
   - Leave out `/srv/appdata/cache`.
   - Store it at `/backup/full-backup.tar.gz`, with relative paths (not absolute ones).
   - Use the snapshot file `/backup/snapshot.snar`, so this full backup is the starting point of the incremental chain below.
2. Simulate a day passing: append the exact line `Q3 restock complete` to `/srv/appdata/notes.txt`, and create a new empty file `/srv/appdata/new-shipment.csv`.
3. Take a true incremental backup that captures only what changed since the full backup, not a second full copy. Reuse the same snapshot file `/backup/snapshot.snar`, store the archive at `/backup/incr-backup.tar.gz`, and use the same exclude and permission handling as in step 1. It must be smaller than the full backup, and it must not contain the untouched `srv/appdata/reports/2026-Q2-summary.csv`.
4. Restore the full backup **alone** into `/restore/full`.
5. Restore the full backup **and then layer the incremental backup on top of it** into `/restore/incremental`, so it shows the state after the changes in step 2.
6. Prove with an explicit comparison (not just a clean exit code) that both restores are correct. The restored `etc/` in both directories must match the live `/etc`, and the restored `etc/shadow` must keep the mode and owner of the live `/etc/shadow`.
