---
estimated_duration: 20m
---

# systemd Unit Creation Lab

Welcome to a service mission, astronaut. A metrics script on this training ship runs with nobody watching it. If it dies, it stays dead, and it does not come back after a reboot.

Your job is to hand it to systemd, the ship's duty officer: give it its own system user, write its unit file, and make sure it is running now and after every boot.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-071
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-071
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-071
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-071
```
