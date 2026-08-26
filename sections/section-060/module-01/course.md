# Diskspace Troubleshooting: The Full Filesystem That du Can't Explain

Every sysadmin eventually gets paged for a "disk full" alert, opens a shell, and finds a filesystem sitting at 100%. Most of the time this is boring: someone's log directory grew too large, and `du` will point you straight at it. But every so often, `du` lies to you — not maliciously, but structurally. It reports a directory using a fraction of the space `df` says is occupied on the very same filesystem, and no amount of deleting visible files closes that gap. Understanding *why* that happens, and how to fix it without restarting a service you can't afford to bounce, is one of the sharpest diagnostic skills a Linux administrator can carry.

## Two Different Ways of Counting Space

Think of a filesystem as a warehouse with two separate record-keeping systems. `df` is the warehouse's master inventory ledger — it tracks how many storage bins (blocks) are currently checked out, full stop, regardless of whether anyone remembers what's in them or where the shelf label went. `du` is a clipboard-carrying auditor who physically walks every aisle, reads every shelf label (directory entry) they can find, and adds up the sizes of everything they can actually see by name.

Under normal conditions, these two numbers roughly agree — every block that's checked out (`df`) belongs to a file that still has a name somewhere in the directory tree (`du` can see it). The mismatch appears the moment a bin gets checked out to someone, but its shelf label is torn down while they're still using it. The ledger still shows it checked out. The auditor, walking the aisles, has nothing left to read and can't count it.

```bash
df -h /var/log
du -xsh /var/log
```

`df -h` reports human-readable usage as tracked by the filesystem's own block-allocation bookkeeping — the superblock and inode accounting. `du -xsh` walks the visible directory tree and sums what it can see, with `-x` keeping it from wandering onto a different mounted filesystem nested underneath (which would otherwise make the comparison meaningless) and `-s` collapsing the result into one total.

## The Mechanism: Link Counts, Open File Descriptors, and Deletion

On Linux, a file isn't really "deleted" the moment you run `rm`. What actually happens is more subtle: every file is an inode — a block of metadata describing size, permissions, and where its data blocks live — and a directory entry is just a name pointing at that inode. `rm` removes the *name*, decrementing the inode's link count. The kernel only actually frees an inode's blocks back to the filesystem once **two** conditions are both true: the link count reaches zero (no directory entry points at it anymore) *and* the open file descriptor count reaches zero (no running process still has it open).

This is why a process that opened a file *before* it was deleted keeps that file's data blocks alive indefinitely — it still has a live file descriptor referencing the inode, even though the inode has no name left anywhere in the filesystem. Picture a background video-transcoding worker that opens a large temporary render file at `/var/spool/videoq/render.tmp`, and midway through a long job, a poorly-written cleanup cron fires and deletes every `*.tmp` file older than an hour. The cron's `rm` succeeds instantly and reports nothing wrong — but the transcoding worker still has that exact inode open, still writing frames into it. `du` can no longer see `render.tmp` anywhere, because there's no name left to find. `df` still shows every gigabyte of it as allocated, because the inode is still very much alive, kept alive by that one open file descriptor.

## Hunting the Culprit

Once a `df`-versus-`du` mismatch on the same filesystem points you toward a held-open deleted file, you need to find exactly which process is responsible and how large the leak currently is.

```bash
sudo lsof +L1
```

`lsof`'s `+L1` option lists every open file whose link count is less than 1 — in plain terms, files that have been unlinked (deleted) from the directory tree but are still referenced by at least one open file descriptor. The output shows the command name, PID, user, and the file descriptor's current size, which tells you both who to blame and how much space reclaiming it will actually free.

Every open file descriptor a process holds is also visible directly under `/proc`:

```bash
sudo ls -l /proc/<PID>/fd/
```

Each entry is a symlink to the file the descriptor points at. For a deleted file, the symlink target is annotated `(deleted)` — but critically, the symlink still works for I/O. The kernel doesn't care that the name is gone; it only cares about the inode, and the fd still points straight at it.

## Reclaiming Space Without Restarting Anything

The single most useful fact in this whole chapter is that you can zero out a held-open deleted file's content *through the process's own file descriptor*, without touching the process at all:

```bash
sudo truncate -s 0 /proc/<PID>/fd/<N>
```

Because this operates on the same inode the process is actively writing to, the process notices nothing — its next write simply starts appending from offset zero of a now-empty file. No dropped connections, no restart, no interruption to whatever the process was doing. This is exactly the fix you want for a long-running service that can't tolerate a bounce.

If a restart is acceptable instead — appropriate for services designed to reopen their log files cleanly on startup — the equivalent fix is simpler:

```bash
sudo systemctl restart <service-name>
```

Restarting forces the process to close its old file descriptor. At that point the kernel's link-count-and-fd-count bookkeeping finally reaches zero on both sides, and the blocks are freed automatically — no manual truncation required, because there's nothing left referencing that inode at all.

What will *never* work is deleting more visible files. There's nothing left to delete that the missing space is attached to — the whole point of this class of bug is that the space isn't tied to anything `rm` can see anymore.

## Self-Check and Verification

To prove you can diagnose and fix this class of problem yourself:

1. Reproduce the mismatch: `tail -f /dev/zero > /tmp/leaktest & sleep 2; rm /tmp/leaktest`. Run `df -h /tmp` and `du -sh /tmp` and notice they no longer agree.
2. Find the responsible process with `sudo lsof +L1 | grep leaktest`, and note its PID and file descriptor number.
3. Inspect the descriptor directly: `sudo ls -l /proc/<PID>/fd/<N>` and confirm the symlink target is annotated `(deleted)`.
4. Reclaim the space live, without killing the background job: `sudo truncate -s 0 /proc/<PID>/fd/<N>`.
5. Re-run `df -h /tmp` and confirm usage dropped, then stop the background job with `kill %1` and clean up.
6. Explain, in your own words, why a plain `rm -rf` sweep of `/tmp` before Step 4 would have done absolutely nothing to reclaim that space.
