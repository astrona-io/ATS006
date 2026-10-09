# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Before you move on, look back at what you learned, check yourself, and clean up.

## What you learned

This module was about nicknames for orders: how `bash` swaps them in, where they work, and where they never reach.

**From [How Bash Expands An Alias](./course-01-how-bash-expands-an-alias.md):**

- `bash` checks a word in this order: alias, function, builtin, then `PATH`. An alias always wins over a real command with the same name.
- `type <name>` tells you exactly what a name runs.
- An alias typed at the prompt lasts one session. Add it to `~/.bashrc` and `source` the file to make it permanent.
- An alias can only add arguments at the end. When an argument must go in the middle, or be used twice, write a shell function.

**From [Bypass, Scripts, And Safe Aliases](./course-02-bypass-scripts-and-safe-aliases.md):**

- `\rm` or `/bin/rm` runs the real command once and leaves the alias in place. `unalias` is slower and easy to forget to undo.
- Non-interactive shells, such as scripts, `bash -c` and scheduled jobs, do not expand aliases. `bash -c 'type rm'` shows the real program.
- A safe alias adds behaviour people expect, like `cp -i`. It never makes a command less predictable.

## Your missions

You proved the skills in a graded mission, right after the part that taught them:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Command Aliases Lab](../../../labs/lab-033/docs/question.md) | Bypass, Scripts, And Safe Aliases | persisted three aliases and deleted a file with the real `rm` while the safety alias stayed in place |

If you skipped it, go back to it now. It is short, and the exam asks for exactly these skills.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. You have <code>alias ls='ls --color=auto'</code> and a program <code>/usr/bin/ls</code>. Which one runs when you type <code>ls</code>?</summary>

The alias. `bash` checks aliases before functions, builtins and `PATH`, so you run `ls --color=auto`.
</details>

<details>
<summary>2. How do you find out whether <code>rm</code> is an alias, a function or a file?</summary>

Run `type rm`. It says `rm is aliased to ...`, `rm is a function`, or gives the file path.
</details>

<details>
<summary>3. You defined an alias at the prompt. Why is it missing in a new terminal?</summary>

An alias typed at the prompt lasts only for that shell. Add it to `~/.bashrc` so every new interactive shell defines it.
</details>

<details>
<summary>4. Why can't an alias create a folder and then move into it?</summary>

An alias only adds arguments to the end of its text. The folder name must be used twice, in two places, so you need a shell function such as `mkcd() { mkdir -p "$1" && cd "$1"; }`.
</details>

<details>
<summary>5. <code>rm</code> is aliased to <code>rm -i</code>. How do you delete one file without the prompt and keep the alias?</summary>

Run `\rm somefile` (or `/bin/rm somefile`). The backslash turns off alias expansion for that one word only.
</details>

<details>
<summary>6. Your safety alias is <code>rm='rm -i'</code>. Does a script that calls <code>rm</code> ask for confirmation?</summary>

No. A script runs in a non-interactive shell, which does not expand aliases by default. `bash -c 'type rm'` shows the real `rm` program.
</details>

<details>
<summary>7. Is <code>alias rm='rm -f'</code> a safe alias?</summary>

No. It silently removes confirmation and makes `rm` more destructive than anyone typing it expects. A safe alias adds expected behaviour, like `rm -i` or `cp -i`.
</details>

## Clean up

If a mission is still running, remove it now so it does not use memory on your machine.

First, see what is still running:

```sh
astrona list
```

Remove the mission. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-033
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *A nickname saves keystrokes at the console. It never travels into a script, and it never makes an order less predictable.*
