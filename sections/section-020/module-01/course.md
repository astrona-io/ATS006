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

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The folder `/srv/chmod-practice` with `notes.txt`, a script `run-report.sh` (not yet executable) and a subfolder `shared`.
- The group `crew` and the user `crewmate`, who is a member of `crew`.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh chmod-bits-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

Read the parts in order. The mission comes right after the part that teaches its skills.

1. [Reading And Setting Permission Bits](./course-01-reading-and-setting-permission-bits.md): the nine bits, symbolic and octal notation, and safe recursive changes.
2. [The Three Special Bits](./course-02-the-three-special-bits.md): setuid, setgid and the sticky bit.
   - Mission: [chmod Permission Bits Lab](../../../labs/lab-021/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

Almost every "it works for me but not for my teammate" problem on a shared server comes down to a permission bit. A shared folder without the right group bit scatters files across everyone's private groups. A script that anyone can edit is a security hole. The exam asks you to set exactly these modes by hand, from a description, so you need to read and write them without a table.

<!-- curriculum-practice -->
## Practice and assessment

- [chmod Permission Bits Lab](../../../labs/lab-021/docs/question.md): Lock a shared directory to its owner and group, with new files inheriting the group; Make a script executable by its owner only; Protect a shared drop folder so users can delete only their own files.
- [Permissions & File Triage Capstone Lab](../../../labs/lab-020/docs/question.md): Give a user a persistent umask that makes 640 files and 750 directories; Set the setgid, owner-only and sticky permissions on a shared team workspace; Triage a folder with find by age, size and permission, in the order given; Stage a release with copy, move, hard and symbolic links, remove and group ownership.
