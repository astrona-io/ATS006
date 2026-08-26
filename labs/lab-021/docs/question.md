# Question

Solve this question on: `terminal` (playing the role of `app-srv1` from the scenario)

Set up a shared team directory and a couple of specific-purpose files:

1. `/srv/shared/reports` should be readable, writable, and enterable by the owning group `analysts` and the owner, but not accessible at all to anyone else — and any new file created inside it by any team member should automatically belong to group `analysts`, not that user's own primary group.
2. The script `/opt/tools/backup-runner.sh` should be executable by its owner only, and by no one else at all, including the group.
3. `/srv/shared/dropbox` is a shared drop location where any team member can create files, but a team member should only be able to delete their *own* files from it, never someone else's, even though everyone has write access to the directory itself.
