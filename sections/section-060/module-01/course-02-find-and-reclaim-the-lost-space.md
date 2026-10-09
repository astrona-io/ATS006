# Find And Reclaim The Lost Space

When `df` says a filesystem is full and `du` says it is nearly empty, a deleted file that a process still holds open is the usual cause. This part shows how to find that process and how to win the space back, with or without restarting it.

## Hunting the culprit

Once the numbers from `df` and `du` disagree on the same filesystem, you need two facts: which process holds the deleted file, and how big the file is now. Two tools give you both.

### List deleted files that are still open

Run `lsof` with the `+L1` option:

```bash
sudo lsof +L1
```

`lsof` lists open files. Think of it as the roster of which crew member holds which crate. The `+L1` option shows only open files whose link count is less than 1. In plain words: files that were deleted from the directory tree, but that at least one process still holds open.

Each line shows the command name, the PID (the process's badge number), the user, the file descriptor and the file's current size. That tells you who to blame and how much space the fix will free.

### Look at the process's open files in `/proc`

Every open file descriptor of a process is also visible under `/proc`, a folder the kernel fills with live information about each process. Replace `<PID>` with the number from `lsof`:

```bash
sudo ls -l /proc/<PID>/fd/
```

Each entry is a symbolic link to the file that descriptor points at. For a deleted file, the link target ends with `(deleted)`.

The important point: that link still works for reading and writing. The kernel does not care that the name is gone. It only cares about the inode, and the descriptor still points straight at it.

## Reclaiming the space without restarting anything

There are two safe fixes. The first keeps the process running. The second restarts it.

### Truncate the file through the process's own descriptor

You can empty a deleted file that is still open through the process's own file descriptor, without touching the process at all. Replace `<PID>` and `<N>` with the numbers from `lsof`:

```bash
sudo truncate -s 0 /proc/<PID>/fd/<N>
```

`truncate -s 0` sets the file's size to zero. Because it works on the same inode the process is writing to, the process notices nothing. Its next write simply lands in a file that is now empty. There are no dropped connections, no restart and no break in its work. This is the fix you want for a long-running service that must not stop.

### Or restart the service

If a restart is acceptable, the fix is simpler. This suits services that open their log files again cleanly when they start:

```bash
sudo systemctl restart <service-name>
```

`systemd`, the ship's duty officer, stops the process and starts it again. The old process closes its file descriptor when it stops. Now the kernel's two counters both reach zero, and the kernel frees the blocks by itself. You do not need to truncate anything, because nothing points at that inode any more.

### What never works

Deleting more visible files never brings this space back. The missing space is not tied to any name `rm` can see. That is the whole point of this kind of problem.

## Practise on a test file

You can build the problem yourself and fix it, step by step:

1. Create the mismatch: `tail -f /dev/zero > /tmp/leaktest & sleep 2; rm /tmp/leaktest`. Run `df -h /tmp` and `du -sh /tmp` and see whether they still agree.
2. Find the process with `sudo lsof +L1 | grep leaktest`, and note its PID and file descriptor number.
3. Look at the descriptor directly: `sudo ls -l /proc/<PID>/fd/<N>`, and check that the link target ends with `(deleted)`.
4. Reclaim the space without stopping the background job: `sudo truncate -s 0 /proc/<PID>/fd/<N>`.
5. Run `df -h /tmp` again and check that usage dropped. Then stop the background job with `kill %1`.
6. Explain in your own words why running `rm -rf` over `/tmp` before step 4 would have freed nothing.

## Common pitfalls

> [!WARNING]
> - **Deleting more files.** The lost space has no name left, so `rm` cannot reach it. You may also delete logs you still need.
> - **Truncating the wrong descriptor.** Check the target with `ls -l /proc/<PID>/fd/<N>` first. It must end with `(deleted)` and be the file you expect.
> - **Killing the process without a plan.** A restart frees the space, but only use it when the service can take a restart. Truncating through `/proc` keeps it running.
> - **Not checking the result.** Run `df -h` again and `sudo lsof +L1` again. The usage should drop, and the deleted file should be gone from the list.

## Your mission: Diskspace Troubleshooting Lab

You can now prove that `df` and `du` disagree, find the process that holds a deleted file open, and reclaim the space safely. The mission puts you on a ship whose log deck is almost full: find the cause and free the space without deleting any real log file.

Start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-061
```

Open a terminal on the lab machine:

```sh
astrona ssh ats-006-lab-061
```

Read the task in [question.md](../../../labs/lab-061/docs/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona submit -c labs/lab-061
```

When the mission is done, remove it:

```sh
astrona destroy ats-006-lab-061
```
