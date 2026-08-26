# Shell Redirection, stdout/stderr, and Exit Codes

Every process you launch on Linux is born with three open file descriptors, whether you ever think about them or not: fd 0 (stdin), fd 1 (stdout), and fd 2 (stderr). By default, all three are connected to your terminal — the program reads your keystrokes from fd 0, prints its normal output to fd 1, and prints its warnings and errors to fd 2, and you see all of it interleaved on the same screen because it's all going to the same place.

The shell's redirection operators let you disconnect any of these three wires and plug them into something else — a file, another stream, or oblivion (`/dev/null`) — independently of the other two. This is not a cosmetic feature. It's the difference between a log file that actually contains what broke and a log file that's mysteriously empty because the error text went to your terminal instead.

Think of a process as a machine with three labeled pipes coming out the back: one for its expected output, one for its complaints, one for input. The shell is the plumber. `command > file` grabs the "expected output" pipe and reroutes it into `file`. It does not touch the "complaints" pipe at all — that one keeps draining onto your terminal exactly as before, unless you separately redirect it too.

## Isolating stdout, Isolating stderr

```bash
backup-tool > success.log
```

This connects fd 1 to `success.log`. Anything the program writes with a normal `print`/`echo`-style call lands there. If the program also writes a warning to stderr, that warning is completely unaffected — it still prints to your terminal, because you only rerouted fd 1.

```bash
backup-tool 2> errors.log
```

The `2` immediately before `>` targets fd 2 specifically — no space allowed between them, since `2 > file` (with a space) is a different, ambiguous piece of syntax to the shell. Now stdout is untouched and still prints to the terminal, while only the error stream lands in `errors.log`.

This is genuinely useful on its own: separating the two streams into separate files is how you build a log pipeline where "the normal record" and "the trouble ticket" never get mixed together, and it's why well-behaved Linux tools are careful to send diagnostic chatter to stderr rather than polluting stdout that another program might be piping and parsing.

## Combining Both Streams — and Why Order Matters

Sometimes you want everything, interleaved, in one file. The shell evaluates redirections **left to right**, and that evaluation order is the single most-tested trap in this entire topic.

```bash
backup-tool > combined.log 2>&1
```

Read this exactly as the shell does, one token at a time:

1. `> combined.log` — fd 1 is now pointed at `combined.log`.
2. `2>&1` — fd 2 is redirected to "wherever fd 1 currently points." Since fd 1 was just repointed at `combined.log` in step 1, fd 2 now points there too.

Result: both streams land in `combined.log`. Now watch what happens if you swap the order:

```bash
backup-tool 2>&1 > combined.log
```

1. `2>&1` — fd 2 is redirected to "wherever fd 1 currently points." At this exact moment, fd 1 still points at the terminal (nothing has repointed it yet). So fd 2 now points at the terminal too.
2. `> combined.log` — fd 1 is repointed at `combined.log`.

Result: fd 1 goes to the file, but fd 2 is still pointing at the terminal from step 1 — it was never told to follow fd 1's later move. `combined.log` ends up with stdout only, and the errors you wanted captured scroll past on screen instead. This is not a bug or an inconsistency; it's the direct, literal consequence of processing redirections strictly left to right, each one capturing the *current* state of the target at that instant, not a live link that updates later.

Bash also offers a shorthand for the common "send both to the same file" case:

```bash
backup-tool &> combined.log
```

`&>` is equivalent to `> combined.log 2>&1` — but it's a bash (and zsh) extension, not POSIX. If you ever need a script that also runs correctly under `sh` or `dash`, use the portable `> file 2>&1` spelling instead.

## Reading the Exit Code

Redirection controls where bytes go. It has absolutely no effect on whether the program considers itself successful. That's a separate, numeric signal: the exit status, stored by the shell in the special parameter `$?` the instant the foreground command finishes.

```bash
backup-tool
echo $?
```

By convention, `0` means success and any non-zero value (1–255) means some kind of failure, with the specific non-zero number often encoding *which* failure — consult a program's man page or `--help` if you need to distinguish "config file missing" from "network timeout," for example.

The critical operational detail: `$?` reflects the *most recently completed foreground command*, full stop. It is overwritten by the very next thing you run — even a harmless sanity-check command like `ls` in between will clobber it before you get a chance to read it.

```bash
backup-tool
ls              # this silently destroys backup-tool's exit code
echo $?         # now shows ls's exit code, not backup-tool's
```

If you need to both suppress a program's output and capture its exit code, redirect the output on the same command, then read `$?` on the very next line with nothing in between:

```bash
backup-tool > /dev/null 2>&1
echo $? > status.log
```

Redirecting to `/dev/null` — the standard "I don't want this stream at all" destination — has zero bearing on the number `$?` ends up holding. The two mechanisms, stream routing and exit status, are entirely independent; one is about text, the other is a numeric contract between the program and whoever calls it.

## Self-Check and Verification

To prove you understand redirection and exit-code capture on your own terms:

1. Write a tiny throwaway script that prints one line to stdout with `echo "ok"` and one line to stderr with `echo "warn" >&2`.
2. Run it with only `>` and confirm the stdout line lands in your file while the stderr line still appears on your terminal.
3. Run it with only `2>` and confirm the reverse.
4. Run it once as `script > all.log 2>&1` and once as `script 2>&1 > all.log`, and diff the two resulting files — confirm the first captures both lines and the second captures only stdout.
5. Make the script `exit 3` at the end, run it, then immediately run `echo $?` and confirm you see `3` — then run any other command first and confirm `$?` no longer shows `3`.
