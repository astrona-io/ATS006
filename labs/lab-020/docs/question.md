# Question

Solve this question on: `terminal`

Your team is standing up a new shared workspace at `/srv/teamspace` for the `ops` group, and it needs its default file behavior, its shared directories, and a legacy incoming folder all brought under control in one pass.

## Part 1: Default permissions for `opsuser`

New files `opsuser` creates anywhere should default to `640` and new directories should default to `750` — persistently, for every future login. Do not use `chmod` to achieve this; it must come from the account's default permission mask.

## Part 2: Shared workspace permissions

1. `/srv/teamspace/shared` should be readable, writable, and enterable by the owning group `ops` and its owner, but not accessible at all to anyone else — and any new file created inside it by any team member must automatically belong to group `ops`, not that user's own primary group.
2. `/srv/teamspace/bin/deploy.sh` should be executable by its owner only, and by no one else at all, including the group.
3. `/srv/teamspace/dropbox` is a shared drop location where any team member can create files, but a team member should only be able to delete their *own* files from it, never someone else's, even though everyone has write access to the directory itself.

## Part 3: Triage the legacy incoming folder

There is a legacy folder at `/srv/teamspace/incoming` that needs cleaning up, in this exact order:

1. Delete all files modified before `06/01/2021`.
2. For the remaining files: find all files smaller than `2KiB` and move them to `/srv/teamspace/incoming/archive/small/`.
3. Find all files larger than `8KiB` and move them to `/srv/teamspace/incoming/archive/large/`.
4. Find all files with permission `777` and move them to `/srv/teamspace/incoming/quarantine/`.

Perform these steps in the order given — later steps should only ever act on whatever is still left in the top level of `/srv/teamspace/incoming` after the previous steps ran.
