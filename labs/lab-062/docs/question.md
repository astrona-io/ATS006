# Question

Solve this question on: `data-001`, syncing to `data-002`

`data-001` holds a working tree at `/srv/appdata` that needs to be mirrored to `/backup/appdata` on `data-002` over SSH.

1. Preview the sync safely first with a dry run — nothing on `data-002` should change yet.
2. Perform a real mirroring sync of `/srv/appdata` to `/backup/appdata` on `data-002` that:
   - Excludes the `tmp/` subdirectory entirely (it must not appear on `data-002` at all).
   - Uses `--delete` so that anything already sitting on `data-002`'s side which no longer matches `data-001`'s source gets removed (there's a stale leftover file waiting there from a previous, now-obsolete mirror).
3. Take a second, later snapshot at `/backup/snapshots/snap2` on `data-002`, using `--link-dest=/backup/appdata` as the reference, so that files unchanged since the mirror are hardlinked rather than recopied — the snapshot should still look like a complete, independent, browsable copy of `/srv/appdata`.
