# Solution Guide: Permissions & File Triage Capstone

This guide combines a persistent umask, three `chmod` targets, and a three-stage `find` triage into one workspace setup.

---

## Part 1: Persistent umask for `opsuser`

```bash
echo 'umask 027' | sudo tee -a /home/opsuser/.bash_profile
sudo chown opsuser:opsuser /home/opsuser/.bash_profile
```

`umask` takes the *mask*, not the desired result: file base `666 - 027 = 640`, directory base `777 - 027 = 750` — exactly the requirement. Verify with a fresh login shell:

```bash
sudo -iu opsuser bash -lc 'touch ~/verify-file; mkdir ~/verify-dir; stat -c "%a %n" ~/verify-file ~/verify-dir'
```

## Part 2: Shared workspace permissions

```bash
sudo chmod 2770 /srv/teamspace/shared
sudo chmod 700 /srv/teamspace/bin/deploy.sh
sudo chmod 1777 /srv/teamspace/dropbox
```

- `2770` = setgid (`2000`) + `770`. New files created inside `/srv/teamspace/shared` automatically belong to group `ops`, regardless of the creating user's own primary group.
- `700` = owner-only, full stop — group and other get nothing.
- `1777` = sticky (`1000`) + `777`. The directory stays fully writable by everyone, but only a file's own owner (or root) can delete it — plain `rwx` alone never provides this, since deletion is a directory-level operation.

Verify:

```bash
stat -c '%a %A %n' /srv/teamspace/shared /srv/teamspace/bin/deploy.sh /srv/teamspace/dropbox
```

## Part 3: Triage `/srv/teamspace/incoming`

```bash
cd /srv/teamspace/incoming

# Step 1: delete anything older than the cutoff (preview first)
find . -maxdepth 1 -type f ! -newermt "2021-06-01" -print
find . -maxdepth 1 -type f ! -newermt "2021-06-01" -delete

# Step 2: create destinations only after the delete pass
mkdir -p archive/small archive/large quarantine

# Step 3: small files first
find . -maxdepth 1 -type f -size -2k -exec mv {} archive/small/ \;

# Step 4: then large files
find . -maxdepth 1 -type f -size +8k -exec mv {} archive/large/ \;

# Step 5: then permission-777 files
find . -maxdepth 1 -type f -perm 0777 -exec mv {} quarantine/ \;
```

`-maxdepth 1` on every pass keeps `find` from recursing into `archive/small`, `archive/large`, or `quarantine` once they exist. Following the stated order matters: a file that is both small and `777` is claimed by the size pass first and never reaches the permission pass, since it's already relocated out of the top level by then — the same applies to a large-and-777 file being claimed by the large pass first.

## Verify the full end-state

```bash
sudo -iu opsuser bash -lc 'umask; touch ~/x; stat -c "%a" ~/x'
stat -c '%a %A %n' /srv/teamspace/shared /srv/teamspace/bin/deploy.sh /srv/teamspace/dropbox
ls -la /srv/teamspace/incoming/archive/small /srv/teamspace/incoming/archive/large /srv/teamspace/incoming/quarantine
find /srv/teamspace/incoming -maxdepth 1 -type f
```

> **Note:** Setgid only affects files created *after* the bit is applied, and a per-user umask has zero effect on files that already exist — neither one is retroactive. If a check fails, re-verify the mode was actually set (`stat -c '%A'`) before assuming the underlying mechanism is broken.
