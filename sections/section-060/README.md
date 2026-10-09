# Section 060: Diskspace Management & Remote Sync

Astronaut, this section is about cargo: how much room your ship really has, and how to keep a copy of your cargo safe on another ship. The two problems look unrelated, but both come down to one skill. You must know what the filesystem really tracks, not only what a directory listing shows.

First, you chase one of the most confusing "disk full" alarms on Linux. The deck's fuel gauge, `df`, says the filesystem is nearly full. Counting the crates you can see, with `du`, finds almost nothing. The gap is real, a directory walk cannot see it, and deleting more files never fixes it. Then you move from one ship to two. You use `rsync`, a supply run that copies only what changed, to keep two directory trees in sync and to take snapshots that share their unchanged files.

**Exam topics covered:** troubleshoot disk space issues, and copy data between machines.

---

## What You Will Master

- Why `df` and `du` count space in different ways, and what a lasting gap between them means on one filesystem.
- When the kernel really frees a deleted file: no name left, and no process holding it open.
- Finding the process that holds a deleted file open with `lsof +L1` and `/proc/<PID>/fd/`.
- Reclaiming the space live with `truncate` through the process's own descriptor, or with a service restart.
- What `rsync -a` keeps, and what a trailing slash on the source does to the destination.
- Building a true mirror with `--delete`, always previewed with a dry run, and keeping a subtree out with `--exclude`.
- Taking snapshots with `--link-dest` that hard-link unchanged files, and proving it with `stat` and `du`.

---

## Modules In This Section

Work through the modules in this order. Each part teaches one idea. A mission (a graded lab) comes right after the part it practises, and the last page of each module is a wrap-up. The capstone at the end uses everything in the section at once.

### [Diskspace Troubleshooting: The Full Filesystem That du Can't Explain](module-01/course.md)

2 parts and 1 mission:

1. [Two Ways Of Counting Space](module-01/course-01-two-ways-of-counting-space.md)
2. [Find And Reclaim The Lost Space](module-01/course-02-find-and-reclaim-the-lost-space.md)
   - Mission: [Diskspace Troubleshooting Lab](../../labs/lab-061/docs/question.md)
3. [Wrap-Up: Mission Debrief](module-01/course-03-wrap-up.md)

### [Mirroring and Space-Efficient Incremental Snapshots with rsync](module-02/course.md)

2 parts and 1 mission:

1. [Mirror A Directory Safely](module-02/course-01-mirror-a-directory-safely.md)
2. [Space-Efficient Snapshots With Link Dest](module-02/course-02-space-efficient-snapshots-with-link-dest.md)
   - Mission: [rsync Mirroring & Snapshots Lab](../../labs/lab-062/docs/question.md)
3. [Wrap-Up: Mission Debrief](module-02/course-03-wrap-up.md)

### Knowledge check

Before the capstone, test your reasoning with the [Section 060 Knowledge Check](./quiz.md).

### Capstone

Your final mission for this section: **[Diskspace & Sync Capstone Lab](../../labs/lab-060/docs/question.md)**. A log deck is almost full because of a deleted file that a service still holds open. Free the space without losing real logs, then start a hard-linked backup rotation of that deck with `rsync`.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-060
astrona ssh ats-006-lab-060
```

When you think you are done, send it for grading, then remove it:

```sh
astrona submit -c labs/lab-060
astrona destroy ats-006-lab-060
```
