---
estimated_duration: 15m
---

# Archive Conversion & Verification Lab

Welcome to a repacking mission, astronaut. A supply archive packed with `bzip2` sits in `/imports` on your training ship. Mission control wants it repacked with `gzip` at the strongest level, with sorted listings that prove both archives hold the same files, and with the original left exactly as it was.

## Launching the Lab

Run this command to start the virtual machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-051
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-051
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-051
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-051
```
