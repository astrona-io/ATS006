# Solution Walkthrough

The fuel gauge (`df`) says the log deck is full, but counting the crates you can see (`du`) finds almost nothing. A crate was taken off the manifest while a crew member still holds it. Find that crew member, then free the space without touching the real logs.

## Step 1: Confirm which filesystem is full

```bash
df -h /var/log/reporting-app
```

`df` reports the filesystem that holds this directory. Write down the "Use%" value. You compare against it later to prove that the fix worked.

## Step 2: Confirm that du disagrees with df on the same filesystem

```bash
du -xsh /var/log/reporting-app
```

`-x` keeps the walk on this one filesystem, and `-s` prints one total. The three legitimate log files are 4 MB each, so `du` reports a total of roughly that size. If this number is far smaller than the "Used" value from `df`, stop looking at the visible files and look for a deleted file that is still open.

## Step 3: Find the process that holds a deleted file open

```bash
sudo lsof +L1
```

`+L1` lists open files with a link count below 1: deleted from the directory tree, but still held by a running process. Look for the entry under `/var/log/reporting-app`. Its file name is `current.log`, and the command belongs to the `reporting-app` service. Write down its PID and its file descriptor number (the `FD` column, the number without the letter after it).

## Step 4: Reclaim the space without a restart

Replace `<PID>` and `<N>` with the numbers from Step 3. First check that the descriptor really points at the deleted file:

```bash
sudo ls -l /proc/<PID>/fd/<N>
```

The link target ends with `(deleted)`. Now empty the file through the process's own descriptor:

```bash
sudo truncate -s 0 /proc/<PID>/fd/<N>
```

The process keeps running. Its next write lands in a file that is now empty.

If a restart is acceptable, this fixes it as well:

```bash
sudo systemctl restart reporting-app
```

`systemd` stops the process, which closes the old descriptor. With no name and no open descriptor left, the kernel frees the blocks.

## Step 5: Confirm the fix

```bash
df -h /var/log/reporting-app
sudo lsof +L1 | grep -i reporting
ls -la /var/log/reporting-app
```

Check three things:

- `df -h` shows usage far below the value from Step 1. The grader wants 50% or less.
- `lsof +L1` shows no more large deleted `reporting-app` file.
- `reporting-app.log.1`, `.2` and `.3` are still there.

Never fix this by deleting more files in the directory. The lost space belongs to an inode with no name left, so `rm` cannot reach it.

## Step 6: Submit

```sh
astrona submit -c labs/lab-061
```
