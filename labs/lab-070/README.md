---
estimated_duration: 45m
---

# Service Configuration Capstone Lab

Welcome to the section capstone, astronaut. A health-check script on this training ship runs with nobody watching it, and it will soon be reached over an encrypted channel.

Your job is to hand it to systemd as a proper service with its own user, tune its restart delay with a drop-in override instead of editing its unit file, and give it a private key and a self-signed certificate with the right name, proven to belong together.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-070
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-070
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-070
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-070
```
