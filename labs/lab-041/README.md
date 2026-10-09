---
estimated_duration: 25m
---

# Git Fundamentals Lab

Welcome to your first Git mission, astronaut. A new log parser tool needs a flight log archive built from the very first entry. Your job is to create the repository, seal three commits in the exact order mission control asks for, keep the future `build/` directory out with a `.gitignore`, and push everything to a bare `origin` with upstream tracking.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-041
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-041
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-041
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-041
```
