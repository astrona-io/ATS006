# Section 060: Diskspace Management & Remote Sync

Welcome to Section 060. In this section, we solve two problems that look unrelated on the surface but both come down to the same underlying skill: understanding what the filesystem is *actually* tracking, versus what a simple directory listing shows you.

First, you'll chase down one of the most confusing "disk full" incidents in Linux administration: a filesystem `df` reports as nearly full, while `du` insists there's barely anything there. The gap is real, it's invisible to a directory walk, and deleting more files will never fix it. Then, you'll move from diagnosing space on one machine to efficiently mirroring and snapshotting it across two — using `rsync` to keep two directory trees genuinely in sync, and to take space-efficient incremental snapshots without needing a chain of dependent archive files.

---

## What You Will Master

By completing this section, you will acquire three core diagnostic and data-movement capabilities:
*   **Filesystem Accounting Literacy:** Why `df` and `du` measure space differently, and what a persistent mismatch between them specifically means.
*   **Live Space Reclamation:** How to find a process holding a deleted file open with `lsof`/`/proc`, and reclaim its space with or without restarting the process.
*   **Efficient Tree Mirroring & Snapshotting:** How to use `rsync` to build a true mirror between hosts (including safe use of `--delete`) and take hardlink-based incremental snapshots with `--link-dest`.

---

## The Learning & Lab Path

This section is divided into two modules, each paired with its own hands-on practice lab:

### 1. Diskspace Troubleshooting — The Full Filesystem That du Can't Explain
*   **Module Reader:** **[Module 1: Diskspace Troubleshooting](./module-01/course.md)**
*   **Associated Lab:** **[lab-061](../../labs/lab-061)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-061
    ```
*   **Hands-on Objective:** Confirm which mount is full, prove `du` disagrees with `df` on that same filesystem, find the process holding a deleted file open with `lsof +L1`, and reclaim the space without touching any legitimate log data.

### 2. Mirroring and Space-Efficient Incremental Snapshots with rsync
*   **Module Reader:** **[Module 2: rsync Mirroring & Snapshots](./module-02/course.md)**
*   **Associated Lab:** **[lab-062](../../labs/lab-062)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-062
    ```
*   **Hands-on Objective:** Mirror `data-001`'s working tree to `data-002` over SSH with `rsync --delete`, excluding a scratch directory, then take a second `--link-dest` snapshot that only spends disk space on files that actually changed.

---

## Ready for Assessment?

Test your theoretical knowledge and diagnostic reasoning before tackling the capstone mission:

*   **[Take the Section 060 Knowledge Check Quiz](./quiz.md)**
