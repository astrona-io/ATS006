# Extract With grep, Redact With sed

Astronaut, a signal pattern is only useful once a tool acts on it. In this part you use `grep`, the signal scanner, to pull out lines that meet two conditions at once. Then you use `sed`, the redaction officer, to rewrite whole lines in a file, safely and precisely.

A **regular expression** is a signal pattern that describes the shape of a line. In the patterns below, `^` pins a match to the start of a line, `$` pins it to the end, `.*` means "anything in between", and `\.` is a real dot.

## Match two independent conditions

A very common task is: "find the lines that meet condition A **and** condition B". A and B are two unrelated pieces of text that can appear anywhere on the line, in either order. This section shows why one clever pattern is risky, and what to do instead.

### See one combined pattern miss a line

Save this as `syslog`:

```text
ERROR disk-full on /var
disk-full warning cleared, ERROR count reset
ERROR network down
INFO disk-full check scheduled
```

The tempting approach is one combined pattern:

```bash
grep '.*ERROR.*disk-full.*' syslog
```

```text
ERROR disk-full on /var
```

This works *only* if `ERROR` always comes before `disk-full`. The second line has both words, but in the other order, so the pattern silently drops it. There is no error and no warning, just a quietly incomplete result.

### Chain two grep commands with a pipe

The safer approach for two independent conditions is to chain two separate `grep` commands with a pipe. A pipe (`|`) is a tube that carries the first command's output straight into the second:

```bash
grep 'ERROR' syslog | grep 'disk-full'
```

```text
ERROR disk-full on /var
disk-full warning cleared, ERROR count reset
```

The first `grep` keeps the lines with `ERROR`. The second `grep` reads only those lines and keeps the ones with `disk-full`. Each one checks its own condition, wherever it sits on the line and whichever comes first.

The piped form is a little longer, but it is far more robust. It is also far easier to reason about and debug one piece at a time when you work under time pressure. When you have no guarantee about the order, prefer the piped form.

## Redact whole lines with sed

`grep` only ever reads a file; it never changes it. `sed`'s `s///` command is how you actually rewrite content, line by line, as the file streams through it. This section shows the substitution, how to preview it and how to make it permanent.

### Replace a whole line

The substitution syntax is `s/PATTERN/REPLACEMENT/`. Save this as `events.log`:

```text
service.web restart
service.db stop
serviceXrestart
```

Now run the substitution:

```bash
sed 's/^service\..*restart$/MAINTENANCE EVENT/' events.log
```

```text
MAINTENANCE EVENT
service.db stop
serviceXrestart
```

The pattern is anchored to the *whole line*, with `^` at the start and `$` at the end. So `sed` replaced the entire matching line with `MAINTENANCE EVENT`, not just one piece of it. This is the shape you want whenever a task says "replace the whole line with", as opposed to "replace just this word in the line". The other two lines came through unchanged.

### Preview before you commit

Run without any special option, `sed` prints the changed text to your terminal and leaves the original file completely untouched. The command you just ran was that preview. Check it now:

```sh
cat events.log
```

```text
service.web restart
service.db stop
serviceXrestart
```

The file still holds its original three lines. When you read a preview, check two things. Every line that should be redacted now reads exactly as your replacement text. Every other line is identical to the original.

### Make the change permanent

Only once you have checked the preview should you add the option that writes the change into the file:

```bash
sed -i 's/^service\..*restart$/MAINTENANCE EVENT/' events.log
```

Then check the result:

```sh
cat events.log
```

```text
MAINTENANCE EVENT
service.db stop
serviceXrestart
```

`-i` (in place) overwrites the file directly, with no confirmation and no built-in undo. Treat `sed -i` with exactly the same caution you give `rm`. An overly broad `sed -i` substitution *is* a data-loss event; it just loses text instead of files.

### Keep a backup copy if you want one

GNU `sed`, the version on almost every Linux distribution, including the exam machines, makes the backup suffix optional. `sed -i.bak '...'` keeps a `.bak` copy of the original, and `sed -i '...'` keeps none.

The `sed` on BSD and macOS needs the suffix argument every time, even when it is empty (`sed -i '' '...'`). That detail only matters if you ever run these commands outside Linux.

## The redirection trap

One classic, silent mistake is sending `grep`'s matches back into the *same file* it reads from. This section shows why the file ends up empty.

### Why the source file is emptied

```bash
grep 'ERROR' syslog > syslog     # WRONG -- truncates syslog to empty first
```

`bash` sets up the `>` redirection before it starts `grep`, and `>` empties the target file to zero bytes. By the time `grep` opens `syslog` to read it, there is nothing left to read. So the file you wanted to search is gone.

The rule: always send matches into a separate, clearly named output file, never into the source file itself. Then prove the source is untouched by counting its lines before and after with `wc -l`.

## Common pitfalls

> [!WARNING]
> - **One combined pattern for two independent conditions.** `'.*A.*B.*'` misses every line where B comes before A. Chain two `grep` commands with a pipe instead.
> - **Running `sed -i` before a preview.** Run the substitution without `-i` first, read the output, then add `-i`.
> - **Forgetting the anchors in a whole-line replacement.** Without `^` and `$`, `sed` replaces only the matching piece and leaves the rest of the line.
> - **Redirecting into the file you are reading.** `grep 'ERROR' syslog > syslog` empties `syslog` before `grep` reads it. Write to a new file.
> - **Leaving a dot unescaped in a version string.** In `hacker-bot/1.2`, the `.` means any character. Write `1\.2` to match only a real dot.

## Your mission: grep & sed Text Processing Lab

You can now extract lines that meet two conditions and redact whole lines safely. The mission asks you to pull an attacker's requests out of a web server log and to replace sensitive lines in a server log, without disturbing anything else in either file.

Start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-031
```

Open a terminal on the lab machine:

```sh
astrona ssh ats-006-lab-031
```

Read the task in [the question](../../../labs/lab-031/docs/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona submit -c labs/lab-031
```

When the mission is done, remove it:

```sh
astrona destroy ats-006-lab-031
```
