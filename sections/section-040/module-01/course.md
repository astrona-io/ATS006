# Git Fundamentals: Init, Status, Diff, Log, and Remotes

Imagine a scientist keeping a lab notebook. Every observation gets written down, dated, and never erased — if an earlier measurement turns out to be wrong, the scientist doesn't tear the page out, they add a new entry correcting it, with the old entry still sitting there for context. That notebook is a permanent, append-only record of how understanding evolved over time.

Git is that notebook for a directory of files. It doesn't just store your current files — it stores every meaningful version of them you ever asked it to remember, in order, forever (or until you decide otherwise). Before you can appreciate branches, merges, or remotes, you need to be completely comfortable with the notebook's basic mechanics: how an entry gets written, how you check what's about to be written before you commit to it, and how you eventually share your notebook with someone else.

## The Three-State Model

Every file Git manages moves through three distinct states, and almost every piece of confusion beginners have with Git traces back to losing track of which state a file is currently in.

1. **Working tree** — the files as they physically sit on disk right now, exactly as you last saved them in your editor.
2. **Staging area (the index)** — a holding pen where you place exactly the changes you intend to include in your *next* commit, no more and no less.
3. **History (commits)** — the permanent, timestamped notebook entries. Once a change is committed, it's part of the project's recorded story.

A brand-new repository starts with none of this. Running `git init` inside a directory creates a hidden `.git/` subdirectory — an empty object database, a set of refs, and a config file — and nothing else. No commits exist yet, no network call was made, and no files were touched. You could run `git init` on an airplane with no internet connection and it would work identically.

```bash
mkdir -p ~/projects/recipe-notes
cd ~/projects/recipe-notes
git init
```

At this point `git log` would refuse to run, complaining that the repository "does not have any commits yet." That's expected — the notebook exists, but no page has been written in it.

## Reading `git status`

`git status` is the single command that tells you, at any moment, exactly which of the three states every file is currently sitting in. If you create two new files:

```bash
echo "# Recipe Notes" > README.md
printf "2 eggs\n1 cup flour\n" > pancakes.txt
git status
```

Git reports both files under **"Untracked files"** — it has noticed them on disk, but they exist entirely outside the staging area and history. Nothing is lost if you delete them; Git simply hasn't been asked to remember them yet.

Once you stage them:

```bash
git add README.md pancakes.txt
git status
```

The same two files now appear under **"Changes to be committed"** — they've moved into the staging area. This is the moment to pause and actually read that list. It is extremely common to accidentally `git add .` and stage a file you didn't mean to include; `git status` right before a commit is the cheap insurance policy that catches it.

```bash
git commit -m "initial commit"
```

The staged snapshot becomes a permanent entry in history. `git status` immediately afterward reports "nothing to commit, working tree clean" — all three states now agree.

## `git diff` vs. `git diff --staged`

This is the single most useful distinction in this module, and the one worth memorizing cold.

Suppose you edit `pancakes.txt` to add a third ingredient:

```bash
echo "1 tsp baking powder" >> pancakes.txt
git diff
```

With **no arguments**, `git diff` compares the **working tree against the staging area (index)**. Since the index still matches the last commit and you haven't staged anything yet, this shows exactly the one line you just added — it answers the question *"what have I changed that isn't staged yet?"*

Now stage it and run `git diff` again:

```bash
git add pancakes.txt
git diff
```

This time it prints **nothing at all**. The working tree and the index are now identical, so there's no difference to show. This surprises almost everyone the first time — the change didn't disappear, the comparison target simply moved. To see the staged change, you need the other command:

```bash
git diff --staged
```

`--staged` (an exact synonym for `--cached`) compares the **index against the last commit (`HEAD`)**. This answers *"what will actually be committed if I run `git commit` right now?"* — a different, and arguably more important, question than plain `git diff`.

The habit worth building: run `git diff` before staging to review what you're about to add, and `git diff --staged` right before committing to review exactly what's about to become permanent. Checking both matters because it's entirely possible to stage part of a multi-file edit, forget you did, and then commit something different from what you most recently typed.

