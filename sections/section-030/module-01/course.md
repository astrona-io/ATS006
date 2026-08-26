# Text Processing: Targeted Extraction with grep and Redaction with sed

Every sysadmin spends a huge share of their working life reading log files, and no log file is ever the size you want it to be. It's either three lines too short to tell you anything, or fifty thousand lines too long to read by eye. The two tools that make that bearable are `grep`, which finds the needles in the haystack, and `sed`, which rewrites lines in place without you having to open an editor at all.

Think of `grep` as a highlighter and `sed` as a redaction marker. A highlighter never changes the page — it just shows you where to look. A redaction marker permanently blacks out exactly the text it's dragged across, and nothing else. Both tools work the same underlying way: you hand them a *pattern* that describes the shape of the text you care about, and they act on every line that matches that shape.

## Regular Expressions: Describing a Shape, Not a String

The core skill both tools depend on is writing a regular expression — a pattern that describes *the shape* of text you're looking for, not one literal string.

### Anchors: Pinning a Match to a Position

By default, a pattern matches anywhere on a line. If you search for `root`, it matches `root`, `rootkit`, and `myroot` all the same, because the pattern is free to match anywhere on the line, not necessarily at a fixed position.

Two special characters pin a pattern to a specific position:

- `^` anchors the pattern to the **start** of the line.
- `$` anchors the pattern to the **end** of the line.

```bash
grep '^error' status.log      # only lines that *begin* with "error"
grep 'timeout$' status.log    # only lines that *end* with "timeout"
grep '^error.*timeout$' status.log   # lines that start with "error" AND end with "timeout"
```

That last example combines both anchors with a wildcard in between — which brings up the second core building block.

### The Wildcard: `.` and `.*`

A single `.` matches exactly one of *any* character. `.` is a placeholder for "something is here," not a literal dot.

`.*` combines that with `*` (meaning "zero or more of the preceding thing"), producing "match any run of characters, including none at all." This is how you express "I don't care what's in the middle" inside a larger pattern:

```bash
grep '^service\..*restart$' events.log
```

Read this left to right: "a line that starts with `service.`, has anything at all in between, and ends with `restart`." That single pattern shape — anchor, wildcard, anchor — solves the majority of real-world log-filtering tasks: "starts with X, ends with Y, and I don't care what's between."

Notice the backslash before the second `.`: that's escaping. Since `.` is a metacharacter meaning "any character," a *literal* dot — like the one in `service.` — has to be escaped as `\.` so it means an actual period instead of a wildcard for any single character. Skip this and `service.` would also match `serviceXrestart` or `service9restart`, which is rarely what you want, even if a small sample log never exposes the bug.

### Basic vs. Extended Regular Expressions

Plain `grep` uses Basic Regular Expressions (BRE), where characters like `|` (alternation, "either/or") and `+` (one or more) need a backslash to mean anything special. `grep -E` (or `egrep`) switches to Extended Regular Expressions (ERE), where those characters work directly:

```bash
grep 'error\|warning' app.log      # BRE: needs the backslash for alternation
grep -E 'error|warning' app.log    # ERE: -E makes | work unescaped
```

`sed` has the same split: plain `sed` is BRE, `sed -E` (or `-r` on some systems) is ERE. When a task description uses words like "or," reach for `-E` so alternation and repetition operators behave the way you'd naturally expect them to.

## Matching Multiple Independent Conditions

A very common real task is: "find lines that satisfy condition A **and** condition B," where A and B are two unrelated substrings that could appear anywhere on the line, in either order.

The tempting approach is one clever combined regex:

```bash
grep '.*ERROR.*disk-full.*' syslog
```

This works *only* if `ERROR` always appears before `disk-full` on every matching line. If even one legitimate line has them in the reverse order, that single-regex approach silently drops it — no error, no warning, just a quietly incomplete result.

The safer approach for two independent conditions is to chain two separate `grep` invocations with a pipe:

```bash
grep 'ERROR' syslog | grep 'disk-full'
```

Each `grep` here checks its own condition independently, regardless of where on the line it appears or which condition comes first. This is slightly more verbose, but it's far more robust, and — just as importantly — far easier to reason about and debug one piece at a time when you're working under time pressure. When you don't have a guarantee about ordering, prefer the piped form.

## Redacting Whole Lines with sed

`grep` only ever reads a file; it never modifies it. `sed`'s `s///` command is how you actually rewrite content, line by line, as the file streams through it.

The substitution syntax is `s/PATTERN/REPLACEMENT/`:

```bash
sed 's/^service\..*restart$/MAINTENANCE EVENT/' events.log
```

If `PATTERN` is anchored to match the *entire line* (as it is here, with `^` at the start and `$` at the end), the entire matching line is replaced by `REPLACEMENT` — not just the piece that matched a sub-portion, the whole line becomes the new text. This is the pattern shape you want whenever a task says "replace the whole line with," as opposed to "replace just this word within the line."

### Preview Before You Commit

Run without any special flag, `sed` prints its transformed output to your terminal and leaves the original file completely untouched:

```bash
sed 's/^service\..*restart$/MAINTENANCE EVENT/' events.log
```

Read through this output carefully. Every line that should be redacted should now read exactly as your replacement text; every other line should be byte-for-byte identical to the original. Only once you've visually confirmed this should you reach for the flag that makes the change permanent:

```bash
sed -i 's/^service\..*restart$/MAINTENANCE EVENT/' events.log
```

`-i` (in-place) overwrites the file directly, with no confirmation and no built-in undo. Treat `sed -i` with exactly the same caution you'd give `rm` — because functionally, an overly broad `sed -i` substitution *is* a data-loss event; it just loses text instead of files. GNU sed (the version on essentially every Linux distribution, including the LFCS exam environment) makes the backup suffix optional (`sed -i.bak '...'` keeps a `.bak` copy; `sed -i '...'` keeps none). BSD/macOS sed requires the suffix argument explicitly, even if empty (`sed -i '' '...'`) — a detail that only matters if you ever run these commands outside Linux.

### The Redirection Trap

One classic, silent mistake: piping `grep`'s matches back into the *same file* you're reading from.

```bash
grep 'ERROR' syslog > syslog     # WRONG -- truncates syslog to empty first
```

The shell sets up the `>` redirection — which truncates the target file to zero bytes — *before* `grep` ever opens `syslog` to read it. By the time `grep` tries to read, there's nothing left to read. Always redirect matches into a distinctly named output file, never the source file itself.

## Self-Check and Verification

To prove you can combine these two tools confidently:

1. Create a small text file with at least eight lines, mixing several different "message types" (for example, lines that start with `auth:`, `net:`, and `disk:`, each ending in either `OK` or `FAIL`).
2. Using two independent, piped `grep` invocations, extract only the lines that start with `auth:` **and** end in `FAIL`, redirecting the result into a new file. Confirm the original file is untouched (`wc -l` should show the same line count as before).
3. Write a `sed -E` substitution that matches every line starting with `net:` and ending in `FAIL`, with anything in between, and preview it (no `-i`) to confirm only the intended lines would change.
4. Apply the same substitution with `-i`, replacing each matching line with the literal text `NETWORK EVENT REDACTED`.
5. Run `grep -c` for your replacement text and confirm the count matches how many lines you expected to redact in Step 3.
6. Re-run your Step 3 pattern against the now-modified file and confirm it produces **no** output — proof every qualifying line was successfully redacted.
