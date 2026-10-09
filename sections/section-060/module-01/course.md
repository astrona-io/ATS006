# Diskspace Troubleshooting: The Full Filesystem That du Can't Explain

Astronaut, sooner or later an alarm goes off on your ship: a cargo deck is full. Most of the time the cause is easy to find, because one compartment simply grew too large. But sometimes the deck's fuel gauge says "full" while counting the crates you can see adds up to almost nothing. This module teaches you why that happens, and how to win the space back without stopping a station that must keep running.

The gauge is `df`, and the crate count is `du`. When they disagree on the same filesystem, the usual cause is a deleted file that a running process still holds open.

## Learning objectives

After this module you can:

- Explain how `df` and `du` count space in two different ways.
- Show that `df` and `du` disagree on the same filesystem, with `-x` keeping `du` on that one filesystem.
- Explain when the kernel really frees a deleted file's space: no names left, and no process holding it open.
- Find the process that holds a deleted file open with `lsof +L1` and the `/proc/<PID>/fd/` folder.
- Reclaim the space live with `truncate` through the process's own file descriptor, or by restarting its service.
- Explain why deleting more visible files never fixes this problem.

## Before you start

Check that you have the knowledge and the tools this module expects before you begin.

### What you should already know

- **Files and directories.** You can move around the filesystem with `cd`, list files with `ls -l`, and delete a file with `rm`.
- **Running commands as root.** You know that `sudo` runs one command with the captain's authority.
- **Services.** You know that `systemctl` starts, stops and restarts a service.

### What you need

A terminal on an Ubuntu 24.04 machine with `bash`, where you can use `sudo`. A running lab machine works too: start the lab and open a terminal on it with `astrona ssh <lab name>`.

## How this module is laid out

1. [Two Ways Of Counting Space](./course-01-two-ways-of-counting-space.md)
2. [Find And Reclaim The Lost Space](./course-02-find-and-reclaim-the-lost-space.md)
   - Mission: [Diskspace Troubleshooting Lab](../../../labs/lab-061/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

A full filesystem stops logs, databases and uploads. The "deleted but still open" case is one of the most confusing ones, because the normal fix (find the big files and delete them) does nothing. If you know the mechanism, you can find the cause in a few commands and fix it without restarting anything.
