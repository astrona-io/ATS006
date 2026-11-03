---
estimated_duration: 20m
---

# SSL Certificate Generation Lab

Welcome to a badge mission, astronaut. An internal station on this training ship needs encrypted traffic for the hostname `internal.web-srv1.local`, and it has no key or certificate yet.

Your job is to make its secret seal (a private key), a self-signed ID badge with the right name on it, and a badge application form for the badge office, and then prove the seal and the badge belong together.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-073
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-073
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-073
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-073
```
