# Question

Solve this question on: `terminal` (playing the role of `app-srv1` from the scenario)

Astronaut, the `analysts` team is moving into a shared compartment on this ship, and its locks are wrong. The group `analysts` and a team member, `someanalyst`, already exist. Fix the permissions on three places:

1. `/srv/shared/reports` must be readable, writable and enterable by its owner and its group `analysts`, and not accessible at all to anyone else. Any new file a team member creates inside it must automatically belong to group `analysts`, not to that user's own primary group. The directory must keep `analysts` as its group.
2. The script `/opt/tools/backup-runner.sh` must be readable, writable and executable by its owner only, and by no one else at all, including the group.
3. `/srv/shared/dropbox` is a shared drop folder. Everyone must be able to read, write and enter it, but a person may delete only their *own* files from it, never someone else's.

The grader checks the exact mode of all three paths, and checks that a new file created in `/srv/shared/reports` by `someanalyst` gets the group `analysts`.
