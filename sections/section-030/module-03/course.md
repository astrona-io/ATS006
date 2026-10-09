# Command Aliases: Safe Shortcuts Without Surprising Anyone

Astronaut, an **alias** is a nickname for an order. Type the nickname at the bridge console, and `bash` silently swaps in the full order it stands for, as if you had typed the longer version yourself. It is the simplest kind of shell customisation there is: a pure text swap that happens before `bash` even starts looking for a program to run.

That simplicity makes aliases both powerful and quietly dangerous. Powerful, because a long command that is easy to mistype becomes three letters you remember. Dangerous, because if you give a nickname that already belongs to a real command, you change what that command does for you. It stays changed, silently, until the day you forget and cannot work out why a standard command "isn't behaving like the manual page says".

## Learning objectives

After this module you can:

- Explain where aliases sit in the order `bash` uses to look up a command name.
- Check what a name really runs with `type`.
- Create a temporary alias, and make it permanent in `~/.bashrc`.
- Explain why an alias can only add arguments at the end, and write a shell function when you need more.
- Run the real command once with `\rm` or `/bin/rm`, without removing the alias.
- Explain why aliases never reach scripts or scheduled jobs, and prove it with `bash -c 'type rm'`.
- Tell a safe alias from a dangerous one.

## Before you start

Every mission starts with a pre-flight check, astronaut. Make sure you know the basics below and have a terminal ready.

### What you should already know

- **How to use the console.** You can run commands and edit a file with `nano` or `vim`.
- **What `PATH` is.** `PATH` is the list of decks the ship searches to find a crew member by name: the folders `bash` searches for a program when you type its name.

### What you need

A terminal on an Ubuntu 24.04 machine with `bash`, or a running lab machine. You open a terminal on a lab machine with `astrona ssh <lab name>`.

## How this module is laid out

1. [How Bash Expands An Alias](./course-01-how-bash-expands-an-alias.md): the lookup order, `type`, temporary and permanent aliases, and when a function is the better tool.
2. [Bypass, Scripts, And Safe Aliases](./course-02-bypass-scripts-and-safe-aliases.md): running the real command once, why scripts never see aliases, and what makes an alias safe.
   - Mission: [Command Aliases Lab](../../../labs/lab-033/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

Good aliases save thousands of keystrokes and add safety, such as a confirmation before every delete. Bad ones make a familiar command unpredictable for you and for the next person who inherits your shell. Knowing exactly where an alias works, and where it does not, also explains a whole class of "it works at my prompt but not in the script" problems.
