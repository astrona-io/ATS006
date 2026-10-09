# Shell Command History: Recall, Search, and Control What Gets Remembered

Astronaut, every interactive `bash` session keeps a running log of every order you type at the bridge console. Most of the time you ignore it. Under exam time pressure, or three hours into an incident, that order log becomes one of the most valuable tools on the ship. It is the difference between retyping a fifteen-option command from memory (badly) and getting it back exactly right in two keystrokes.

Think of shell history as a notebook you fill all the time. It only gets copied to a permanent filing cabinet, the file `~/.bash_history`, when you close the notebook by leaving the shell. Knowing what is in the notebook right now, and what has actually been filed away, explains almost every "why doesn't my history show up" surprise you will ever hit.

## Learning objectives

After this module you can:

- Run an earlier command again with `!!`, `!n` and `!string`.
- Find any earlier command with the reverse search, `Ctrl+R`, using a piece from the middle of it.
- Explain the difference between `HISTSIZE` and `HISTFILESIZE`, and set both.
- Keep duplicates and secret commands out of history with `HISTCONTROL`.
- Add a timestamp to every new history entry with `HISTTIMEFORMAT`.
- Make the settings last for every future session by putting them in `~/.bashrc`.
- Explain why two open terminals do not share history live, and use `history -a`, `-c`, `-r` and `-w`.

## Before you start

Every mission starts with a pre-flight check, astronaut. Make sure you know the basics below and have a terminal ready.

### What you should already know

- **How to use the console.** You can run commands, read a file with `cat`, and search text with `grep`.
- **What a shell variable is.** A variable is a named value, like `HISTSIZE=2000`. `export` hands it on to programs the shell starts.

### What you need

A terminal on an Ubuntu 24.04 machine with `bash`, or a running lab machine. You open a terminal on a lab machine with `astrona ssh <lab name>`. For one exercise you need a second terminal to the same machine.

## How this module is laid out

1. [Recall Commands Without Retyping](./course-01-recall-commands-without-retyping.md): `!!`, `!n`, `!string` and the reverse search.
2. [Control What History Remembers](./course-02-control-what-history-remembers.md): size limits, what is never recorded, timestamps, and history across several terminals.
   - Mission: [Shell History Recall Lab](../../../labs/lab-032/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

Recalling a command is faster and safer than retyping it, and the exam rewards speed and accuracy. History is also evidence: during an incident it tells you exactly what was run, in which order, and, with timestamps, when. Setting it up well once pays off on every shift.