```bash
git commit -m "add baking powder to pancake recipe"
```

## Keeping Noise Out with `.gitignore`

Most real projects generate files you never want committed — compiled binaries, log output, editor swap files, dependency caches. A `.gitignore` file tells Git to stop proposing matching paths as untracked candidates.

```bash
echo "*.tmp" > .gitignore
git add .gitignore
git commit -m "ignore temporary files"
```

The trailing behavior to understand: a `.gitignore` pattern only prevents Git from noticing files it **isn't already tracking**. If a `.tmp` file had been committed *before* this rule existed, Git keeps tracking it and reporting on it regardless of any pattern that would otherwise match it — the rule doesn't retroactively reach back into history. Untracking an already-committed file requires an explicit `git rm --cached <path>`, followed by a commit of that removal, before the ignore rule takes effect going forward.

It's worth testing a `.gitignore` rule against a directory that doesn't exist yet:

```bash
mkdir scratch
echo "leftover data" > scratch/output.tmp
git status
```

If the rule is written correctly, `git status` reports nothing new at all — proof the pattern works before a real build process or script ever generates the matching files for real.

## Reading History with `git log`

Once a few commits exist, `git log` shows them, newest first:

```bash
git log --oneline
```

Each line is a short commit hash followed by its message — the fast, scannable form you'll reach for constantly. The full `git log` (no flags) shows the complete author, date, and message for each commit, useful when you need more detail than a one-liner provides.

## What a Remote Actually Is

This is the concept beginners most often over-mystify. A Git **remote** is not a server, not a protocol, and not a magic cloud service — it is nothing more than a **name mapped to a URL** (or, just as validly, a local filesystem path), recorded in `.git/config`.

```bash
git init --bare ~/projects/recipe-notes-backup.git
```

The `--bare` flag creates a repository with no working tree at all — just the object database and refs, exactly what lives inside the `.git/` folder of a normal repository, except it *is* the top-level directory itself. This is precisely what GitHub, GitLab, and every other Git host run on their servers. A bare repository sitting in a second local directory works exactly as well for learning purposes as a real network host — the mechanics are identical either way.

```bash
cd ~/projects/recipe-notes
git remote add backup ~/projects/recipe-notes-backup.git
git remote -v
```

`git remote add` writes that name-to-location mapping into your config. `-v` (verbose) prints both the fetch and push locations for every configured remote, which are usually identical unless deliberately set otherwise.

```bash
git push -u backup main
```

`-u` (`--set-upstream`) does two things in a single command: it pushes your `main` branch's history to `backup`, and it records, locally, that your `main` branch should track `backup`'s `main` branch by default from now on. That association is why every subsequent `git push` or `git pull` on this branch can be run with zero arguments — Git already knows where "there" is. Without ever running `-u`, every single push or pull would need the remote and branch spelled out explicitly, every time.

```bash
git fetch
git pull
```

`git fetch` downloads any new history from the remote into a remote-tracking ref (like `backup/main`) but touches nothing else — your working tree and current branch stay exactly as they were, giving you a safe chance to review incoming changes first. `git pull` is shorthand for `fetch` immediately followed by `merge` (or `rebase`, if configured) into your current branch. The two are not interchangeable: `fetch` only tells you what changed, `pull` actually applies it.

## Self-Check and Verification

To prove you understand the local three-state model and the mechanics of a remote:

1. Initialize a brand-new repository in an empty directory with `git init` and confirm `git log` reports no commits yet.
2. Create two files, run `git status` to confirm they show as untracked, then stage and commit them together in one commit.
3. Edit one of the files, and compare the output of `git diff` before staging against `git diff --staged` after staging the same change — confirm they show the same content but at different points in the workflow.
4. Write a `.gitignore` entry for a pattern that doesn't have any matching files on disk yet, then create a matching file afterward and confirm `git status` never mentions it.
5. Create a second, bare repository with `git init --bare` in a different local directory, add it as a remote, and push your `main` branch to it using `-u`.
6. Run plain `git fetch` and `git pull` with no arguments afterward and confirm both succeed without naming the remote or branch.
