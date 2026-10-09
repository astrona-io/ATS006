# Patterns: Describing A Shape

Astronaut, before you can scan a log or redact a line, you need a way to describe what you are looking for. That description is a **regular expression**: a signal pattern. It describes the *shape* of a line, not one exact message. In this part you build patterns with anchors and wildcards, and you see them work with `grep`, the signal scanner that keeps only the lines that fit.

## Pin a match to a position

By default, a pattern matches anywhere on a line. Two special characters change that, and they solve most real log tasks. This section shows the problem first, then the fix.

### See an unanchored match

Make a small practice log first. Save this as `status.log`:

```text
error: backup job timeout
error: disk check passed
warning: network timeout
info: error count is zero
```

Now search it for the word `error`:

```sh
grep 'error' status.log
```

```text
error: backup job timeout
error: disk check passed
info: error count is zero
```

`grep` printed three lines, including the `info:` line, because the word `error` appears in the middle of it. The same thing happens with a search for `root`: it matches `root`, `rootkit` and `myroot` alike, because the pattern is free to match anywhere on the line.

### Add anchors

Two special characters pin a pattern to a fixed position:

- `^` anchors the pattern to the **start** of the line.
- `$` anchors the pattern to the **end** of the line.

Run the three anchored searches on the same file:

```sh
grep '^error' status.log      # only lines that *begin* with "error"
grep 'timeout$' status.log    # only lines that *end* with "timeout"
grep '^error.*timeout$' status.log   # lines that start with "error" AND end with "timeout"
```

```text
error: backup job timeout
error: disk check passed
error: backup job timeout
warning: network timeout
error: backup job timeout
```

The first command printed the two lines that start with `error`. The second printed the two lines that end with `timeout`. The third printed only the one line that does both. That last pattern combines both anchors with a wildcard in between, which is the next building block.

## Say "anything here" with a wildcard

Often you know how a line starts and ends, but not what sits in the middle. A wildcard fills that gap. This section explains the two wildcard forms and the one character that needs special care.

### The dot and the dot-star

A single `.` matches exactly one of *any* character. It is a placeholder for "something is here", not a literal dot.

`.*` combines that with `*`, which means "zero or more of the thing before it". Together they mean "any run of characters, including none at all". This is how you say "I don't care what is in the middle" inside a larger pattern:

```bash
grep '^service\..*restart$' events.log
```

Read this from left to right: "a line that starts with `service.`, has anything at all in between, and ends with `restart`." That one shape (anchor, wildcard, anchor) solves most real log-filtering tasks: "starts with X, ends with Y, and I don't care what is between."

### Escape a literal dot

Notice the backslash before the second `.` in that pattern. That is **escaping**. Since `.` means "any character", a *real* dot, like the one in `service.`, must be written as `\.` so it means an actual period.

Skip the backslash and `service.` also matches `serviceXrestart` or `service9restart`. That is rarely what you want, even when a small sample log never shows the bug. See it for yourself. Save this as `events.log`:

```text
service.web restart
service.db stop
serviceXrestart
```

Run the pattern with the escaped dot, then without it:

```sh
grep '^service\..*restart$' events.log
grep '^service..*restart$' events.log
```

```text
service.web restart
service.web restart
serviceXrestart
```

The escaped pattern found only `service.web restart`. The unescaped one also let `serviceXrestart` through, because the bare `.` happily matched the `X`.

## Basic and extended regular expressions

`grep` and `sed` understand two flavours of pattern. They differ in which characters are special without a backslash. This section shows both, so you know when to reach for the `-E` option.

### Two ways to say "either or"

Plain `grep` uses **basic regular expressions** (BRE). In that flavour, characters like `|` (alternation, "either this or that") and `+` (one or more) need a backslash to mean anything special. `grep -E` (or the older `egrep`) switches to **extended regular expressions** (ERE), where those characters work directly.

Save this as `app.log`:

```text
error: disk full
warning: disk 90% used
info: backup done
```

Then run both forms:

```bash
grep 'error\|warning' app.log      # BRE: needs the backslash for alternation
grep -E 'error|warning' app.log    # ERE: -E makes | work unescaped
```

```text
error: disk full
warning: disk 90% used
error: disk full
warning: disk 90% used
```

Both commands find the same two lines. Only the way you write the pattern changes.

### The same split in sed

`sed` has the same two flavours. Plain `sed` uses basic expressions, and `sed -E` (or `-r` on some systems) uses extended ones. When a task description uses words like "or", reach for `-E`, so alternation and repetition behave the way you naturally expect.

> [!TIP]
> Build a pattern with `grep` first and check its output against the real file. Once `grep` shows exactly the lines you want, reuse the same pattern in `sed`.

## Common pitfalls

> [!WARNING]
> - **Forgetting the anchors.** Without `^` and `$`, a pattern matches anywhere on the line, so `error` also catches `info: error count is zero`.
> - **Leaving a literal dot unescaped.** `service.` also matches `serviceX`. Write `service\.` when you mean a real period.
> - **Using `|` or `+` without `-E`.** In basic expressions they are plain characters unless you escape them. Add `-E` to `grep` or `sed` to make them special.
> - **Trusting a small sample.** A pattern can look right on four lines and still be too loose on the real log. Check it against the real file before you act on the result.
