# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Before you move on, look back at what you learned, check yourself, and land your lab machine cleanly.

## What you learned

This module was about `find`, your cargo search drone: the tests that describe a file, the actions that change it, and the order that keeps several passes from fighting each other.

**From [Matching Files By Age, Size And Permission](./course-01-matching-files-by-age-size-and-permission.md):**

- `-mtime` counts days back from now. For a calendar date, use `! -newermt "YYYY-MM-DD"` to match files modified at or before it.
- Preview with `-print` before you add `-delete` or `-exec`.
- `-size 3k` means exactly, `-3k` smaller, `+3k` larger, in KiB, after rounding the size up to whole units.
- `-exec cmd {} \;` runs once per file. The `+` form batches files, and needs `{}` last, so `mv` uses `-t`.
- `-perm 0777` is an exact match, `-perm -0002` needs all listed bits, `-perm /022` needs any listed bit.

**From [Triage In The Right Order](./course-02-triage-in-the-right-order.md):**

- Create destination folders after any delete pass, and use `-maxdepth 1` on every pass.
- Delete before you sort, or old files survive inside subfolders.
- A file that fits two rules goes to the first pass that matches it.
- Follow the order a task gives; it exists to prevent overlap.

## Your missions

You proved the skills in a graded mission, right after the part that taught them:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [find Triage by Criteria Lab](../../../labs/lab-023/docs/question.md) | Triage In The Right Order | deleted files by date, then sorted the rest by size and by exact permission, in order |

If you skipped it, go back to it now. It is short, and the exam asks for exactly this skill.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. A task says "delete files modified before 01/01/2020". Which test do you use?</summary>

`! -newermt "2020-01-01"`. `-newermt` compares with a fixed date, and `!` turns it into "not newer than the cutoff". `-mtime` counts days from now and drifts.
</details>

<details>
<summary>2. What is the difference between <code>-size 3k</code>, <code>-size -3k</code> and <code>-size +3k</code>?</summary>

Exactly 3 KiB, less than 3 KiB and more than 3 KiB. The size is rounded up to whole KiB first, so a 2.5 KiB file counts as 3.
</details>

<details>
<summary>3. Why is <code>-delete</code> safer than piping names to <code>xargs rm</code>?</summary>

`-delete` only removes files `find` itself matched. There is no shell word-splitting in between that could break a name with spaces into several names.
</details>

<details>
<summary>4. You want every file that others can write to, whatever else is set. Do you use <code>-perm 0002</code> or <code>-perm -0002</code>?</summary>

`-perm -0002`. The `-` prefix means "all these bits are set", whatever else is set. A bare `0002` only matches files whose mode is exactly `0002`.
</details>

<details>
<summary>5. You created <code>small/</code> and <code>large/</code> first, and ran the size passes without <code>-maxdepth 1</code>. What can go wrong?</summary>

`find` walks into the destination folders and can match files that are already sorted, moving them again, sometimes into the wrong folder.
</details>

<details>
<summary>6. A file is both small and mode <code>777</code>. The task says: sort by size, then quarantine by permission. Where does the file end up?</summary>

In the small folder. The size pass runs first and moves it out of the top level, so the permission pass with `-maxdepth 1` never sees it.
</details>

<details>
<summary>7. What is wrong with <code>find . -type f -exec mv {} small/ +</code>?</summary>

With the `+` form, `{}` must come last, right before `+`. Use `find . -type f -exec mv -t small/ {} +`.
</details>

## Practise on your own

Repeat the full method without help:

1. Build a test folder with a spread of modification dates (some old, some recent), a spread of sizes (tiny, large and in between), and at least one file with mode `777`.
2. Preview an absolute-date cutoff with `-newermt` and `-print`, and confirm the list matches your expectation before you add `-delete`.
3. Delete the old files first, then create the destination folders. Explain out loud why that order matters before the next pass runs.
4. Sort by size into two folders using `-maxdepth 1`, then by permission into a third. Confirm with a final `find -maxdepth 1 -type f` that nothing wrongly sorted is left at the top level.
5. Create one file that fits two rules, for example small and `777`. Run the passes in order and confirm it lands where the first matching pass puts it.

## Clean up

When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the lab. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-023
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

You can start the mission again at any time with the `astrona run` command. It always starts clean, so nothing you broke carries over.

> *Preview, delete, then sort: and let the first pass that matches a file keep it.*
