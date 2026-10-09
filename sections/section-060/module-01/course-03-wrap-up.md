# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Look back at what you learned, check yourself, and clean up.

## What you learned

This module was about a full filesystem that `du` cannot explain, and how to win the space back.

**From [Two Ways Of Counting Space](./course-01-two-ways-of-counting-space.md):**

- `df` reads the filesystem's own bookkeeping of blocks in use. `du` walks the tree and adds up the files it can find by name.
- `du -xsh` stays on one filesystem (`-x`) and prints one total (`-s`).
- `rm` removes a name and lowers the link count. The kernel frees the blocks only when the link count is zero **and** no process holds the file open.
- A deleted file that is still open counts in `df` but is invisible to `du`.

**From [Find And Reclaim The Lost Space](./course-02-find-and-reclaim-the-lost-space.md):**

- `sudo lsof +L1` lists open files with a link count below 1: deleted, but still held open.
- `/proc/<PID>/fd/` shows each open descriptor; a deleted target ends with `(deleted)`, and the link still works.
- `sudo truncate -s 0 /proc/<PID>/fd/<N>` empties the file live, with no restart.
- `sudo systemctl restart <service-name>` closes the old descriptor, and the kernel frees the blocks.
- Deleting more visible files never helps.

## Your missions

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Diskspace Troubleshooting Lab](../../../labs/lab-061/docs/question.md) | Find And Reclaim The Lost Space | found a deleted file held open and reclaimed the space without deleting real logs |

If you skipped it, go back to it now. The exam asks for exactly this skill.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. <code>df</code> says a filesystem is 98% full, and <code>du -xsh</code> on it reports a few megabytes. What is the most likely cause?</summary>

A file was deleted while a process still held it open. The filesystem still counts its blocks, but `du` cannot find it because it has no name left.
</details>

<details>
<summary>2. Why do you add <code>-x</code> to <code>du</code> for this comparison?</summary>

`-x` keeps `du` on one filesystem. Without it, `du` also counts other filesystems mounted below the directory, and the comparison with `df` means nothing.
</details>

<details>
<summary>3. When does the kernel free a deleted file's blocks?</summary>

When the link count is zero (no name left) **and** no process still holds the file open.
</details>

<details>
<summary>4. Which command lists deleted files that are still open?</summary>

`sudo lsof +L1`. It shows open files with a link count below 1, with the command, PID, file descriptor and size.
</details>

<details>
<summary>5. How do you free the space without restarting the process?</summary>

Truncate the file through the process's own descriptor: `sudo truncate -s 0 /proc/<PID>/fd/<N>`. The process keeps running and writes into the now empty file.
</details>

<details>
<summary>6. Why does a restart of the service also fix it?</summary>

The old process closes its file descriptor when it stops. Both counters reach zero, and the kernel frees the blocks.
</details>

<details>
<summary>7. A colleague wants to run <code>rm -rf</code> over the log directory to free space. Will it help?</summary>

No. The lost space belongs to an inode with no name left, so `rm` cannot reach it. It would only delete logs that may still be needed.
</details>

## Clean up

When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the mission. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-061
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *`df` reads the gauge, `du` counts the crates; when they disagree, look for a crate someone still holds.*
