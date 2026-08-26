# Question

Solve this question on: `terminal` (playing the role of `data-002` from the scenario)

An internal reporting application has started failing its scheduled log writes, and monitoring shows the filesystem backing `/var/log/reporting-app` climbing toward 100% usage. You're asked to find out why the filesystem is full, reclaim the space without deleting any of the application's legitimate log files, and confirm the fix holds.

A colleague already ran `du -sh /var/log/reporting-app` and reports it as only a few megabytes, while `df` shows the volume is almost entirely full — that mismatch is your primary lead.

1. Confirm which mounted filesystem is actually full, and confirm `du` disagrees with `df` on that same filesystem.
2. Identify the process holding a deleted file open that's responsible for the missing space.
3. Reclaim the space — either by truncating the process's open file descriptor through `/proc/<pid>/fd/<n>`, or by restarting the `reporting-app` service — **without** deleting the three legitimate files already present in the directory: `reporting-app.log.1`, `reporting-app.log.2`, and `reporting-app.log.3`.
4. Confirm with `df -h` that usage on that filesystem has dropped substantially.
