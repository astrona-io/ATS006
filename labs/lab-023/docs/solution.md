# Solution Walkthrough

This walkthrough runs a four-pass `find` cleanup in the order the task gives: delete by age, then sort by size, then quarantine by permission. `-maxdepth 1` on every pass keeps each pass in the top level, so no pass touches files an earlier pass already moved.

---

## Step 1: Open a root shell and survey the folder

`/var/backup/backup-015` and the files in it belong to `root`, so your own user cannot delete or move them. Open a root shell first. `sudo -i` borrows the captain's authority until you type `exit`:

```bash
sudo -i
cd /var/backup/backup-015
ls -la
```

Get a baseline look before you delete or move anything. You should see ten files and no subfolders yet.

---

## Step 2: Delete files modified before 01/01/2020

Preview first, without `-delete`:

```bash
find . -maxdepth 1 -type f ! -newermt "2020-01-01" -print
```

`-newermt "2020-01-01"` matches files modified after the start of that date, and `!` turns it around to match everything at or before it. The preview should list exactly two files, `./ancient-report.log` and `./ancient-notes.txt`, in any order. Once the preview looks right, delete them:

```bash
find . -maxdepth 1 -type f ! -newermt "2020-01-01" -delete
```

---

## Step 3: Create the destination folders

```bash
mkdir -p small large compromised
```

Creating these after the delete pass, and using `-maxdepth 1` on every pass from here on, keeps later passes from walking into them.

---

## Step 4: Move files smaller than 3KiB into `small/`

```bash
find . -maxdepth 1 -type f -size -3k -exec mv {} small/ \;
```

`-size -3k` means smaller than 3 KiB. `find`'s `k` unit is 1024 bytes, and it rounds each size up to whole units before it compares.

---

## Step 5: Move files larger than 10KiB into `large/`

```bash
find . -maxdepth 1 -type f -size +10k -exec mv {} large/ \;
```

Files already moved to `small/` are gone from the top level, so there is no overlap.

---

## Step 6: Move files with permission 777 into `compromised/`

```bash
find . -maxdepth 1 -type f -perm 0777 -exec mv {} compromised/ \;
```

`-perm 0777` is an exact match on `rwxrwxrwx`. Anything already moved into `small/` or `large/` is no longer in the top level, so this pass cannot move it a second time.

---

## Step 7: Confirm the split

```bash
ls -la small/ large/ compromised/
find . -maxdepth 1 -type f
```

Check the result against what the grader expects:

- `small/` holds `tiny-config.ini` and `tiny-and-open.conf`.
- `large/` holds `huge-dump.bin` and `huge-open.log`.
- `compromised/` holds `open-script.sh` and `open-secrets.env`.
- The top level still holds exactly two files: `medium-keep1.dat` and `medium-keep2.dat`.

Order matters here. `tiny-and-open.conf` is both small and `777`. The size pass in Step 4 claims it, so it never reaches the permission pass in Step 6. `huge-open.log` is large and `777`, and Step 5 claims it the same way. Reordering the steps changes the end result, so follow the sequence the task gives.

---

## Step 8: Submit

Leave the root shell and the lab machine, then send the mission for grading:

```bash
exit
```

```bash
astrona submit -c labs/lab-023
```
