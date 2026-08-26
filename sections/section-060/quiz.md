# Section 060 Knowledge Check: Diskspace Management & Remote Sync

Test your understanding of the `df`-versus-`du` diagnostic pattern, deleted-but-open file reclamation, and safe `rsync` mirroring and snapshot mechanics.

---

## Scenario-Based Questions

### Question 1
A production filesystem is reported by `df -h` as 97% full. You run `du -xsh` against the exact same mount point and it reports only a few hundred megabytes of visible data — nowhere close to accounting for the used space `df` reports. You've already confirmed you're scoping both commands to the same mount. What should you investigate next?
*   **A)** Assume `du` has a bug and file an issue against your distribution's coreutils package.
*   **B)** Run `fsck` on the mounted filesystem immediately to repair the discrepancy.
*   **C)** Suspect a process is holding a deleted file open, and search for it with `lsof +L1` or `lsof | grep deleted`.
*   **D)** Increase the filesystem's disk quota for the affected user to resolve the "full" alert.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: C**

*   **Why C is correct:** `df` reports space as tracked by the filesystem's own block-allocation bookkeeping — every block currently allocated to any inode, whether or not that inode still has a directory entry (name) pointing at it. `du` can only sum what it can see by walking the visible directory tree. A significant, persistent gap between the two on the same filesystem is the classic signature of a process still holding an unlinked (deleted) file's file descriptor open, keeping its blocks allocated but invisible to any directory walk. `lsof +L1` lists exactly these open files with a link count under 1.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `du` is functioning exactly as designed — it was never built to see space that has no remaining name in the directory tree; this isn't a bug.
    *   *Option B* is incorrect because `fsck` checks and repairs filesystem *metadata consistency* (broken inode links, bad blocks); it does nothing to free space legitimately held open by a running process, and running it on a live, mounted filesystem is itself risky.
    *   *Option D* is incorrect because raising a quota doesn't reclaim any space at all — it just permits the same (or worse) problem to continue consuming more of the underlying filesystem.
</details>

---

### Question 2
You run `sudo lsof +L1` while investigating a full filesystem. What exactly does the `+L1` option tell `lsof` to list?
*   **A)** Every file opened by processes owned by UID 1.
*   **B)** Every open file whose link count is less than 1 — i.e., deleted from the directory tree but still referenced by an open file descriptor.
*   **C)** Every file larger than 1 gigabyte currently open on the system.
*   **D)** Every listening network socket with fewer than 1 active connection.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `lsof`'s `+L1` option lists open files with a link count below the given threshold (here, 1) — in practice, this means files that have been unlinked (deleted) from every directory entry but are still kept alive by at least one process's open file descriptor. This is exactly the mechanism behind a `df`-versus-`du` mismatch, and the output shows the owning PID, command, and the descriptor's current size.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `+L1` has nothing to do with UID filtering; `lsof` uses `-u` for that.
    *   *Option C* is incorrect because file size filtering in `lsof` isn't expressed through `+L`; `+L1` is purely about link count, not size.
    *   *Option D* is incorrect because `+L1` applies to regular open files generally, not specifically to network socket connection counts.
</details>

---

### Question 3
You've identified PID `4821`, file descriptor `7`, as the process holding a large deleted log file open, and the service cannot be restarted during business hours. What command reclaims the space live, without interrupting the running process?
*   **A)** `sudo rm -f /proc/4821/fd/7`
*   **B)** `sudo kill -9 4821`
*   **C)** `sudo truncate -s 0 /proc/4821/fd/7`
*   **D)** `sudo systemctl stop $(ps -p 4821 -o comm=)`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: C**

*   **Why C is correct:** Each entry under `/proc/<PID>/fd/` is a symlink directly to the open file — valid for I/O even after the underlying directory entry has been unlinked. `truncate -s 0` operating through that path zeroes the file's actual content and allocated blocks through the exact same inode the process is actively writing to. The process notices nothing; its next write simply starts appending from offset zero of a now-empty file, with zero downtime.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because the file already has no directory entry to remove — `rm` on the `/proc/<PID>/fd/7` symlink itself only removes that symlink representation, it does not truncate or free the underlying data the process is still writing to.
    *   *Option B* is incorrect because it forcibly kills the process, which is the exact "interrupt the running service" outcome the scenario explicitly rules out.
    *   *Option D* is incorrect for the same reason as B — stopping the service is a restart-class fix, not a live, non-disruptive reclaim.
