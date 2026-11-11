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

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The folder `/srv/space-practice` with three files of 50 MiB, 20 MiB and 1 MiB.
- The service `log-hog.service`. It deletes its own log file but keeps writing to it, so the space is used and no file name shows it.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh disk-space-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

1. [Two Ways Of Counting Space](./course-01-two-ways-of-counting-space.md)
2. [Find And Reclaim The Lost Space](./course-02-find-and-reclaim-the-lost-space.md)
   - Mission: [Diskspace Troubleshooting Lab](../../../labs/lab-061/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

A full filesystem stops logs, databases and uploads. The "deleted but still open" case is one of the most confusing ones, because the normal fix (find the big files and delete them) does nothing. If you know the mechanism, you can find the cause in a few commands and fix it without restarting anything.

<!-- curriculum-practice -->
## Practice and assessment

- [Diskspace Troubleshooting Lab](../../../labs/lab-061/docs/question.md): Show that df and du disagree on the same filesystem; Find the process holding a deleted file open; Reclaim the space without deleting the application's legitimate logs.
- [Diskspace & Sync Capstone Lab](../../../labs/lab-060/docs/question.md): Find the process holding a deleted file open and reclaim the space without deleting legitimate logs; Back up a directory with rsync and take a hard-linked snapshot with --link-dest.
