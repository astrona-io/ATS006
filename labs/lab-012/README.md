---
estimated_duration: 15m
---

# Environment Variable Scope Lab

Welcome to a briefing mission, astronaut. Your user already carries one exported variable in its briefing pack.

Your job is to write a script that keeps one value on its own console, hands another one on to every crew member it starts, and leaves `~/.bashrc` exactly as it is.

## Launching the Lab

Run this command to start the virtual machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-012
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-012
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-012
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-012
```
