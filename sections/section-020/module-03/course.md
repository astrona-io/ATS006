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

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The folder `/srv/triage` with a `logs` folder, a `uploads` folder and a `tmp` folder.
- Files with ages from today back to 90 days, sizes from empty to 5 MiB, and a few files that anyone can write (`0666`).
- A file `/srv/triage/uploads/old-report.csv`, set 60 days old.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh find-triage-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

Read the parts in order. The mission comes right after the part that teaches its skills.

1. [Matching Files By Age, Size And Permission](./course-01-matching-files-by-age-size-and-permission.md): the three kinds of test and how to act on a match.
2. [Triage In The Right Order](./course-02-triage-in-the-right-order.md): several passes, `-maxdepth 1`, and why the order changes the result.
   - Mission: [find Triage by Criteria Lab](../../../labs/lab-023/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

Cleaning up a full backup folder, finding wide-open files after an incident, archiving old logs: these are everyday administration jobs, and the exam asks for them by name. A single wrong prefix (`-3k` instead of `+3k`) or a pass run in the wrong order leaves the machine in a state that looks close but is wrong.
