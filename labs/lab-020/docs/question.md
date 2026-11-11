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

## Part 4: Stage a release

The release files wait in `/srv/teamspace/release-src`. Everything here belongs to `root`, so use `sudo` where you must.

1. Create the directory tree `/srv/teamspace/releases/2026/q1` with one command. The parent folders do not exist yet.
2. Copy `/srv/teamspace/release-src/app.conf` into `/srv/teamspace/releases/2026/q1/`. The copy must keep the **mode** and the **modification time** of the original. Leave the original where it is.
3. **Move** `/srv/teamspace/release-src/old-release.txt` into `/srv/teamspace/releases/2026/`. It must no longer exist in the old place.
4. Create a **hard link** `/srv/teamspace/releases/app-hard.conf` to the copy `/srv/teamspace/releases/2026/q1/app.conf`, and a **symbolic link** `/srv/teamspace/releases/current` that points at the directory `2026/q1` with a relative target.
5. **Remove** the folder `/srv/teamspace/release-src/tmp-build` with everything inside it.
6. Give the group `ops` ownership of `/srv/teamspace/releases` and everything inside it. The owner stays `root`.

The grader starts a fresh login for `opsuser` and checks the modes of a new file and directory, checks the exact modes of the three workspace paths, creates a file in `/srv/teamspace/shared` as `opsuser` and checks its group, checks where every file in `/srv/teamspace/incoming` ended up, and checks the release tree, the preserved mode and time, the hard link's inode, the symbolic link's target and the group of every file and folder under `/srv/teamspace/releases`.
<!-- curriculum-links -->

## Related lessons and assessment

Read [module-01](../../../sections/section-020/module-01/course.md), [module-02](../../../sections/section-020/module-02/course.md), [module-03](../../../sections/section-020/module-03/course.md), [module-04](../../../sections/section-020/module-04/course.md).

The grader checks:

- Confirms a fresh login shell for opsuser produces 640 files and 750 directories with no chmod involved.
- Confirms /srv/teamspace/shared is mode 2770 owned by group ops, and that new files inside it inherit the ops group.
- Confirms /srv/teamspace/bin/deploy.sh is mode 700.
- Confirms /srv/teamspace/dropbox is mode 1777.
- Confirms files older than the cutoff were deleted from /srv/teamspace/incoming, and remaining files were correctly split into archive/small and archive/large.
- Confirms permission-777 files were moved to quarantine/ and the untouched mid-range files remain at the top level.
- Confirms the release tree exists, app.conf was copied with its mode and time kept, old-release.txt was moved and tmp-build was removed.
- Confirms the hard link shares the copy's inode, the symbolic link has the relative target 2026/q1 and everything under releases has group ops.

Use the inspection commands in the solution to check your work. Submit when you have finished; submission ends this environment.
