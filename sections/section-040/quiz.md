# Section 040 Knowledge Check: Version Control with Git

Test your understanding of the local three-state model, cross-branch inspection, empty-directory tracking quirks, and upstream reconciliation with fetch, merge, and rebase.

---

## Scenario-Based Questions

### Question 1
You edit a tracked file and immediately run `git add` on it. You then run `git diff` and see no output at all, but `git diff --staged` shows your exact change. What does this combination of results tell you?
*   **A)** The change was lost when you ran `git add`, and `git diff --staged` is showing a cached copy of the old diff.
*   **B)** The working tree and the index are now identical (nothing left unstaged), while the index still differs from the last commit — exactly what `--staged` compares.
*   **C)** `git diff` is broken and only `git diff --staged` can be trusted after running `git add`.
*   **D)** The file was committed automatically the moment it was staged.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** Bare `git diff` compares the working tree against the index (staging area). Once you `git add` a change, the working tree and index become identical, so plain `git diff` correctly shows nothing — there is no longer any *unstaged* difference. `git diff --staged` (a synonym for `--cached`) compares the index against `HEAD`, the last commit, which is exactly where your staged-but-not-yet-committed change is visible.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because nothing is lost — `git add` moves a change into the index, it doesn't discard it. The empty `git diff` output is expected, correct behavior.
    *   *Option C* is incorrect because both commands work correctly; they simply compare different pairs of states, and reading their outputs together is the intended workflow.
    *   *Option D* is incorrect because staging and committing are separate actions — a file remains staged, not committed, until an explicit `git commit` is run.
</details>

---

### Question 2
Your team adds `*.log` to `.gitignore` to stop log files from being committed going forward. However, `git status` continues to report `app.log` as modified every time it changes, as if the ignore rule doesn't exist. What is the most likely cause?
*   **A)** `.gitignore` patterns only take effect after the next `git commit`.
*   **B)** `app.log` was already tracked (committed at least once) before the `.gitignore` rule was added, so Git continues tracking and reporting on it regardless of the pattern.
*   **C)** The `*.log` pattern is invalid syntax and needs to be written as `**/*.log` instead.
*   **D)** `git status` ignores `.gitignore` entirely; only `git add` respects it.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** A `.gitignore` pattern only prevents Git from proposing *untracked* files as staging candidates. A file that is already tracked keeps being tracked and reported on regardless of any pattern that would otherwise match it — the rule does not retroactively reach back and untrack history. The fix is `git rm --cached app.log` (removing it from the index without deleting it from disk) followed by a commit of that removal; the ignore rule then applies going forward.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because ignore rules take effect immediately for untracked files — no commit is required for the rule itself to start working.
    *   *Option C* is incorrect because `*.log` is valid `.gitignore` syntax for matching files by extension anywhere a plain pattern is evaluated at that directory level; the syntax isn't the problem here.
    *   *Option D* is incorrect because `git status` does respect `.gitignore` for untracked files — the issue is specifically that `app.log` is no longer untracked.
</details>

---

### Question 3
You've just cloned a repository with four candidate branches (`opt-a`, `opt-b`, `opt-c`, `opt-d`), and you need to find which one sets `mode: strict` inside `policy.yaml`, without disturbing your current working tree or checked-out branch. What is the fastest, safest way to check?
*   **A)** Run `git checkout opt-a`, inspect the file, then repeat for each remaining branch, checking out `main` again afterward.
*   **B)** Run `git stash`, then check out each branch, then `git stash pop` at the end to restore your working tree.
*   **C)** Run `git show origin/opt-a:policy.yaml` (and the same for the other three branches) to read each branch's file content directly, with no checkout at all.
*   **D)** Run `git diff opt-a opt-b opt-c opt-d` and read the combined output.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: C**

*   **Why C is correct:** `git show <ref>:<path>` prints a file's exact content as it exists at the tip of that ref, entirely independent of what's currently checked out — no checkout, no stash, and no risk of leaving your working tree on the wrong branch afterward. This is the standard technique for "which branch has X" questions.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because it works, but it's slow, repeatedly disturbs your working tree, and risks forgetting to switch back to the original branch when finished.
    *   *Option B* is incorrect because stashing and checking out repeatedly is unnecessary overhead for a task that only requires reading file content, not modifying anything.
    *   *Option D* is incorrect because `git diff` with more than two branch names doesn't produce a clean per-branch content report the way `git show ref:path` does; it's the wrong tool for this specific question.
</details>

---

### Question 4
You run `mkdir cache` inside a Git repository, followed by `git add cache`, and `git status` shows nothing staged at all. What explains this?
*   **A)** Git only tracks directories that already contain at least 2 files.
*   **B)** `git add` requires the `-f` flag to force-add empty directories.
*   **C)** Git's object model only stores blobs (file content) and trees built from them — an empty directory has no content to hash, so there is nothing for Git to record until a file exists inside it.
*   **D)** The directory name `cache` is a reserved word in Git and cannot be tracked.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: C**

*   **Why C is correct:** Git only ever stores blobs (file content) and trees (directory listings pointing at blobs and other trees), and a tree entry only exists because something inside it needed to be recorded. An empty directory has nothing to turn into a blob, so it's invisible to Git until it contains at least one tracked file — commonly solved with a placeholder file conventionally named `.keep` or `.gitkeep`.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because there's no file-count threshold; a single tracked file of any kind makes the directory visible to Git.
    *   *Option B* is incorrect because no `-f` flag exists for this purpose; `-f` on `git add` overrides ignore rules, not the empty-directory limitation.
    *   *Option D* is incorrect because Git has no reserved directory names; any name works identically once it contains tracked content.
</details>

---

### Question 5
You created a topic branch, made two commits, and pushed it to `origin` so a teammate could review it — and they've since pulled it down into their own clone. Before merging, you consider running `git rebase main` on your topic branch to keep the history perfectly linear. What is the main risk of doing this now?
*   **A)** There is no risk; rebase is always safe regardless of whether a branch has been shared.
*   **B)** Rebase will permanently delete your two commits with no way to recover them.
*   **C)** Rebase rewrites your commits into new objects with new hashes; since your teammate's clone already has the old commit hashes, their history will diverge from yours in a way that's painful to reconcile.
*   **D)** Rebase will silently merge `main` into your topic branch instead of replaying your commits on top of it.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: C**

*   **Why C is correct:** Rebase replays each commit as a brand-new object — same content, new hash — even though nothing about the change itself is different. A branch that's already been pushed and pulled by someone else means that person's clone still references the old commit hashes; rebasing rewrites your side, creating two histories that no longer share commit identities and are genuinely painful to reconcile. This is exactly why the rule is to rebase freely on branches nobody else has touched yet, and merge once a branch is shared.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because safety depends entirely on whether the branch has been shared; an unshared local topic branch is safe to rebase, a shared one is not.
    *   *Option B* is incorrect because the original commits aren't deleted outright — they become unreferenced by the branch tip and are eventually garbage-collected, but the real-world danger is history divergence with collaborators, not data loss on your own machine.
    *   *Option D* is incorrect because that describes what `git merge main` would do, not `git rebase main` — rebase replays your commits on top of the target, it doesn't create a merge commit combining both tips.
</details>
