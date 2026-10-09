# Question

Solve this question on: `terminal`

Astronaut, your team is opening a new shared compartment at `/srv/teamspace` for the `ops` group. Its default locks, its shared folders and a messy legacy incoming folder must all be brought under control in one mission. The group `ops` and its member `opsuser` already exist.

## Part 1: Default permissions for `opsuser`

New files that `opsuser` creates anywhere must default to `640`, and new directories to `750`, for every future login. Do not use `chmod` for this: it must come from the user's default permission mask, the `umask`.

## Part 2: Shared workspace permissions

1. `/srv/teamspace/shared` must be readable, writable and enterable by its owner and its group `ops`, and not accessible at all to anyone else. Any new file a team member creates inside it must automatically belong to group `ops`, not to that user's own primary group. The directory must keep `ops` as its group.
2. `/srv/teamspace/bin/deploy.sh` must be readable, writable and executable by its owner only, and by no one else at all, including the group.
3. `/srv/teamspace/dropbox` is a shared drop folder. Everyone must be able to read, write and enter it, but a person may delete only their *own* files from it, never someone else's.

## Part 3: Triage the legacy incoming folder

Clean up `/srv/teamspace/incoming` with these steps, in this exact order:

1. Delete all files modified before `06/01/2021` (1 June 2021).
2. From the remaining files, move all files smaller than `2KiB` to `/srv/teamspace/incoming/archive/small/`.
3. Move all files larger than `8KiB` to `/srv/teamspace/incoming/archive/large/`.
4. Move all files with permission `777` to `/srv/teamspace/incoming/quarantine/`.

Each later step must only act on the files still left in the top level of `/srv/teamspace/incoming` after the earlier steps ran. A file that fits more than one rule goes where the earliest matching step puts it.

The grader starts a fresh login for `opsuser` and checks the modes of a new file and directory, checks the exact modes of the three workspace paths, creates a file in `/srv/teamspace/shared` as `opsuser` and checks its group, and checks where every file in `/srv/teamspace/incoming` ended up.
