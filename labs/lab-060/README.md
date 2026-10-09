---
estimated_duration: 40m
---

# Diskspace & Sync Capstone Lab

Welcome to the section capstone, astronaut. The audit service's log deck is almost full, held by a deleted file that a service still has open. Mission control wants the space back and a backup rotation started straight after.

Your job is to free the space without losing real logs, take a full `rsync` backup, and then take a second snapshot that hard-links every unchanged file.

## Launching the Lab

Run this command to start the virtual machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-060
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-060
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-060
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-060
```
