# Find, Filter, And Triage Files By Age, Size, And Permission

Astronaut, any cargo compartment that collects crates for months without anyone sorting it turns into a junk drawer. Old crates nobody needs. Tiny crates that hint at a broken write. Huge crates eating the deck's space. Crates with locks far looser than anyone meant. Sorting that by eye does not work past a handful of files.

`find` is your cargo search drone: it walks every compartment and reports the crates that fit your description. It can sort thousands of files in seconds, as long as you know exactly how its tests work, and in which order to run several passes.

## Learning objectives

After this module you can:

- Match files by a relative age with `-mtime`, and by an absolute date with `-newermt` and `!`.
- Preview a match with `-print` before you add `-delete` or `-exec`.
- Match files by size with `-size`, and tell a bare number, a `-` prefix and a `+` prefix apart.
- Match files by permission with `-perm`, and tell an exact match, an "all of these bits" match and an "any of these bits" match apart.
- Move matched files with `-exec ... \;` and know when the batching `+` form works.
- Run a triage of several passes in the order a task gives, using `-maxdepth 1` so later passes never touch files an earlier pass already moved.

## Before you start

Check these few things before your first mission.

### What you should already know

- **Permission modes.** `777` means read, write and execute for everyone. `644` means read and write for the owner, read only for everyone else.
- **Paths.** `.` is the current directory, and `cd` changes it.
- **`sudo` and `root`.** `root` is the captain of the ship, and `sudo` borrows the captain's authority for one command. Folders owned by `root` need `sudo` to change.

### What you need

A terminal on an Ubuntu 24.04 machine with `bash` and GNU `find` (Ubuntu has it by default). A running lab machine works too: start a lab and open a terminal on it with `astrona ssh <lab name>`. The examples build their own test folders under `/tmp`.

## How this module is laid out

Read the parts in order. The mission comes right after the part that teaches its skills.

1. [Matching Files By Age, Size And Permission](./course-01-matching-files-by-age-size-and-permission.md): the three kinds of test and how to act on a match.
2. [Triage In The Right Order](./course-02-triage-in-the-right-order.md): several passes, `-maxdepth 1`, and why the order changes the result.
   - Mission: [find Triage by Criteria Lab](../../../labs/lab-023/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

Cleaning up a full backup folder, finding wide-open files after an incident, archiving old logs: these are everyday administration jobs, and the exam asks for them by name. A single wrong prefix (`-3k` instead of `+3k`) or a pass run in the wrong order leaves the machine in a state that looks close but is wrong.
