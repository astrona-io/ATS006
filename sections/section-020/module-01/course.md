# chmod: Symbolic vs Octal, and the Three Special Bits

Astronaut, every crate in your ship's cargo hold carries a small lock badge. A file is a crate, and a directory is a cargo compartment that holds crates. The badge says who may look inside, who may change the contents, and who may run it or walk into the compartment. It does this separately for three kinds of crew: the crate's owner, the owner's team, and everyone else aboard.

`chmod` (short for "change mode") is the tool that edits that badge. For one person working alone, it is simple. Once a whole team shares the same compartments, those nine permission bits, plus three special bits on top, decide whether the team works together cleanly or keeps stepping on each other's work.

## Learning objectives

After this module you can:

- Read the nine permission bits in the first column of `ls -l`, for the owner, the group and everyone else.
- Write the same permissions in symbolic notation (`u+x`, `go-w`) and in octal notation (`750`), and convert between them by hand.
- Turn a plain-English requirement ("the group can read and enter, but not change anything") into an octal mode.
- Use capital `X` with `chmod -R` so directories stay enterable without making plain data files executable.
- Explain what setuid, setgid and the sticky bit do, and set each one with a fourth octal digit or a symbolic letter.
- Build a shared team directory where new files inherit the team's group, and a shared drop folder where people can delete only their own files.

## Before you start

This module needs very little, but check two things before your first mission.

### What you should already know

- **How to move around the shell.** You can use `cd`, `ls`, `mkdir` and `touch`, and you know what a path like `/srv/projects` means.
- **Users and groups exist.** Every person on a Linux machine is a user, and users belong to one or more groups. Each user has one main group, called the primary group.
- **`sudo` runs a command as the captain.** `root` is the captain of the ship. `sudo` lets you borrow the captain's authority for one command.

### What you need

A terminal on an Ubuntu 24.04 machine with `bash`, where you can use `sudo`. A running lab machine works too: start a lab and open a terminal on it with `astrona ssh <lab name>`. The examples create their own test folders under `/srv` and `/tmp`, so they do not touch anything important.

## How this module is laid out

Read the parts in order. The mission comes right after the part that teaches its skills.

1. [Reading And Setting Permission Bits](./course-01-reading-and-setting-permission-bits.md): the nine bits, symbolic and octal notation, and safe recursive changes.
2. [The Three Special Bits](./course-02-the-three-special-bits.md): setuid, setgid and the sticky bit.
   - Mission: [chmod Permission Bits Lab](../../../labs/lab-021/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

Almost every "it works for me but not for my teammate" problem on a shared server comes down to a permission bit. A shared folder without the right group bit scatters files across everyone's private groups. A script that anyone can edit is a security hole. The exam asks you to set exactly these modes by hand, from a description, so you need to read and write them without a table.
