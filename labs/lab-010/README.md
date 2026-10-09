---
estimated_duration: 30m
---

# Shell Semantics Integration Capstone Lab

Welcome to the section capstone, astronaut. A health-check crew member on this ship reports healthy only when its briefing pack holds the right variable, and it complains loudly if it can see a variable it should not.

Your job is to build a wrapper script that exports the right variable, keeps another one local, captures the probe's stdout, stderr, both streams together and its exit code, and exits with the probe's own code.

## Launching the Lab

Run this command to start the virtual machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-010
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-010
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-010
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-010
```
