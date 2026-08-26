# Solution Guide: find Triage by Criteria

This guide walks through a three-stage `find` cleanup: delete-by-age, then triage-by-size, then triage-by-permission.

---

## Step 1: Survey the directory

```bash
cd /var/backup/backup-015
ls -la
```

Get a baseline look before deleting or moving anything.

## Step 2: Delete files modified before 01/01/2020

```bash
find . -maxdepth 1 -type f ! -newermt "2020-01-01" -print
```

Run this first without `-delete` to preview exactly what would be removed. `-newermt "2020-01-01"` matches files newer than that date; `!` negates it to match everything at or before it — "modified before 01/01/2020." Once the preview looks right:

```bash
find . -maxdepth 1 -type f ! -newermt "2020-01-01" -delete
```

## Step 3: Create the destination directories

```bash
mkdir -p small large compromised
```

Creating these *after* the deletion pass, and using `-maxdepth 1` on every pass from here on, keeps later passes from recursing into them.

## Step 4: Move files smaller than 3KiB into `small/`

```bash
find . -maxdepth 1 -type f -size -3k -exec mv {} small/ \;
```

`-size -3k` means strictly less than 3 KiB (`find`'s `k` unit is 1024-byte blocks).

## Step 5: Move files larger than 10KiB into `large/`

```bash
find . -maxdepth 1 -type f -size +10k -exec mv {} large/ \;
```

Files already relocated to `small/` in Step 4 are gone from the top level, so there's no overlap.

## Step 6: Move files with permission 777 into `compromised/`

```bash
find . -maxdepth 1 -type f -perm 0777 -exec mv {} compromised/ \;
```

`-perm 0777` is an exact match on `rwxrwxrwx`. Anything already moved into `small/` or `large/` in prior steps is no longer at the top level, so it can't be double-processed here.

## Step 7: Confirm the split

```bash
ls -la small/ large/ compromised/
find . -maxdepth 1 -type f
```

> **Note:** Order matters here — a file that's both small and `777` gets caught by Step 4 (small) and never reaches the Step 6 permission check, since it's already out of the top-level directory by then. Reordering these steps changes the end result, so follow the sequence given rather than "optimizing" it.
