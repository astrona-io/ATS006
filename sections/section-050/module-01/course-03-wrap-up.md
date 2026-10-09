# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Before you move on, look back at what you learned, check yourself, and leave no training ship running.

## What you learned

This module was about repacking a sealed shipping container with a different vacuum-packer, and proving that every crate survived the move.

**From [Archives And Compressors](./course-01-archives-and-compressors.md):**

- `tar` builds the archive. An outside program (`gzip`, `bzip2` or `xz`) does the compression. `-z`, `-j` and `-J` only pick which one `tar` pipes through.
- `tar -czf` always runs `gzip` at its default level 6. For the best level, use `--use-compress-program="gzip -9"`.
- Byte 8 of the gzip header proves the level: `2` for level 9, `4` for level 1, `0` for anything in between.
- `tar -tf` lists an archive without writing anything to disk.

**From [Convert And Prove](./course-02-convert-and-prove.md):**

- Sorted listings plus `diff` prove two archives hold the same files. An empty `diff` means they match.
- Without `sort`, two good archives can look different, because `tar -t` prints entries in storage order.
- Extract into a separate staging directory with `-C`, repack from inside it with `.`, and only ever read the original.
- `bzip2 -dc archive.tar.bz2 | gzip -9 > archive.tar.gz` changes only the outer compression and never runs `tar`.

## Your missions

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Archive Conversion & Verification Lab](../../../labs/lab-051/docs/question.md) | Convert And Prove | converted a bzip2 archive to level 9 gzip, with matching sorted listings and the original untouched |

If you skipped it, go back to it now. It is short, and the exam asks for exactly this skill.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. Which program compresses the data when you run <code>tar -czf out.tar.gz files/</code>?</summary>

`gzip`. `tar` only builds the archive stream and pipes it through `gzip` because of the `-z` flag.
</details>

<details>
<summary>2. A task asks for the best possible gzip compression. Why is <code>tar -czf</code> not enough?</summary>

`-z` starts `gzip` with its default level 6 and has no way to pass `-9`. Use `--use-compress-program="gzip -9"` instead.
</details>

<details>
<summary>3. How can you prove after the fact that a gzip file was made at level 9?</summary>

Read byte 8 of the gzip header, the extra flags byte, for example with `od -An -tu1 -j8 -N1 file.tar.gz`. A value of `2` means level 9.
</details>

<details>
<summary>4. Two archives hold the same files, but <code>diff</code> on their listings shows many lines. What went wrong?</summary>

The listings were not sorted. `tar -t` prints entries in the order they were written, which often differs between two archives. Pipe both listings through `sort` before `diff`.
</details>

<details>
<summary>5. Why extract into a staging directory with <code>-C</code> when you convert an archive?</summary>

So nothing lands near the original archive, which `tar` only opens for reading. It also lets you repack from inside the staging directory with `.`, so the new archive keeps relative paths.
</details>

<details>
<summary>6. When can you skip <code>tar</code> completely during a conversion?</summary>

When you only change the outer compression of an existing `.tar` stream: `bzip2 -dc archive.tar.bz2 | gzip -9 > archive.tar.gz`.
</details>

## Clean up

Each mission runs as a virtual machine on your computer. When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the mission. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-051
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *List before you trust, sort before you compare, and never write to the original.*
