# Bypass, Scripts, And Safe Aliases

Astronaut, an **alias** is a nickname for an order, and `bash`, the shell, swaps it in before it looks for any real command. In this part you learn to step around a nickname exactly once, see why scripts and scheduled jobs never use your nicknames, and learn what separates a safe alias from a dangerous one.

The examples use a safety alias, `alias rm='rm -i'`. With it, `rm` asks for confirmation before it deletes each file.

## Bypass an alias for one command

Sometimes you need the *real*, unaliased command exactly once, without giving up the alias's protection for everything else. This section shows two ways to do it, and one way that is worse.

### Two ways that leave the alias in place

```bash
\rm somefile        # leading backslash disables alias expansion for this word only
/bin/rm somefile    # an absolute path also bypasses alias lookup entirely
```

A backslash in front of the word tells `bash` not to expand an alias for that one word. A full path such as `/bin/rm` is not a plain name, so `bash` never looks it up as an alias at all. Either way, the alias is still defined afterwards for every other `rm` you type.

The backslash is the faster of the two, because you do not need to know or type the program's full path.

### Why not unalias

`unalias rm` also works, but it is slower and easy to forget to undo. You can leave `rm` unprotected for the rest of the session by accident.

### Try it with cp

Set a safety alias for `cp` and watch it ask before it overwrites a file:

```sh
alias cp='cp -i'
echo first > copy-test.txt
cp copy-test.txt copy-test-backup.txt
cp copy-test.txt copy-test-backup.txt
```

The second `cp` asks whether to overwrite `copy-test-backup.txt`. Answer `n`. Now run the real `cp` once:

```sh
\cp copy-test.txt copy-test-backup.txt
type cp
```

`\cp` overwrote the file without asking, and `type cp` still reports that `cp` is aliased to `cp -i`.

## Why aliases don't reach scripts or scheduled jobs

An alias lives in your interactive shell, the one you type into. A script or a scheduled job (a `cron` job) runs in a **non-interactive shell**, a shell that reads commands from a file or a string and never shows you a prompt. This section shows why your aliases never reach it.

### See it with bash -c

Alias expansion is turned off by default in non-interactive shells. You can prove it in one line:

```bash
bash -c 'type rm'
```

Run this in a shell where `rm` is aliased to `rm -i` in your interactive `~/.bashrc`. It still reports the real path to the `rm` program, not the alias. `bash -c` starts a non-interactive shell, and non-interactive shells do not expand aliases by default, whatever your interactive startup file defines.

### Even sourcing ~/.bashrc does not help

This matters even more than it first looks. Many distributions' default `~/.bashrc` starts with a guard like `[ -z "$PS1" ] && return`. That guard makes non-interactive shells skip everything below it, including the alias lines, even if a script sources `~/.bashrc` at the top.

So a script that calls `rm` runs the real, unchanged `rm`, whatever safety alias you set for interactive use. If a task needs a behaviour inside scripts or scheduled jobs, an alias is the wrong tool. Use a real script in a `PATH` folder, or a function, instead.

### Try it with your cp alias

With `alias cp='cp -i'` still set at your prompt, run:

```sh
bash -c 'type cp'
```

It reports the real `cp` file path, not the alias. The new shell is non-interactive, so it never expanded your alias.

## What makes an alias safe

The point of an alias is to save keystrokes on something you would type the same way every time. This section gives the rule for telling a good alias from a bad one.

### Safe and dangerous examples

A good alias adds behaviour a reasonable person would expect and want by default:

- `alias cp='cp -i'`
- `alias grep='grep --color=auto'`
- `alias df='df -h'`

A dangerous alias silently changes how much damage a command can do, in a way nobody typing that name would expect. For example, one that quietly adds an option to skip confirmation prompts, or one that makes a normally safe command destructive.

An alias should never be the reason a command becomes *less* predictable for the next person who types it, and that includes future you.

## Common pitfalls

> [!WARNING]
> - **Removing the safety alias to run the real command once.** `unalias rm` leaves you unprotected until you remember to redefine it. Use `\rm` or `/bin/rm` instead.
> - **Expecting an alias to protect a script.** Scripts and scheduled jobs run non-interactive shells, which do not expand aliases. The script runs the real command.
> - **Sourcing `~/.bashrc` in a script to get aliases.** The guard at the top of many default `~/.bashrc` files stops non-interactive shells before they reach the alias lines.
> - **Aliasing a name to something surprising.** An alias that removes a confirmation or makes a command destructive will catch someone out. Keep aliases predictable.

## Your mission: Command Aliases Lab

You can now make aliases permanent, check what a name runs, and step around an alias exactly once. The mission asks you to persist three aliases, including a safety alias for `rm`, and then delete one file with the real `rm` without disabling that alias.

Start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-033
```

Open a terminal on the lab machine:

```sh
astrona ssh ats-006-lab-033
```

Read the task in [the question](../../../labs/lab-033/docs/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona submit -c labs/lab-033
```

When the mission is done, remove it:

```sh
astrona destroy ats-006-lab-033
```
