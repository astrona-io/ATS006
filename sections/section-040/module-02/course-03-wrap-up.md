# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Before you move on, look back at what you learned, check yourself, and clean up anything still running.

## What you learned

This module was about choosing one flight path out of several and joining it to the main course, without losing track of where you are.

**From [Clone And Inspect Branches](./course-01-clone-and-inspect-branches.md):**

- A branch is a pointer to a commit, not a copy of the files. That is why branches are cheap.
- A clone brings every branch. The ones you have not checked out appear as `remotes/origin/<name>` in `git branch -a`.
- `git show <ref>:<path>` prints a file from any branch without a checkout. A short `bash` loop compares many branches at once.

**From [Merge And Commit A New Directory](./course-02-merge-and-commit-a-new-directory.md):**

- `git merge` brings the named branch into the branch you have checked out. Check it with `git branch --show-current` first.
- Merge only the one branch that matches the requirement.
- Git stores blobs and trees only, so an empty directory is invisible. A `.keep` placeholder makes it trackable.
- `git commit -m "exact message"` avoids the editor and gives the exact wording a grader checks.

## Your missions

You proved these skills in a graded mission, right after the part that taught the last of them:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Git Branch Inspection & Merge Lab](../../../labs/lab-042/docs/question.md) | Merge And Commit A New Directory | found the one branch with `user_registration_level: open`, merged only it, and committed `logs/.keep` |

If you skipped it, go back to it now. It is short, and the exam asks for exactly these skills.

## Practise on your own

To prove you can work with branches and merges without losing track of your working tree:

1. Clone a repository that has at least three sibling branches off the same base commit.
2. List all branches with `git branch -a` and find which ones exist only as remote-tracking references.
3. Use `git show <branch>:<path>` (not `git checkout`) to read one file on each of the three branches, and find the one that matches a target value.
4. Confirm your current branch with `git branch --show-current`, switch to the correct target branch if needed, then merge only the one matching branch into it.
5. Create a new empty directory, confirm `git add` on it stages nothing, then add a `.keep` placeholder file inside it and confirm the directory becomes trackable.
6. Commit the change with `-m` and confirm with `git log --oneline -3` that exactly one new commit sits on top of the merge.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. Why is creating a branch so cheap in Git?</summary>

A branch is only a pointer to a commit. Creating one writes a few bytes of bookkeeping; no files are copied.
</details>

<details>
<summary>2. Right after a clone, <code>git branch</code> shows only <code>main</code>. Are the other branches missing?</summary>

No. They are there as remote-tracking branches. `git branch -a` lists them as `remotes/origin/<name>`.
</details>

<details>
<summary>3. How do you read <code>config.yaml</code> on the branch <code>dev5</code> without checking it out?</summary>

`git show origin/dev5:config.yaml`. It prints the file at the tip of that branch and leaves your working tree alone.
</details>

<details>
<summary>4. You are on <code>dev4</code> and run <code>git merge origin/dev5</code>. Where does the merge land?</summary>

On `dev4`, the branch you have checked out. Switch to `main` first if the merge belongs there.
</details>

<details>
<summary>5. You run <code>mkdir logs</code> and <code>git add logs</code>. Why is nothing staged?</summary>

Git stores only file content (blobs) and directory listings that point at content (trees). An empty directory has nothing to store. Add a file such as `logs/.keep`.
</details>

<details>
<summary>6. Does Git treat the name <code>.keep</code> specially?</summary>

No. `.keep` and `.gitkeep` are only conventions. Any file name makes the directory trackable.
</details>

<details>
<summary>7. Why use <code>git commit -m</code> in a timed task?</summary>

It skips the text editor and gives you the exact message you typed, which graders compare word for word.
</details>

## Clean up

The lab is a whole virtual machine running on your computer. When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the mission. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-042
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *Read every flight path from the chart, join only the right one, and remember that Git carries crates, not empty compartments.*
