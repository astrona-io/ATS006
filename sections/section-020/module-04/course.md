# Files, Links And Ownership

Astronaut, a ship is only as tidy as its cargo hold. Every day you create crates, copy them, move them to another compartment, give them a second label and hand them to another team. These orders are the most common ones on any Linux machine, and the exam expects you to type them without thinking.

This module teaches the everyday file commands (`mkdir`, `touch`, `cp`, `mv`, `rm`), the two kinds of link (hard and symbolic), and the two commands that change who owns a file (`chown` and `chgrp`). The commands look simple. Each one has one option or one habit that separates a clean result from a lost file.

## Learning objectives

After this module you can:

- Create folders with all their parents using `mkdir -p`, and create or touch empty files with `touch`.
- Copy a file or a whole tree with `cp -r`, and keep the mode and time stamp with `cp -p`.
- Explain the difference between renaming and moving with `mv`, and why `rm` has no undo.
- Make a hard link with `ln` and a symbolic link with `ln -s`, and say which one survives when the original is removed.
- Read the inode number and the link count with `ls -li` and `stat`.
- Change the owner and the group of a file or a tree with `chown` and `chgrp`, and read the result with `ls -l` and `stat`.

## Before you start

Check that you have the knowledge and the playground this module expects before you begin.

### What you should already know

- **How to type a command at a prompt.** You open a terminal, type a command and press Enter.
- **What a path is.** `/home/candidate/cargo` is a folder inside `/home/candidate`.

### What you need

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The folder `~/cargo` with `manifest.txt` (its time stamp is set to 15 January 2026, 10:00), `crew.txt` and a subfolder `crates` that holds two small files.
- The group `loaders` and the user `loadmaster`, who is a member of `loaders`.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh file-ops-links-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

1. [Create, Copy, Move And Remove](./course-01-create-copy-move-and-remove.md): `mkdir -p`, `touch`, `cp`, `mv` and `rm`, and the options that keep a copy faithful.
2. [Hard Links And Symbolic Links](./course-02-hard-and-symbolic-links.md): two ways to give a crate a second label, and what each does when the original goes away.
3. [Owners And Groups](./course-03-owners-and-groups.md): who owns a crate, and `chown` and `chgrp` with `-R`.
   - Mission: [File Operations, Links and Ownership Lab](../../../labs/lab-024/docs/question.md)
4. [Summary](./course-04-summary.md)

## Why this matters

A copy that lost its mode, a symbolic link that points at nothing, or a shared folder owned by the wrong team is a quiet fault. Nothing crashes. The wrong person just cannot read a file, or a backup holds the wrong version. These commands are small, and a careful administrator uses them with the right option every time.
