# Shell Command History: Recall, Search, and Control What Gets Remembered

Every interactive bash session keeps a running diary of everything you type. Most of the time you ignore it. Under exam time pressure, or three hours into debugging a production incident, it becomes one of the most valuable tools on the machine — the difference between retyping a fifteen-flag command from memory (badly) and getting it back exactly right in two keystrokes.

Think of shell history as a notebook you're constantly filling, that only gets copied to a permanent filing cabinet (`~/.bash_history`) when you close the notebook (exit the shell). Understanding that distinction — what's in the notebook right now versus what's actually been filed away — explains almost every "why doesn't my history show up" surprise you'll ever hit.

## Fast Recall Without Retyping

Bash gives you three closely related ways to re-run something you've already typed, all part of what's called history expansion:

- `!!` re-runs the single most recent command.
- `!n` re-runs the command with history number `n` exactly.
- `!string` re-runs the most recent command that *started with* `string`.

```bash
sudo systemctl restart nginx
!!                              # re-runs "sudo systemctl restart nginx"
history | tail -5               # look up a specific number, e.g. 482
!482                            # re-runs whatever command was numbered 482
!sudo                           # re-runs the most recent command starting with "sudo"
```

These are fast, but they have a real risk: they execute immediately. If you're not certain `!482` is the command you think it is, you can drop it into your prompt for editing instead of running it outright — most bash setups let you press `→` (right arrow) or `Esc` right after typing a history-expansion token to expand it onto the line without executing it, so you can review or edit it first.

### Reverse Incremental Search: Ctrl+R

The fastest general-purpose recall tool doesn't require remembering a number or the exact start of a command at all. Pressing `Ctrl+R` starts a reverse incremental search: type any substring that appeared *anywhere* in a past command, and bash jumps straight to the most recent match, updating live as you keep typing. Press `Ctrl+R` again to walk further back through older matches. Press `Enter` to run the found command as-is, or `Esc`/an arrow key to drop into the shell with it pre-filled for editing.

```
(reverse-i-search)`ssh': ssh admin@10.20.30.42
```

`Ctrl+R` beats scrolling or guessing a history number almost every time — it's worth building as muscle memory rather than something you reach for occasionally.

## What Gets Remembered, and For How Long

Four variables control history's size and behavior. All of them are ordinary shell variables — set them with `export` in a startup file (`~/.bashrc` for a per-user interactive shell) to make the behavior persist across sessions, rather than just the current one.

### HISTSIZE vs. HISTFILESIZE

These sound like the same thing and are not:

- `HISTSIZE` bounds how many commands the **running shell** keeps in memory right now — what a bare `history` shows you during this session.
- `HISTFILESIZE` bounds how many lines are kept in the **history file on disk** (`~/.bash_history`) once a session's history is written out.

```bash
export HISTSIZE=2000
export HISTFILESIZE=8000
```

They're separate variables because the two needs are genuinely different: you might want a long in-memory scrollback for a single marathon session, while still keeping the permanent on-disk file to a more modest size — or the reverse. Setting only one and assuming the other follows along is a common, quiet misconfiguration.

### HISTCONTROL: Deciding What Never Gets Recorded

`HISTCONTROL` filters what's recorded *before it's ever written anywhere*, not after:

- `ignoredups` — skip a command if it's identical to the immediately preceding history entry.
- `ignorespace` — skip a command if it starts with a leading space.
- `ignoreboth` — both of the above, in a single value.

```bash
export HISTCONTROL=ignoreboth
```

`ignorespace` is the conventional way to run something you deliberately don't want in the permanent record — a password typed by mistake on the command line, a one-off token, anything sensitive. Just prefix it with a space and it's never recorded at all:

```bash
 curl -H "Authorization: Bearer sk-supersecret123" https://api.internal/status
```

Note the important limitation of `ignoredups`: it only compares against the *immediately preceding* entry. Five identical commands typed back-to-back get recorded once. The same command run again after something else happened in between is treated as brand new — there's no built-in way to catch non-consecutive repeats.

### HISTTIMEFORMAT: Knowing *When*, Not Just *What*

By default, `history` shows only the command number and text, with no timestamp. Setting `HISTTIMEFORMAT` to a `strftime`-style format string adds a timestamp prefix to every entry recorded from that point forward:

```bash
export HISTTIMEFORMAT="%F %T  "
```

`%F` and `%T` expand to `YYYY-MM-DD` and `HH:MM:SS` respectively. This only affects entries recorded *after* the variable is set — history entries already on record don't retroactively grow timestamps.

## Why Two Open Terminals Don't Share History Live

Each interactive bash shell keeps its own history entirely in its own memory. It only writes that memory out to the shared `~/.bash_history` file when that specific shell exits — or when you explicitly force it. A second, still-running shell has no way to see entries that were never written, and even after they are written, that second shell won't notice until it re-reads the file.

The `history` builtin lets you force both halves of that manually:

```bash
history -a     # append this shell's new entries to the history file now
history -c     # clear this shell's in-memory history (does NOT touch the file)
history -r     # re-read the history file into this shell's memory
history -w     # write this shell's entire history out, overwriting the file
```

Wiring `history -a; history -c; history -r` into `PROMPT_COMMAND` (a variable bash re-evaluates before every prompt) makes every open shell write and re-read on every single command, producing near-live shared history between terminals — a deeper customization beyond the basics here, but worth knowing exists.

## Self-Check and Verification

To confirm you're fluent with recall and configuration:

1. Run three or four different commands, then use `!!` to re-run the last one and `!n` (using the actual number from `history`) to re-run one from earlier in that batch.
2. Type the same command twice in a row, then a different command, then the first command again. Check `history` and confirm how many total entries were recorded — and explain why, based on `ignoredups`' consecutive-only rule.
3. Set `HISTCONTROL=ignoreboth` and `HISTTIMEFORMAT="%F %T  "` persistently in your shell's startup file, then open a fresh shell and confirm both took effect with `echo $HISTCONTROL` and by running `history 3`.
4. Open a second terminal to the same machine. Run a distinctive command in the first terminal, then check whether it appears in the second terminal's `history` immediately, after `history -a` in the first, and after `history -a` followed by `history -r` in the second.
5. Practice `Ctrl+R` by searching for a command you ran several steps ago, using only a substring from the middle of it — not the start.
