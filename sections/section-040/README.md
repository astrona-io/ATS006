# Section 040: Version Control with Git

Astronaut, every ship keeps a flight log, and today the flight log for a server's configuration is very often a Git repository. Configuration files, scripts, scheduled jobs and firewall rules live in Git long before they reach a production machine. The exam expects you to be trusted with that history: to read it, add to it and share it without damaging anyone else's work.

This section does not teach Git as a full developer workflow. It builds exactly the base an administrator needs: creating and inspecting a repository from nothing, cloning a shared repository and reading its branches without disturbing your own work, merging the right change into `main`, and bringing your own unfinished work back in line with an upstream that moved on while you were busy.

**Exam topic covered:** Basic Git operations

---

## What You Will Master

- The three states of a change (working tree, staging area, history) and how `git status` shows them.
- The difference between `git diff` and `git diff --staged`, and when to use each one.
- A `.gitignore` that keeps build output out, and why it never untracks a file that is already committed.
- What a remote really is (a name for a location), a bare repository, and `git push -u` with upstream tracking.
- `git fetch` versus `git pull`, and why `fetch` is always safe.
- Reading a file on any branch with `git show <ref>:<path>`, without checking it out.
- Merging exactly one chosen branch into the branch you have checked out.
- Why Git ignores an empty directory, and the `.keep` placeholder that fixes it.
- Topic branches with `git switch -c`, focused commits, and the two-dot range (`main..topic`).
- Rebasing a topic branch onto a new upstream tip, handling a conflict, and knowing when to merge instead.

---

## Modules In This Section

Work through the modules in this order. Each part teaches one idea. A mission (a graded lab) comes right after the part it practises, and the last page of each module is a wrap-up. The capstone at the end uses everything in the section at once.

### [Git Fundamentals: Init, Status, Diff, Log, and Remotes](module-01/course.md)

3 parts and 1 mission:

1. [The Three States Of A File](module-01/course-01-the-three-states-of-a-file.md)
2. [Diff, Ignore And Log](module-01/course-02-diff-ignore-and-log.md)
3. [Remotes, Push And Fetch](module-01/course-03-remotes-push-and-fetch.md)
   - Mission: [Git Fundamentals Lab](../../labs/lab-041/docs/question.md)
4. [Wrap-Up: Mission Debrief](module-01/course-04-wrap-up.md)

### [Git Branches: Clone, Inspect, Merge, Commit](module-02/course.md)

2 parts and 1 mission:

1. [Clone And Inspect Branches](module-02/course-01-clone-and-inspect-branches.md)
2. [Merge And Commit A New Directory](module-02/course-02-merge-and-commit-a-new-directory.md)
   - Mission: [Git Branch Inspection & Merge Lab](../../labs/lab-042/docs/question.md)
3. [Wrap-Up: Mission Debrief](module-02/course-03-wrap-up.md)

### [Cloning an Upstream Repository, Working on a Topic Branch, and Reconciling Changes](module-03/course.md)

2 parts and 1 mission:

1. [A Topic Branch And A Focused Commit](module-03/course-01-a-topic-branch-and-a-focused-commit.md)
2. [Fetch, Rebase Or Merge](module-03/course-02-fetch-rebase-or-merge.md)
   - Mission: [Git Upstream Reconciliation Lab](../../labs/lab-043/docs/question.md)
3. [Wrap-Up: Mission Debrief](module-03/course-03-wrap-up.md)

### Knowledge check

Before the capstone, test your reasoning with the **[Section 040 Knowledge Check](./quiz.md)**.

### Capstone

Your final mission for this section: **[Git Operations Capstone Lab](../../labs/lab-040/docs/question.md)**. You clone a shared deployment repository, merge the one branch with the right feature flag, commit a new directory, push, and then rebase a topic branch onto a teammate's newer commit so the final history is one straight line.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-040
astrona ssh ats-006-lab-040
astrona submit -c labs/lab-040
astrona destroy ats-006-lab-040
```
