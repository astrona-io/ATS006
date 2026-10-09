# Question

Solve this question on: `terminal` (playing the role of `data-002` from the scenario)

Astronaut, an alarm is going off on your ship. The internal reporting application has started failing its scheduled log writes, and monitoring shows the filesystem behind `/var/log/reporting-app` climbing toward 100% usage.

A crew mate already ran `du -sh /var/log/reporting-app`. It reports only a few megabytes, while `df` shows the filesystem is almost full. That gap is your main lead.

1. Confirm which mounted filesystem is full, and confirm that `du` disagrees with `df` on that same filesystem.
2. Find the process that holds a deleted file open and is responsible for the missing space.
3. Reclaim the space, either by truncating the process's open file descriptor through `/proc/<pid>/fd/<n>`, or by restarting the `reporting-app` service.
4. Do **not** delete the three legitimate files in the directory: `reporting-app.log.1`, `reporting-app.log.2` and `reporting-app.log.3`.
5. Confirm with `df -h` that usage on that filesystem has dropped substantially.

The grader checks that the filesystem is at most 50% full, that `lsof +L1` no longer lists any deleted `reporting-app` file as open, and that all three legitimate log files are still there.
