---
estimated_duration: 30m
---

# tar Backup Strategy Lab

Welcome to a cargo protection mission, astronaut. Your training ship holds its configuration in `/etc` and its data in `/srv/appdata`, with a cache that must stay behind. Mission control wants a full backup, a true incremental backup after a change, and two restores you prove with real comparisons.

## Launching the Lab

Run this command to start the virtual machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-052
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-052
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-052
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-052
```
