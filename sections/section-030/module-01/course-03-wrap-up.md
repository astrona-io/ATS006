# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Before you move on, look back at what you learned, practise once more on your own, check yourself, and clean up.

## What you learned

This module was about describing the shape of a line, then letting `grep` find it and `sed` rewrite it.

**From [Patterns: Describing A Shape](./course-01-patterns-describing-a-shape.md):**

- A regular expression describes the shape of a line. Without anchors it matches anywhere on the line.
- `^` pins a match to the start of the line, and `$` pins it to the end.
- `.` matches any one character, and `.*` matches any run of characters, including none. A real dot is written `\.`.
- Basic expressions need a backslash before `|` and `+`. `grep -E` and `sed -E` switch to extended expressions, where they work directly.

**From [Extract With grep, Redact With sed](./course-02-extract-with-grep-redact-with-sed.md):**

- For two independent conditions, chain two `grep` commands with a pipe. One combined pattern misses lines where the order differs.
- `sed 's/^...$/TEXT/'` with an anchored pattern replaces the whole line.
- `sed` without `-i` only previews. `sed -i` overwrites the file, with no undo.
- `grep 'X' file > file` empties the file before `grep` reads it. Always write to a new file.

## Your missions

You proved the skills in a graded mission, right after the part that taught them:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [grep & sed Text Processing Lab](../../../labs/lab-031/docs/question.md) | Extract With grep, Redact With sed | extracted lines that meet two conditions, and redacted whole lines without touching the rest |

If you skipped it, go back to it now. It is short, and the exam asks for exactly these skills.

## Practise on your own

Try this on any Ubuntu machine to prove you can combine both tools with confidence:

1. Create a small text file with at least eight lines that mix several message types. For example, lines that start with `auth:`, `net:` and `disk:`, each ending in either `OK` or `FAIL`.
2. Using two piped `grep` commands, extract only the lines that start with `auth:` **and** end in `FAIL`, and redirect the result into a new file. Confirm the original file is untouched: `wc -l` shows the same line count as before.
3. Write a `sed -E` substitution that matches every line that starts with `net:` and ends in `FAIL`, with anything in between. Preview it (no `-i`) and confirm only the intended lines would change.
4. Apply the same substitution with `-i`, replacing each matching line with the literal text `NETWORK EVENT REDACTED`.
5. Run `grep -c` for your replacement text and confirm the count matches the number of lines you expected to redact in step 3.
6. Run your step 3 pattern again against the changed file and confirm it prints **no** output. That proves every matching line was redacted.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. Which lines does <code>grep '^error' status.log</code> leave out that <code>grep 'error' status.log</code> prints?</summary>

`grep 'error'` prints every line with `error` anywhere in it. `grep '^error'` prints only the lines that *start* with `error`, so a line like `info: error count is zero` is left out.
</details>

<details>
<summary>2. Why write <code>service\.</code> instead of <code>service.</code> in a pattern?</summary>

A bare `.` matches any one character, so `service.` also matches `serviceXrestart`. `\.` matches only a real dot.
</details>

<details>
<summary>3. You need <code>|</code> to mean "either or". What do you add to <code>grep</code>?</summary>

`-E`, for extended regular expressions: `grep -E 'error|warning' app.log`. Without it, you must write `error\|warning`.
</details>

<details>
<summary>4. Why is <code>grep 'ERROR' syslog | grep 'disk-full'</code> safer than <code>grep '.*ERROR.*disk-full.*' syslog</code>?</summary>

The combined pattern only matches when `ERROR` comes before `disk-full`. The piped form checks each condition on its own, in any order, so no matching line is silently dropped.
</details>

<details>
<summary>5. How do you make <code>sed</code> replace the whole line, not just the matching word?</summary>

Anchor the pattern to the whole line with `^` at the start and `$` at the end, for example `s/^service\..*restart$/MAINTENANCE EVENT/`.
</details>

<details>
<summary>6. What is the difference between <code>sed 's/.../.../' file</code> and <code>sed -i 's/.../.../' file</code>?</summary>

Without `-i`, `sed` prints the changed text and leaves the file untouched: a preview. With `-i`, it overwrites the file directly, with no confirmation and no undo.
</details>

<details>
<summary>7. After <code>grep 'ERROR' syslog > syslog</code>, why is <code>syslog</code> empty?</summary>

`bash` sets up the `>` redirection first, and that empties `syslog` to zero bytes before `grep` opens it. There is nothing left to read.
</details>

## Clean up

If a mission is still running, remove it now so it does not use memory on your machine.

First, see what is still running:

```sh
astrona list
```

Remove the mission. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-031
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *Describe the shape, preview with the scanner, and only then let the redaction officer write.*
