# Mirroring and Space-Efficient Incremental Snapshots with rsync

Astronaut, a backup made with `tar` is a sealed shipping container: one file you build once and store somewhere safe. A lot of real work is different. You need two cargo holds, often on two different ships, to stay the same over time. `rsync` is the tool for that job. Think of it as a supply run that copies only what changed to the other ship.

This module covers two things `rsync` does well. First, it keeps a destination as an exact mirror of a source, including removing what the source no longer has. Second, it takes a series of snapshots that each look like a full copy, but share the unchanged files on disk.

## Learning objectives

After this module you can:

- Explain what `-a` (archive mode) bundles together, and why a backup needs it.
- Predict what a trailing slash on the source path does to the destination layout.
- Mirror a directory with `--delete`, and always preview it first with a dry run (`-n`).
- Keep a subtree out of a sync with `--exclude`, and keep exclude lists the same from run to run.
- Take a snapshot with `--link-dest` that hard-links unchanged files, and prove it with `stat` and `du`.
- Explain why the `--link-dest` reference must be on the same filesystem as the destination.

## Before you start

Check that you have the knowledge and the tools this module expects before you begin.

### What you should already know

- **Files and directories.** You can list files with `ls -l` and read a file's details with `stat`.
- **Paths.** You know the difference between a path to a directory and a path to its contents.
- **Remote login.** You know that `ssh` opens a terminal on another machine.

### What you need

A terminal on an Ubuntu 24.04 machine with `bash` and `rsync`. A running lab machine works too: start the lab and open a terminal on it with `astrona ssh <lab name>`. Most practice steps work between two local folders, so you do not need a second machine.

## How this module is laid out

1. [Mirror A Directory Safely](./course-01-mirror-a-directory-safely.md)
2. [Space-Efficient Snapshots With Link Dest](./course-02-space-efficient-snapshots-with-link-dest.md)
   - Mission: [rsync Mirroring & Snapshots Lab](../../../labs/lab-062/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

Keeping two machines in sync, and keeping a history of snapshots you can browse, are everyday jobs. `rsync` does both with one tool. It also has one of the most dangerous options in daily use, `--delete`, so the safe habits in this module protect real data.
