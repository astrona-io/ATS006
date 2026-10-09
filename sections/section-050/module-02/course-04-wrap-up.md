# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Before you move on, look back at what you learned, check yourself, and leave no training ship running.

## What you learned

This module turned one backup command into a strategy: keep the locks, leave the disposable crates behind, ship only what changed, and prove every restore.

**From [Permissions And Excludes](./course-01-permissions-and-excludes.md):**

- `-p` keeps mode bits, ownership and symbolic links. Use it on the backup and on the restore, and run both with `sudo`.
- `--exclude` matches the path as stored in the archive. After `-C /` that path is relative, so a leading slash matches nothing.
- An exact path excludes one directory. A bare name such as `cache` excludes every match at any level.
- `-C /` with relative paths makes the archive safe to restore into any scratch directory.

**From [Full And Incremental Backups](./course-02-full-and-incremental-backups.md):**

- `--listed-incremental=<snapshot-file>` on the first run makes a full (level 0) backup and creates the snapshot file.
- The next run with the same snapshot file archives only new and changed files, and is clearly smaller.
- A lost or different snapshot file silently turns the next run into another full backup. Check the archive size.

**From [Restore And Prove](./course-03-restore-and-prove.md):**

- A clean exit code from `tar -x` proves nothing about the result.
- `diff -r` proves content. `stat -c '%a %U:%G'` proves permissions and owners.
- Restore the full backup first, then each incremental on top of the same directory, in order.

## Your missions

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [tar Backup Strategy Lab](../../../labs/lab-052/docs/question.md) | Restore And Prove | took a full and a true incremental backup with a cache excluded, and proved both restores |

If you skipped it, go back to it now. It is the kind of task the exam gives you.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. Why does <code>-p</code> belong on both the backup and the restore?</summary>

On the backup it records the original modes, owners and links in the archive. On the restore it puts them back. Leaving it off either side can lose permissions.
</details>

<details>
<summary>2. You archive with <code>-C / var/www/uploads</code> and <code>--exclude=/var/www/uploads/cache</code>. What happens?</summary>

The cache is backed up anyway. The stored path is the relative `var/www/uploads/cache`, so the pattern with a leading slash matches nothing, and no error appears.
</details>

<details>
<summary>3. What is the difference between <code>--exclude=var/www/uploads/cache</code> and <code>--exclude=cache</code>?</summary>

The first leaves out that one relative path. The second leaves out anything named `cache` at any level, including directories you did not mean.
</details>

<details>
<summary>4. Why is the first backup with <code>--listed-incremental</code> a full backup?</summary>

The snapshot file does not exist yet, so `tar` has nothing to compare against. It archives everything and creates the snapshot file for the next run.
</details>

<details>
<summary>5. Your nightly "incremental" archive is as big as the full one. What is the likely cause?</summary>

The snapshot file was lost, deleted or given a different path. `tar` then makes a fresh full backup and still reports success.
</details>

<details>
<summary>6. <code>tar -xzpf</code> exited with 0. Is the restore correct?</summary>

You do not know yet. Compare the content with `diff -r` and the permissions with `stat` against the original.
</details>

<details>
<summary>7. In which order do you restore a full backup and two incrementals?</summary>

Full backup first, then the first incremental, then the second, all into the same destination directory.
</details>

## Clean up

Each mission runs as a virtual machine on your computer. When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the mission. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-052
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *Keep the locks, guard the snapshot file, and never call a backup good until you have restored it and compared.*
