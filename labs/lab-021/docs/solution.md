# Solution Guide: chmod Permission Bits

This guide walks through setgid group inheritance, an owner-only lockdown, and the sticky bit.

---

## Step 1: Apply setgid to the shared reports directory

```bash
sudo chmod 2770 /srv/shared/reports
```

`2770` is the setgid special bit (`2000`) plus `770` (owner and group: full `rwx`, other: nothing). The leading fourth digit is the special-bits field — easy to drop by habit since three-digit modes are far more common. Setgid on a *directory* means every new file created inside automatically inherits the directory's group (`analysts`), regardless of the creating user's own primary group.

## Step 2: Lock down the owner-only script

```bash
sudo chmod 700 /opt/tools/backup-runner.sh
```

`700` grants the owner full read/write/execute and grants group and other nothing at all — exactly "owner-only, full stop."

## Step 3: Add the sticky bit to the shared dropbox

```bash
sudo chmod 1777 /srv/shared/dropbox
```

`1777` is the sticky bit (`1000`) plus `777`. On a directory, sticky restricts deletion/renaming of an entry to that entry's own owner (or root), even though the directory itself remains fully writable by everyone — plain `rwx` alone never provides this, since deleting a file is a directory-level operation that ordinary write access grants to everyone equally.

## Step 4: Verify every mode

```bash
stat -c '%a %A %n' /srv/shared/reports /opt/tools/backup-runner.sh /srv/shared/dropbox
```

Expect `2770 drwxrws---`, `700 -rwx------`, and `1777 drwxrwxrwt` respectively.

> **Note:** Setgid only affects files created *after* the bit is applied — it never retroactively relabels files that already existed in the directory. If a fresh test file still shows the wrong group, re-check that `2770` (not a plain `770`) actually landed with `stat -c '%A' /srv/shared/reports` (look for `s` in the group-execute position).
