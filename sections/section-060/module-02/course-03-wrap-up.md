# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Look back at what you learned, check yourself, and clean up.

## What you learned

This module was about keeping two directory trees in sync with `rsync`, and taking snapshots that share their unchanged files.

**From [Mirror A Directory Safely](./course-01-mirror-a-directory-safely.md):**

- `-a` is short for `-rlptgoD`: recursive, and it keeps symbolic links, permissions, times, group, owner and special files.
- A trailing slash on the source copies its contents; no slash copies the directory itself into the destination.
- `rsync` only adds by default. `--delete` makes a true mirror and removes what the source no longer has.
- Always preview `--delete` with `-n` and read every `*deleting` line.
- `--exclude` skips a path in both directions. Keep the exclude list the same on every run.

**From [Space-Efficient Snapshots With Link Dest](./course-02-space-efficient-snapshots-with-link-dest.md):**

- `--link-dest` hard-links files that are unchanged compared with the reference directory, and sends only new or changed files.
- A `--link-dest` snapshot is a complete directory you can browse on its own; a `tar` increment is a delta you must replay in order.
- The reference must be on the same filesystem as the destination, or `rsync` silently copies everything.
- `stat -c '%n %h'` shows a link count above 1 for shared files; `du -sh` against `du -sh --apparent-size` shows the savings.

## Your missions

| Mission | After the part | What you proved |
| --- | --- | --- |
| [rsync Mirroring & Snapshots Lab](../../../labs/lab-062/docs/question.md) | Space-Efficient Snapshots With Link Dest | mirrored a tree to another machine with a dry run, an exclude and `--delete`, then took a hard-linked snapshot |

If you skipped it, go back to it now. The exam asks for exactly these skills.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. What does <code>-a</code> stand for?</summary>

`-rlptgoD`: recursive, and it keeps symbolic links, permissions, modification times, group, owner and device or special files.
</details>

<details>
<summary>2. What is the difference between <code>rsync -a /photos/2024-shoot/ dest/</code> and <code>rsync -a /photos/2024-shoot dest/</code>?</summary>

With the trailing slash, the contents of `2024-shoot` land directly in `dest/`. Without it, `rsync` creates `dest/2024-shoot/` and puts the files there.
</details>

<details>
<summary>3. A file was deleted from the source. A normal <code>rsync -a</code> runs again. Is the file removed from the destination?</summary>

No. `rsync` only adds by default. You need `--delete` to make the destination a true mirror.
</details>

<details>
<summary>4. How do you check what <code>--delete</code> will remove before it removes anything?</summary>

Add `-n` (`--dry-run`) and read every line that starts with `*deleting`. Only then run the command without `-n`.
</details>

<details>
<summary>5. You used <code>--exclude=cache/</code> on the first sync and forgot it on the second, with <code>--delete</code>. What can go wrong?</summary>

Excluded paths are skipped in both directions. Without the exclude, the cache starts to sync, or files at the destination under that path can be deleted. Keep the exclude list the same on every run.
</details>

<details>
<summary>6. How does a <code>--link-dest</code> snapshot save space?</summary>

For each file that is unchanged compared with the reference directory, `rsync` makes a hard link to the existing inode instead of storing the content again. Only new or changed files take fresh space.
</details>

<details>
<summary>7. Your <code>--link-dest</code> snapshot saved no space at all. What is the most likely cause?</summary>

The reference directory is on a different filesystem from the destination. Hard links cannot cross filesystems, so `rsync` silently copied every file.
</details>

<details>
<summary>8. How do you prove that a snapshot file is hard-linked?</summary>

Run `stat -c '%n %h'` on it. A link count greater than 1 means another name points at the same inode.
</details>

## Clean up

When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the mission. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-062
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *Preview before you delete, keep your excludes the same, and let hard links carry what did not change.*
