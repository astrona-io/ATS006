---
estimated_duration: 45m
---

# Archiving & Backup Capstone Lab

Welcome to the section capstone, astronaut. Your training ship has two jobs waiting. First, repack a report archive from `bzip2` to level 9 `gzip` and prove both archives hold the same files. Second, run a full and a true incremental backup of a service directory, leave its temporary data behind, and prove two restores, including a locked-down secrets file.

## Launching the Lab

Run this command to start the virtual machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-050
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-050
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-050
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-050
```
