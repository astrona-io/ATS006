---
estimated_duration: 20m
---

# systemd Unit Override Lab

Welcome to a service mission, astronaut. This training ship runs `nginx`, installed by a package, and the package owns its unit file. If the service crashes, nothing brings it back.

Your job is to give it a restart policy and an extra environment variable with a drop-in override, a sticky note on the duty card, and to leave the package's own file exactly as it shipped.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-072
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-072
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-072
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-072
```
