---
estimated_duration: 15m
---

# Shell Redirection & Exit Code Diagnostics Lab

Welcome to a wiring mission, astronaut. A diagnostic crew member on this ship writes one line of normal output, one line of warnings and hands back the same status code every time.

Your job is to re-patch its signal lines: stdout into one file, stderr into another, both together into a third, and its exit code into a fourth.

## Launching the Lab

Run this command to start the virtual machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-011
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-011
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-011
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-011
```
