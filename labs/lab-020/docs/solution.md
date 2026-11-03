# Solution Walkthrough

This walkthrough puts four skills together on one workspace: a persistent `umask` for `opsuser`, three `chmod` targets, a four-pass `find` triage, and a release staged with file operations, links and group ownership. Each part is checked the same way the grader checks it.

---

## Step 1: Set a persistent umask for `opsuser`

The `umask` is the default lock setting on every new file. It takes the mask, not the result you want. With mask `027`, the file base gives `666 - 027 = 640` (the mask's `7` switches off every bit of the file's last `6`), and the directory base gives `777 - 027 = 750`. That is exactly the requirement.

The lab already has an empty `/home/opsuser/.bash_profile`, which a login shell reads at every login. Add the mask to it:

```bash
echo 'umask 027' | sudo tee -a /home/opsuser/.bash_profile
sudo chown opsuser:opsuser /home/opsuser/.bash_profile
```

```text
umask 027
```

`tee` repeats the line it appended, and `chown` keeps the file owned by `opsuser`.

---

## Step 2: Prove the mask in a fresh login

`sudo -iu opsuser` starts a fresh login shell for `opsuser`, which reads `~/.bash_profile` the way a new login does:

```bash
sudo -iu opsuser bash -lc 'touch ~/verify-file; mkdir ~/verify-dir; stat -c "%a %n" ~/verify-file ~/verify-dir'
```

```text
640 /home/opsuser/verify-file
750 /home/opsuser/verify-dir
```

The file came out `640` and the directory `750`, with no `chmod`.

---

## Step 3: Set the shared workspace permissions

All three paths belong to `root`, so each `chmod` needs `sudo`:

```bash
sudo chmod 2770 /srv/teamspace/shared
sudo chmod 700 /srv/teamspace/bin/deploy.sh
sudo chmod 1777 /srv/teamspace/dropbox
```

- `2770` is setgid (`2000`) plus `770`. New files created inside `/srv/teamspace/shared` get the directory's group, `ops`, whatever the creating user's own primary group is. The directory's group is already `ops`.
- `700` is owner-only: the group and everyone else get nothing.
- `1777` is sticky (`1000`) plus `777`. The folder stays writable by everyone, but only a file's owner, the folder's owner or root can delete that file. Plain `rwx` never gives this, because deleting a file is a directory operation.

Then check the result:

```bash
stat -c '%a %A %n' /srv/teamspace/shared /srv/teamspace/bin/deploy.sh /srv/teamspace/dropbox
```

```text
2770 drwxrws--- /srv/teamspace/shared
700 -rwx------ /srv/teamspace/bin/deploy.sh
1777 drwxrwxrwt /srv/teamspace/dropbox
```

---

## Step 4: Open a root shell for the triage

`/srv/teamspace/incoming` and its files belong to `root`, so your own user cannot delete or move them. Open a root shell with `sudo -i`, which lasts until you type `exit`, and go to the folder:

```bash
sudo -i
cd /srv/teamspace/incoming
```

---

## Step 5: Delete files older than the cutoff

Preview first, then delete:

```bash
find . -maxdepth 1 -type f ! -newermt "2021-06-01" -print
find . -maxdepth 1 -type f ! -newermt "2021-06-01" -delete
```

The preview should list exactly two files, `./legacy-audit.log` and `./legacy-notes.txt`, in any order.

---

## Step 6: Create the destinations, after the delete pass

```bash
mkdir -p archive/small archive/large quarantine
```

---

## Step 7: Sort by size, then by permission

Run the three passes in the order the task gives:

```bash
find . -maxdepth 1 -type f -size -2k -exec mv {} archive/small/ \;
find . -maxdepth 1 -type f -size +8k -exec mv {} archive/large/ \;
find . -maxdepth 1 -type f -perm 0777 -exec mv {} quarantine/ \;
```

`-maxdepth 1` on every pass keeps `find` out of `archive/small`, `archive/large` and `quarantine` once they exist. The order matters: `small-open.cfg` is both small and `777`, so the small pass claims it and it never reaches the permission pass. `big-open.bin` is large and `777`, and the large pass claims it the same way.

---

## Step 8: Stage the release

You are still in the root shell from Step 4, so these commands need no `sudo`. If you left it, run `sudo -i` again.

```bash
mkdir -p /srv/teamspace/releases/2026/q1
cp -p /srv/teamspace/release-src/app.conf /srv/teamspace/releases/2026/q1/
mv /srv/teamspace/release-src/old-release.txt /srv/teamspace/releases/2026/
ln /srv/teamspace/releases/2026/q1/app.conf /srv/teamspace/releases/app-hard.conf
ln -s 2026/q1 /srv/teamspace/releases/current
rm -r /srv/teamspace/release-src/tmp-build
chgrp -R ops /srv/teamspace/releases
```

- `mkdir -p` makes every missing parent folder in one command.
- `cp -p` keeps the mode and the modification time. A plain `cp` gives the copy the current time.
- `mv` moves the file, so the old place no longer has it.
- `ln` without `-s` makes a hard link: a second label on the same crate, so both names share one inode. Both names must be on the same filesystem.
- `ln -s 2026/q1` makes a symbolic link. The target is written relative to the folder that holds the link, so `current` resolves to `/srv/teamspace/releases/2026/q1`.
- `rm -r` removes a folder and everything inside it.
- `chgrp -R ops` changes the group of the folder and everything below it, and leaves the owner as `root`.

Check the result:

```bash
stat -c '%i %h %a %y %n' /srv/teamspace/release-src/app.conf /srv/teamspace/releases/2026/q1/app.conf /srv/teamspace/releases/app-hard.conf
readlink /srv/teamspace/releases/current
stat -c '%G %U %n' /srv/teamspace/releases /srv/teamspace/releases/2026/q1/app.conf
```

The copy and `app-hard.conf` show the same inode number and a link count of `2`. All three files show mode `640` and the same modification time. `readlink` prints `2026/q1`. The group column shows `ops` and the owner column shows `root`.

---

## Step 9: Check the full end state

```bash
sudo -iu opsuser bash -lc 'umask; touch ~/x; stat -c "%a" ~/x'
stat -c '%a %A %n' /srv/teamspace/shared /srv/teamspace/bin/deploy.sh /srv/teamspace/dropbox
ls -la /srv/teamspace/incoming/archive/small /srv/teamspace/incoming/archive/large /srv/teamspace/incoming/quarantine
find /srv/teamspace/incoming -maxdepth 1 -type f
```

Check the result against what the grader expects:

- The `opsuser` login shows the mask `0027`, and the new file is `640`.
- The three workspace modes are `2770`, `700` and `1777`, as in Step 3.
- `archive/small` holds `small-note.txt` and `small-open.cfg`.
- `archive/large` holds `big-dump.bin` and `big-open.bin`.
- `quarantine` holds `open-payload.sh` and `open-keys.env`.
- The top level holds exactly two files: `keep1.dat` and `keep2.dat`.
- `/srv/teamspace/releases` holds `2026/q1/app.conf`, `2026/old-release.txt`, `app-hard.conf` and the link `current`, all with group `ops`. `release-src` no longer holds `old-release.txt` or `tmp-build`.

Setgid only affects files created after the bit is set, and a `umask` has no effect on files that already exist. Neither one changes old files. If a check fails, confirm the mode really landed with `stat -c '%A'` before you assume the mechanism is broken.

---

## Step 10: Submit

Leave the root shell and the lab machine, then send the mission for grading:

```bash
exit
```

```bash
astrona submit -c labs/lab-020
```