</details>

---

### Question 4
You run `rsync -a /srv/website nas:/backup/site-mirror/` (no trailing slash on the source) expecting the *contents* of `/srv/website` to land directly inside `/backup/site-mirror/`. Instead, after the sync, you find everything nested one level deeper than expected. What caused this?
*   **A)** `rsync -a` always nests the destination one extra level regardless of trailing slashes.
*   **B)** The missing trailing slash on the source told rsync to sync the source directory itself into the destination, creating `/backup/site-mirror/website/...` instead of syncing its contents directly.
*   **C)** The destination path needed a trailing slash instead, and the source path was actually correct.
*   **D)** This only happens when `--delete` is omitted from the command.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** Without a trailing slash, `rsync` treats the source directory itself — not just its contents — as the thing being synced, so it creates a same-named directory (`website`) inside the destination. With a trailing slash (`/srv/website/`), `rsync` syncs the *contents* of that directory directly into the destination instead. This is one of the most commonly misremembered `rsync` behaviors precisely because both forms are valid syntax that silently produce different results.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because nesting is entirely conditional on the trailing slash, not an unconditional behavior of `-a`.
    *   *Option C* is incorrect because the destination's trailing slash doesn't control this behavior — the source's trailing slash is what matters here.
    *   *Option D* is incorrect because `--delete` controls whether stale destination files are removed; it has no bearing on the trailing-slash nesting behavior.
</details>

---

### Question 5
You've already taken a full mirror of `/srv/appdata` to `nas:/backup/appdata/`. You now want a second, space-efficient snapshot at `nas:/backup/snapshots/day2/` where files unchanged since the first mirror don't consume extra disk space, but the snapshot still looks like a complete, independent, browsable directory. Which approach correctly achieves this, and what's the one hard requirement for it to actually save space?
*   **A)** `rsync -a --link-dest=/backup/appdata /srv/appdata/ nas:/backup/snapshots/day2/` — but the `--link-dest` reference and the new snapshot destination must be on the same filesystem, or rsync silently falls back to full copies.
*   **B)** `tar --listed-incremental=snap.snar -czf day2.tar.gz /srv/appdata` — this produces an independently browsable directory just like `--link-dest` does.
*   **C)** `rsync -a --delete /srv/appdata/ nas:/backup/snapshots/day2/` — `--delete` alone is sufficient to make this space-efficient.
*   **D)** `cp -r /backup/appdata /backup/snapshots/day2` — plain recursive copy is just as space-efficient as `--link-dest`.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: A**

*   **Why A is correct:** `--link-dest` tells rsync that for any file unchanged compared to the reference directory, it should create a hardlink to the existing data instead of copying it again — the new snapshot gets a full, independently browsable set of directory entries, while unchanged files cost zero extra disk space by sharing the same underlying inode. This only works, however, when the reference directory and the destination live on the same filesystem, since hardlinks cannot cross filesystem boundaries; if they don't, rsync silently falls back to full copies with no error, quietly losing the entire benefit.
*   **Why others are incorrect:**
    *   *Option B* is incorrect because a `tar --listed-incremental` archive is a dependent delta — it has no meaning on its own and cannot be browsed or restored without replaying the full archive and every prior increment in sequence, unlike a standalone `--link-dest` snapshot directory.
    *   *Option C* is incorrect because `--delete` only controls removing stale destination files to match the source; it has nothing to do with hardlinking unchanged files or saving space on a new snapshot directory.
    *   *Option D* is incorrect because a plain recursive copy duplicates every byte of every file's data into new blocks — it is the opposite of space-efficient, with none of the inode-sharing behavior `--link-dest` provides.
</details>
