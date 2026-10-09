# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Before you move on, look back at what you learned, check yourself, and clean up.

## What you learned

This module was about the bridge's order log: getting commands back out of it fast, and deciding what goes into it.

**From [Recall Commands Without Retyping](./course-01-recall-commands-without-retyping.md):**

- `!!` runs the last command again, `!n` runs entry number `n`, and `!string` runs the most recent command that starts with `string`.
- History expansion runs at once. Check the number first, or expand it onto the line before you press `Enter`.
- `Ctrl+R` searches backwards for any piece of text anywhere in a past command. Press it again for older matches, `Enter` to run, `Esc` to edit.

**From [Control What History Remembers](./course-02-control-what-history-remembers.md):**

- `HISTSIZE` limits the commands kept in memory; `HISTFILESIZE` limits the lines kept in `~/.bash_history`.
- `HISTCONTROL=ignoreboth` skips back-to-back duplicates and commands that start with a space.
- `HISTTIMEFORMAT="%F %T  "` stamps new entries with `YYYY-MM-DD HH:MM:SS`.
- `export` lines in `~/.bashrc` make the settings last for every new session.
- Each shell keeps history in memory and writes it to the file on exit. `history -a` appends now, `history -r` reads the file again.

## Your missions

You proved the skills in a graded mission, right after the part that taught them:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Shell History Recall Lab](../../../labs/lab-032/docs/question.md) | Control What History Remembers | made history settings permanent and recovered two exact commands from an earlier session |

If you skipped it, go back to it now. It is short, and the exam asks for exactly these skills.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. What is the difference between <code>!!</code>, <code>!482</code> and <code>!sudo</code>?</summary>

`!!` runs the most recent command. `!482` runs history entry number 482. `!sudo` runs the most recent command that starts with `sudo`.
</details>

<details>
<summary>2. You remember only a word from the middle of a long command. How do you find it?</summary>

Press `Ctrl+R` and type that word. The reverse search matches text anywhere in a past command. Press `Ctrl+R` again to walk to older matches.
</details>

<details>
<summary>3. What does <code>HISTSIZE</code> control, and what does <code>HISTFILESIZE</code> control?</summary>

`HISTSIZE` is how many commands the running shell keeps in memory. `HISTFILESIZE` is how many lines the history file on disk, `~/.bash_history`, keeps.
</details>

<details>
<summary>4. With <code>HISTCONTROL=ignoreboth</code>, you type <code>date</code>, <code>date</code>, <code>whoami</code>, <code>date</code>. How many <code>date</code> entries are recorded?</summary>

Two. The second `date` is skipped because it matches the entry just before it. The last `date` is recorded because `whoami` came in between: `ignoredups` only catches back-to-back repeats.
</details>

<details>
<summary>5. How do you run a command that contains a secret without it landing in history?</summary>

With `ignorespace` (or `ignoreboth`) set in `HISTCONTROL`, start the command with a space. `bash` never records it.
</details>

<details>
<summary>6. You set <code>HISTTIMEFORMAT</code> at the prompt. Why is it gone tomorrow?</summary>

A variable set at the prompt lives only in that session. Put `export HISTTIMEFORMAT="%F %T  "` in `~/.bashrc` so every new interactive shell sets it.
</details>

<details>
<summary>7. You run a command in one terminal. Why doesn't a second open terminal show it in <code>history</code>?</summary>

Each shell keeps its history in its own memory and writes it to the file only on exit or with `history -a`. The second shell sees it only after it reads the file again with `history -r`.
</details>

## Clean up

If a mission is still running, remove it now so it does not use memory on your machine.

First, see what is still running:

```sh
astrona list
```

Remove the mission. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-032
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *The order log remembers what you tell it to remember. Set it up once, and every command is two keystrokes away.*
