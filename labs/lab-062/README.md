---
estimated_duration: 25m
---

# rsync Mirroring & Snapshots Lab

Welcome to a supply run, astronaut. Two ships fly in formation: `data-001` (`10.10.60.5`) holds the working tree at `/srv/appdata`, and `data-002` (`10.10.60.10`) holds the backup at `/backup/appdata`. They share a private network, `10.10.60.0/24`.

Your job is to mirror the working tree to `data-002` over SSH, safely, and then take a snapshot that hard-links every unchanged file.

## Access between the machines

`data-001` has key-based SSH trust to `data-002`, set up for you by the lab. So `ssh data-002` and `rsync -e ssh ... data-002:/backup/appdata/` work from `data-001` with no password. Both names are in each machine's `/etc/hosts`.

## Launching the Lab

Run this command to start the two virtual machines:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-062
```

Open a terminal on the lab. The task runs on `data-001`, so check where you are with `hostname`:

```bash
astrona ssh ats-006-lab-062
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-062
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-062
```
