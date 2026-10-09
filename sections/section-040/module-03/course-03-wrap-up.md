# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Before you move on, look back at what you learned, check yourself, and clean up anything still running.

## What you learned

This module was about the full cycle of a shared change: branch off, make one focused change, notice that upstream moved, and bring your work back in cleanly.

**From [A Topic Branch And A Focused Commit](./course-01-a-topic-branch-and-a-focused-commit.md):**

- A clone checks out the default branch and sets it to track `origin/main`. `git branch -vv` shows the link.
- `git switch -c <name>` creates a branch and moves you onto it. `git branch <name>` only creates it.
- A topic branch should carry one focused change. Check it with `git diff` before you stage it.
- `git log main..topic` and `git diff main..topic` show exactly what the topic branch adds.

**From [Fetch, Rebase Or Merge](./course-02-fetch-rebase-or-merge.md):**

- `git fetch` only moves the remote-tracking reference. It never touches your working tree or current branch.
- `git rebase origin/main` replays your commits on top of the new upstream tip, giving a straight history.
- On a conflict, fix the file, `git add` it and run `git rebase --continue`, or `git rebase --abort` to undo.
- Never rebase a branch others already use. A merge keeps the true history without rewriting commits.

## Your missions

You proved these skills in a graded mission, right after the part that taught the last of them:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Git Upstream Reconciliation Lab](../../../labs/lab-043/docs/question.md) | Fetch, Rebase Or Merge | made one focused commit on `fix-timeout-value` and rebased it onto a teammate's upstream commit |

If you skipped it, go back to it now. It is short, and the exam asks for exactly these skills.

## Practise on your own

To prove you can carry a topic branch through a full reconciliation cycle:

1. Clone a repository and confirm with `git branch -vv` that your default branch already tracks `origin`'s default branch with no extra setup.
2. Create a topic branch with `git switch -c`, make one focused, single-purpose commit, and confirm with `git diff` beforehand that only the intended change is present.
3. Use the two-dot range form of `git log` and `git diff` to show exactly what your topic branch added compared with the branch it came from.
4. Simulate someone else pushing directly to the shared branch (from a second clone, or by committing directly to the upstream), then run `git fetch` and confirm your working branch is untouched until you act on it.
5. Rebase your topic branch onto the new upstream tip and confirm with `git log --oneline --graph --all` that the result is one straight line, not a merge bubble.
6. Explain out loud, in one or two sentences, the one condition under which you would choose `merge` over `rebase` for this same reconciliation.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. Right after a clone, <code>git status</code> says "up to date with 'origin/main'". Who set up that link?</summary>

`git clone` did. It checks out the default branch and sets it to track `origin/main` automatically. `git branch -vv` shows it.
</details>

<details>
<summary>2. You ran <code>git branch fix-dns</code> and then edited files. Which branch did the edits land on?</summary>

The branch you were already on. `git branch` only creates a branch; it does not switch to it. Use `git switch -c fix-dns`.
</details>

<details>
<summary>3. What does <code>git log main..fix-dns --oneline</code> show?</summary>

The commits reachable from `fix-dns` but not from `main`: exactly what the topic branch adds.
</details>

<details>
<summary>4. Does <code>git fetch origin</code> change your current branch?</summary>

No. It only downloads new objects and moves `origin/main`. Your branch changes when you merge, rebase or pull.
</details>

<details>
<summary>5. What does <code>git rebase origin/main</code> do when run on a topic branch?</summary>

It lifts the branch's commits off, moves the branch's start to the new `origin/main` tip and replays each commit on top, giving a straight history with no merge commit.
</details>

<details>
<summary>6. A rebase stops with conflict markers in a file. What are your two ways out?</summary>

Fix the file, `git add` it and run `git rebase --continue`, or run `git rebase --abort` to return to the state before the rebase.
</details>

<details>
<summary>7. When should you merge instead of rebase?</summary>

When the branch is already pushed and someone else may have built on it. Rebase rewrites commit hashes; a merge keeps every existing commit as it is.
</details>

## Clean up

The lab is a whole virtual machine running on your computer. When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the mission. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-043
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *Fetch to look, rebase to replay your own path, and merge when the path is already shared.*
