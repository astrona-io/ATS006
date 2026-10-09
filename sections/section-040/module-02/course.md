# Git Branches: Clone, Inspect, Merge, Commit

Astronaut, a ship can plan several alternative flight paths before it picks one. A Git **branch** is such an alternative flight path. It is not a separate copy of your project; it is a marker pointing at one entry in the flight log archive. `main` is just one marker among many, all pointing at commits in the same shared archive.

Once you see a branch as "just a pointer", a whole group of Git tasks stops feeling mysterious: reading a branch you have not checked out, merging one branch's history into another, and knowing exactly what a merge does to the branch you are on. This module covers those tasks, plus one quirk every administrator meets: Git will not track an empty directory.

## Learning objectives

After this module you can:

- Explain why creating a branch is cheap, and what a branch actually is.
- Clone a repository and list both local and remote-tracking branches with `git branch -a`.
- Read a file on any branch with `git show <ref>:<path>`, without checking the branch out.
- Merge exactly one chosen branch into `main`, after confirming which branch you are on.
- Explain why Git does not track an empty directory, and commit one with a `.keep` placeholder.
- Commit with a clear message using `-m`.

## Before you start

Check that you have the knowledge and the tools this module expects before you begin.

### What you should already know

- **The three states of a file.** A change moves from the working tree to the staging area with `git add`, and into the history with `git commit`.
- **What a remote is.** A remote, usually called `origin`, is a name for another copy of the repository. `git status` and `git log --oneline` show where you are.

### What you need

- A terminal on an Ubuntu 24.04 machine with `bash` and `git` installed, or a running lab machine opened with `astrona ssh <lab name>`.

## How this module is laid out

1. [Clone And Inspect Branches](./course-01-clone-and-inspect-branches.md)
2. [Merge And Commit A New Directory](./course-02-merge-and-commit-a-new-directory.md)
   - Mission: [Git Branch Inspection & Merge Lab](../../../labs/lab-042/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

On a real team, several people propose changes to the same configuration on different branches. Your job is often to find the one branch that holds the right value and bring only that one into `main`, without disturbing your own work. Doing that quickly and safely, from the command line, is exactly what the exam checks.
