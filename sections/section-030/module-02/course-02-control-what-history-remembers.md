# Control What History Remembers

Astronaut, the bridge's order log, the shell's **history**, is only as useful as what it keeps. In this part you decide how much the log holds, what it never records, and whether each entry carries a time. You also see why two consoles on the same ship do not share their logs live.

`bash`, the shell, keeps history in two places. One is its own memory while the session runs. The other is the history file on disk, `~/.bash_history`, which `bash` writes when the session ends.

## Four variables that shape history

Four variables control the size and behaviour of history. They are ordinary shell variables. Set them with `export` in a startup file to make the behaviour last across sessions, not just for the current one. For a per-user interactive shell, that startup file is `~/.bashrc`, which `bash` reads every time it opens a new interactive console.

### HISTSIZE and HISTFILESIZE

These two sound like the same thing, and they are not:

- `HISTSIZE` sets how many commands the **running shell** keeps in memory right now. That is what a bare `history` shows you during this session.
- `HISTFILESIZE` sets how many lines are kept in the **history file on disk** (`~/.bash_history`) once a session's history is written out.

```bash
export HISTSIZE=2000
export HISTFILESIZE=8000
```

They are separate because the two needs really are different. You might want a long in-memory log for one marathon session, while still keeping the permanent file on disk to a modest size, or the other way round. Setting only one and assuming the other follows is a common, quiet mistake.

### HISTCONTROL: what never gets recorded

`HISTCONTROL` filters what `bash` records *before it is ever written anywhere*, not afterwards:

- `ignoredups`: skip a command if it is identical to the entry just before it.
- `ignorespace`: skip a command if it starts with a space.
- `ignoreboth`: both of the above, in one value.

```bash
export HISTCONTROL=ignoreboth
```

`ignorespace` is the usual way to run something you deliberately keep out of the permanent record: a password typed on the command line by mistake, a one-off token, anything sensitive. Put a space in front of it and `bash` never records it:

```bash
 curl -H "Authorization: Bearer sk-supersecret123" https://api.internal/status
```

Note one important limit of `ignoredups`: it only compares with the entry *just before*. Five identical commands typed back to back are recorded once. The same command run again after something else is treated as brand new. There is no built-in way to catch repeats that are not back to back.

### HISTTIMEFORMAT: when, not just what

By default, `history` shows only the number and the text of each command, with no time. Set `HISTTIMEFORMAT` to a format string, in the style of the `strftime` time formatter, and `bash` adds a timestamp in front of every entry recorded from then on:

```bash
export HISTTIMEFORMAT="%F %T  "
```

`%F` becomes the date as `YYYY-MM-DD`, and `%T` the time as `HH:MM:SS`. This only affects entries recorded *after* you set the variable. Older entries do not gain timestamps afterwards.

## Make the settings last

A variable you type at the prompt is gone when the session ends. This section puts the settings in `~/.bashrc` and proves they work in a new shell.

### Save the settings in ~/.bashrc

Add these lines to the end of `~/.bashrc` (open it with `nano ~/.bashrc` or `vim ~/.bashrc`):

```bash
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%F %T  "
```

Apply it to your current shell:

```sh
source ~/.bashrc
```

Then check the result. Open a fresh shell (or a new terminal) and run:

```sh
echo $HISTCONTROL
history 3
```

`echo` prints `ignoreboth`. In the `history 3` output, the commands you ran in this new shell, such as `echo $HISTCONTROL`, now carry a date and a time in front of them.

### Watch ignoredups at work

With `ignoreboth` active, type the same command twice in a row, then a different command, then the first command again. For example `date`, `date`, `whoami`, `date`. Then run `history 5`.

You see `date` recorded once for the two back-to-back runs, then `whoami`, then `date` again. The second `date` in a row was skipped, because it matched the entry just before it. The last `date` was recorded, because `whoami` came in between.

## Why two terminals don't share history live

Each interactive `bash` shell keeps its own history entirely in its own memory. This section explains when that memory reaches the file, and the commands that move it on demand.

### When the file is written

A shell writes its memory to the shared `~/.bash_history` file only when that shell exits, or when you force it. A second shell that is still running cannot see entries that were never written. Even after they are written, the second shell does not notice until it reads the file again.

```mermaid
flowchart LR
    A["shell A memory"] -->|"history -a"| F["~/.bash_history"]
    F -->|"history -r"| B["shell B memory"]
```

Shell A must append its new entries to the file, and shell B must read the file again, before B can see what A ran.

### The four history options

The `history` builtin lets you force both halves by hand:

```bash
history -a     # append this shell's new entries to the history file now
history -c     # clear this shell's in-memory history (does NOT touch the file)
history -r     # re-read the history file into this shell's memory
history -w     # write this shell's entire history out, overwriting the file
```

Putting `history -a; history -c; history -r` into `PROMPT_COMMAND`, a variable `bash` runs before every prompt, makes every open shell write and read the file on every command. That gives you near-live shared history between terminals. It goes beyond the basics here, but it is worth knowing it exists.

### Try it with two terminals

Open a second terminal to the same machine. In the first terminal, run a command you will recognise, for example `echo history-test-one`. Then check the second terminal's `history` at three moments:

1. Straight away: the command is not there.
2. After you run `history -a` in the first terminal: still not there, because the second shell has not read the file.
3. After you also run `history -r` in the second terminal: now it is there.

## Common pitfalls

> [!WARNING]
> - **Setting only `HISTSIZE` or only `HISTFILESIZE`.** One limits memory, the other limits the file on disk. Set both when a task gives both numbers.
> - **Setting the variables only at the prompt.** They vanish when the session ends. Put them in `~/.bashrc` to make them last.
> - **Expecting `ignoredups` to catch every repeat.** It only skips a command that matches the entry just before it.
> - **Expecting old entries to gain timestamps.** `HISTTIMEFORMAT` only stamps entries recorded after you set it.
> - **Expecting a second open terminal to see new commands.** History reaches the file when a shell exits or runs `history -a`, and another shell sees it only after `history -r`.

## Your mission: Shell History Recall Lab

You can now set up history so it keeps what you need, and recall any earlier command exactly. The mission asks you to make your history settings permanent and to recover two exact commands from an earlier investigation session.

Start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-032
```

Open a terminal on the lab machine:

```sh
astrona ssh ats-006-lab-032
```

Read the task in [the question](../../../labs/lab-032/docs/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona submit -c labs/lab-032
```

When the mission is done, remove it:

```sh
astrona destroy ats-006-lab-032
```
