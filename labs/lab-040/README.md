---
estimated_duration: 45m
---

# Git Operations Capstone Lab

Welcome to the section capstone, astronaut. A shared deployment repository has three candidate flight paths, and only one turns the feature flag on. Your job is to clone the repository, merge only that branch, commit a new `scripts/` directory, push, and then rebase a topic branch onto a teammate's newer commit so the final history on the upstream is one straight line.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-040
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-040
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-040
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-040
```
