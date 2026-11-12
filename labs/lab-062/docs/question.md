# Question

Solve this question on: `data-001`, syncing to `data-002`

Work on the machine `data-001`. It syncs to the second machine, `data-002`, over SSH.

Astronaut, two ships fly in formation. `data-001` holds a working tree at `/srv/appdata`. Mission control wants it mirrored to `/backup/appdata` on `data-002` over SSH.

1. Preview the sync safely first with a dry run. Nothing on `data-002` may change yet.
2. Run a real mirroring sync of `/srv/appdata` to `/backup/appdata` on `data-002` that:
   - Excludes the `tmp/` subdirectory entirely. It must not appear on `data-002` at all.
   - Uses `--delete`, so anything on `data-002` that no longer matches the source on `data-001` is removed. A stale leftover file from an old mirror is waiting there.
3. Take a second, later snapshot at `/backup/snapshots/snap2` on `data-002`, with `--link-dest=/backup/appdata` as the reference. Files that are unchanged since the mirror must be hard-linked, not copied again. The snapshot must still look like a complete copy of `/srv/appdata` that you can browse on its own.

The grader checks on `data-002` that:

- `/backup/appdata` holds `app.conf`, `data1.txt` and `data2.txt`, and `app.conf` has the same content as the source.
- `/backup/appdata/tmp` does not exist.
- The stale file `/backup/appdata/decommissioned-report.txt` is gone.
- `/backup/snapshots/snap2` holds `app.conf`, `data1.txt` and `data2.txt`, each with a link count greater than 1.
<!-- curriculum-links -->

## Related lessons and assessment

Read [module-02](../../../sections/section-060/module-02/course.md).

The grader checks:

- Confirms /backup/appdata contains an exact mirror of /srv/appdata's real files.
- Confirms tmp/ was excluded from the mirror entirely.
- Confirms the pre-existing stale file was removed by the --delete mirroring sync.
- Confirms a second snapshot exists at /backup/snapshots/snap2 and shares inodes with the mirror via --link-dest.

Use the inspection commands in the solution to check your work. Submit when you have finished; submission ends this environment.
