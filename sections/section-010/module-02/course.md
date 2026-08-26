# Environment Variables and Scope

Every process on Linux carries around a private list of key-value strings called its **environment**. When a process spawns a child process — a shell running a script, a script calling another program — the kernel copies that list into the new process's own memory. The child gets its own independent copy; it can change or delete entries without affecting the parent, and the parent can't see anything the child added afterward. This one-way, copy-at-creation-time inheritance is the entire mechanism, and it's simpler than it sounds once you stop assuming "a variable" and "an environment variable" are the same thing.

They aren't. Every variable you create in bash starts out as a **shell variable** — a name-value pair known only to the current shell process, invisible to anything it launches. It only becomes an **environment variable** — eligible for copying into child processes — once you explicitly `export` it. "Environment variable" is really just shorthand for "a shell variable that has been exported."

## A Shell Variable, by Default, Goes Nowhere

```bash
GREETING="hello"
echo "$GREETING"        # prints: hello
```

This works fine — inside the current shell. But watch what happens the moment a *separate process* tries to read it:

```bash
GREETING="hello"
bash -c 'echo "$GREETING"'     # prints: (nothing)
```

`bash -c '...'` launches a brand-new child shell process. That child inherits the *environment* of its parent — but `GREETING` was never placed into the environment, only into the parent shell's private variable table. The child has no way to see it. This surprises people constantly: "I just set it, why can't my script see it?" — because "my script" usually runs as its own process, not inside your interactive shell.

## `export` Flags a Variable for Inheritance

```bash
export GREETING="hello"
bash -c 'echo "$GREETING"'     # prints: hello
```

`export` doesn't create a new kind of variable or copy the value anywhere immediately — it flags the existing shell variable so that, from this point forward, every child process this shell spawns gets a copy of it in its own environment automatically. You can confirm exactly what's currently exported with:

```bash
export -p
```

This lists every name currently flagged for inheritance, in a re-runnable `export NAME="value"` format — genuinely useful when you're debugging "why doesn't my subprocess see this" and want to check whether a variable is a plain shell variable or a true environment member before assuming anything.

## Why This Distinction Actually Matters

Picture a wrapper script that computes a database connection string and then calls a separate client binary to use it:

```bash
#!/bin/bash
DB_HOST="db.internal"          # only needed inside this script
export DB_URL="postgres://${DB_HOST}/app"   # the client binary needs this

my-db-client
```

`DB_HOST` is scratch work — a value this script uses to build something else, never referenced outside it. It doesn't need `export`, and adding it wouldn't be wrong, just pointless: nothing downstream ever looks at `DB_HOST` directly. `DB_URL`, on the other hand, is read by `my-db-client`, a completely separate process the script launches. Without `export`, `my-db-client` would start up and find `DB_URL` simply undefined, because a plain assignment never leaves the script's own shell process.

This is the practical, operational reason LFCS cares about this distinction: **environment variable scope directly determines what configuration a spawned service or child process can actually see.** A systemd unit, a cron job, a Docker container, a subprocess spawned by a script — all of them only inherit what was exported into the environment they were launched from. A perfectly correctly *assigned* variable that was never exported might as well not exist from a child process's point of view.

## Brace Syntax: `${VAR}` vs `$VAR`

When you concatenate a variable with adjacent literal text, use braces to remove any ambiguity about where the variable name ends:

```bash
SUFFIX="prod"
echo "$SUFFIX_backup"      # looks for a variable named SUFFIX_backup — probably empty!
echo "${SUFFIX}_backup"    # correctly expands SUFFIX, then appends the literal text
```

Without braces, `$SUFFIX_backup` is parsed as one variable name, `SUFFIX_backup` — not the value of `SUFFIX` followed by literal `_backup`. This only becomes visible as a bug when the following character could plausibly be part of a variable name (a letter, digit, or underscore); `${VAR}-suffix` and `$VAR-suffix` behave identically since `-` can never be part of a variable name, but the underscore case above genuinely produces different, silently wrong output. The safe habit is to always brace a variable that's immediately followed by more text.

## A Word on Quoting During Expansion

```bash
export CONFIG_PATH="${HOME}/app-extended"     # correct: expands, then exports
export CONFIG_PATH='${HOME}/app-extended'     # wrong: single quotes suppress expansion entirely
```

Single quotes in bash disable all expansion — variable substitution included — so the second line would literally export the seven characters `${HOME}/app-extended`, not the intended path. Double quotes still allow `$VAR` and `${VAR}` expansion while protecting the result from word-splitting and glob expansion, which is why "double-quote your expansions" is close to a universal shell scripting rule.

## Self-Check and Verification

To prove you understand shell-local versus exported scope on your own terms:

1. In your interactive shell, set `LOCAL_ONLY=abc` (no `export`) and confirm `echo $LOCAL_ONLY` shows `abc`.
2. Run `bash -c 'echo "LOCAL_ONLY is: $LOCAL_ONLY"'` and confirm it prints empty — the child process never received it.
3. Now run `export LOCAL_ONLY` (exporting the existing variable, no need to reassign the value) and re-run the same `bash -c` command — confirm the child now sees `abc`.
4. Run `export -p | grep LOCAL_ONLY` to see the exact re-runnable export line the shell tracks for it.
5. Create a second variable using brace expansion, e.g. `export TAGGED="${LOCAL_ONLY}_v2"`, and confirm both that it expands correctly and that a child shell can see it.
