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

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The repository `/repositories/crew-manifest` on `main`, with three extra branches: `feature-alpha`, `feature-bravo` and `feature-charlie`. Each branch adds one file.
- Git installed and a throwaway identity set.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh git-branches-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

1. [Clone And Inspect Branches](./course-01-clone-and-inspect-branches.md)
2. [Merge And Commit A New Directory](./course-02-merge-and-commit-a-new-directory.md)
   - Mission: [Git Branch Inspection & Merge Lab](../../../labs/lab-042/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

On a real team, several people propose changes to the same configuration on different branches. Your job is often to find the one branch that holds the right value and bring only that one into `main`, without disturbing your own work. Doing that quickly and safely, from the command line, is exactly what the exam checks.

<!-- curriculum-practice -->
## Practice and assessment

- [Git Branch Inspection & Merge Lab](../../../labs/lab-042/docs/question.md): Read a file on several branches without checking them out; Merge only the matching branch into main; Commit an otherwise empty directory with a placeholder file.
- [Git Operations Capstone Lab](../../../labs/lab-040/docs/question.md): Find and merge the one branch with the right setting without checking the candidates out; Push with upstream tracking and rebase a topic branch onto an upstream that moved; Keep main's history linear with fast-forward merges.
