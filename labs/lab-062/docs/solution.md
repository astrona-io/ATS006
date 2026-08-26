# Solution Guide: rsync Mirroring & Snapshots

This guide shows you how to safely mirror a tree over SSH with `--delete` and take a space-efficient `--link-dest` snapshot afterward.

---

## Step 1: Confirm SSH connectivity from data-001

```bash
ssh data-002 'echo connected'
```

Passwordless, key-based access to `data-002` is already wired up — `rsync -e ssh` needs this to run without an interactive password prompt.

---

## Step 2: Dry-run the mirroring sync

```bash
rsync -avzn --delete --exclude=tmp/ -e ssh /srv/appdata/ data-002:/backup/appdata/
```

`-n` (`--dry-run`) previews every transfer and deletion without touching `data-002`. Read every `*deleting` line before proceeding — this is the non-negotiable safety habit `--delete` always requires.

---

## Step 3: Run the real mirroring sync

```bash
rsync -avz --delete --exclude=tmp/ -e ssh /srv/appdata/ data-002:/backup/appdata/
```

The trailing slash on `/srv/appdata/` syncs its *contents* directly into `/backup/appdata/`, not into a nested `appdata/appdata/`. `--delete` removes the stale leftover file that no longer exists on the source; `--exclude=tmp/` keeps the scratch directory out of the mirror entirely.

---

## Step 4: Confirm the mirror matches the source

```bash
ssh data-002 'ls /backup/appdata'
rsync -avzn --delete --exclude=tmp/ -e ssh /srv/appdata/ data-002:/backup/appdata/
```

A clean second dry run reporting no changes confirms the mirror is fully in sync.

---

## Step 5: Take a space-efficient snapshot with --link-dest

```bash
ssh data-002 'mkdir -p /backup/snapshots/snap2'
rsync -avz --exclude=tmp/ -e ssh --link-dest=/backup/appdata /srv/appdata/ data-002:/backup/snapshots/snap2/
```

For every file unchanged since `/backup/appdata`, rsync hardlinks it into the snapshot instead of copying it again. The `--link-dest` reference directory must be on the same filesystem as the destination for hardlinking to actually happen — otherwise rsync silently falls back to full copies.

---

## Step 6: Verify the snapshot is a real hardlinked copy

```bash
ssh data-002 "stat -c '%n %h' /backup/snapshots/snap2/*"
ssh data-002 "du -sh /backup/appdata /backup/snapshots/snap2"
```

An unchanged file should show a link count (`%h`) greater than 1. `du -sh` on the snapshot should be far smaller than a full independent copy would be.

**Note:** never drop `--delete` without first reading a dry run's output — it's the only command in this lab that can permanently remove data if the source and destination are ever reversed.
