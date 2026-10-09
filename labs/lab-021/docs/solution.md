# Solution Walkthrough

This walkthrough sets three modes: setgid on the team directory, owner-only on the script, and the sticky bit on the drop folder. Then it proves each one, the same way the grader does.

All three paths belong to `root`, so every `chmod` needs `sudo`.

---

## Step 1: Read the starting state

Look at the current modes first, so you know what you are changing. `stat -c '%a %A %n'` prints the octal mode, the same mode as letters, and the path:

```bash
stat -c '%a %A %n' /srv/shared/reports /opt/tools/backup-runner.sh /srv/shared/dropbox
```

```text
770 drwxrwx--- /srv/shared/reports
664 -rw-rw-r-- /opt/tools/backup-runner.sh
777 drwxrwxrwx /srv/shared/dropbox
```

The reports directory has the right base bits but no setgid. The script can be changed by its group and read by everyone. The drop folder is open to everyone, with no sticky bit.

---

## Step 2: Apply setgid to the shared reports directory

```bash
sudo chmod 2770 /srv/shared/reports
```

`2770` is the setgid bit (`2000`) plus `770`: the owner and the group get full `rwx`, everyone else gets nothing. The fourth digit holds the special bits, and it is easy to drop by habit because three-digit modes are so common.

Setgid on a directory means every new file created inside gets the directory's group, `analysts`, whatever the creating user's own primary group is. The directory's group is already `analysts`, so you do not need `chown`.

---

## Step 3: Lock the script to its owner

```bash
sudo chmod 700 /opt/tools/backup-runner.sh
```

`700` gives the owner full read, write and execute, and gives the group and everyone else nothing at all.

---

## Step 4: Add the sticky bit to the drop folder

```bash
sudo chmod 1777 /srv/shared/dropbox
```

`1777` is the sticky bit (`1000`) plus `777`. On a directory, the kernel then lets only a file's owner, the directory's owner or root delete or rename that file, even though everyone can still write into the directory. Plain `rwx` never gives this protection, because deleting a file is a directory operation that write access grants to everyone.

---

## Step 5: Check every mode

```bash
stat -c '%a %A %n' /srv/shared/reports /opt/tools/backup-runner.sh /srv/shared/dropbox
```

```text
2770 drwxrws--- /srv/shared/reports
700 -rwx------ /opt/tools/backup-runner.sh
1777 drwxrwxrwt /srv/shared/dropbox
```

The `s` in the group's execute slot is setgid, and the lowercase `t` at the end is the sticky bit.

---

## Step 6: Prove the group inheritance

The grader creates a file as `someanalyst` and checks its group. Do the same. Your own user is "other" for this directory and gets nothing, so the check and the cleanup need `sudo`:

```bash
sudo -u someanalyst touch /srv/shared/reports/inheritance-test
sudo stat -c '%G' /srv/shared/reports/inheritance-test
sudo rm -f /srv/shared/reports/inheritance-test
```

```text
analysts
```

The new file belongs to `analysts`, so setgid works.

Setgid only affects files created after the bit is set. If a new test file shows the wrong group, check that `2770` really landed, not a plain `770`: run `stat -c '%A' /srv/shared/reports` and look for the `s` in the group's execute slot.

---

## Step 7: Submit

Leave the lab machine and send the mission for grading:

```bash
astrona submit -c labs/lab-021
```
