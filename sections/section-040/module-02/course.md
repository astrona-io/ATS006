# Git Branches: Clone, Inspect, Merge, Commit

Think of a branch not as a separate copy of your project, but as a sticky note pointing at a specific spot in the notebook's history. `main` is just one sticky note among potentially many, all pointing at commits inside the same shared object database. Creating a branch doesn't duplicate any files — it just places a new sticky note next to the current one. This is why Git branches are famously cheap: branching is a few bytes of bookkeeping, not a copy operation.

Once you accept that a branch is "just a pointer," a whole category of Git operations stops feeling mysterious: inspecting a branch you haven't checked out, merging one branch's history into another, and understanding exactly what a merge does to your currently checked-out branch.

## Cloning Brings the Whole History, Not Just One Branch

When you clone a repository, Git doesn't hand you a single snapshot — it copies the entire object database, including every branch's commit history.

```bash
git clone /repositories/garden-blog /home/writer/garden-blog
cd /home/writer/garden-blog
```

Because the source here is a local filesystem path rather than an `https://` or `git@` URL, `git clone` works identically to a network clone, just over the local filesystem instead of a transport protocol — the mechanics don't change based on where the bytes travel.

```bash
git branch -a
```

`-a` (`--all`) lists both local branches and **remote-tracking branches** (shown as `remotes/origin/<name>`). Immediately after a clone, you typically have only one local branch checked out — the repository's default — while every other branch that existed on the source repository is present as a remote-tracking reference, not yet a local branch of its own. You don't need to create a local branch, or check anything out, just to know it exists.

## Inspecting Content Across Branches Without Checking Out

Suppose the `garden-blog` repository has three draft branches — `draft-spring`, `draft-summer`, and `draft-fall` — each proposing a different homepage tagline in a file called `homepage.yaml`, and you need to find the one that sets `tagline: "Grow something new"` before publishing it. The naive approach is to check out each branch in turn, look at the file, and switch again. That works, but it's slow, and it leaves your working tree sitting on whichever branch you checked out last.

The better tool is `git show`, using its `<revision>:<path>` syntax:

```bash
git show origin/draft-spring:homepage.yaml
git show origin/draft-summer:homepage.yaml
git show origin/draft-fall:homepage.yaml
```

`git show <ref>:<path>` prints a file's exact content as it exists at the tip of `<ref>` — no checkout, no stash, no risk of disturbing anything currently in your working directory. This is the core technique for "which branch has X" questions: read the content directly out of Git's object database instead of materializing it on disk first.

For scanning many branches at once, `git grep` searching a set of refs is even faster:

```bash
for b in draft-spring draft-summer draft-fall; do
  echo "== $b =="
  git show "origin/$b:homepage.yaml" | grep tagline
done
```

This loop prints the relevant line from every candidate branch side by side, making the correct one obvious without ever leaving `main`.

## Merging Applies to Whatever You Currently Have Checked Out

Once you've identified the correct branch, merging it requires one piece of setup that's easy to forget: `git merge` always folds the named branch's history **into your currently checked-out branch** — never the other way around.

```bash
git switch main
git merge origin/draft-summer
```

`git switch main` (or the older `git checkout main`) guarantees the merge lands in the right place. If you were still sitting on a different branch when you ran `git merge`, you would merge into *that* branch instead — a mistake that's surprisingly easy to make and easy not to notice until much later. Confirming your current branch with `git branch --show-current` before merging is a habit worth building permanently.

Merging directly from a remote-tracking ref like `origin/draft-summer` is perfectly valid when you don't need a local `draft-summer` branch for anything else. If you did want one, `git branch draft-summer origin/draft-summer` followed by `git merge draft-summer` is functionally equivalent.

Critically: only the one branch that actually matched your requirement gets merged. Merging every candidate branch "just to be safe" mixes in changes that were never asked for — the whole point of the inspection step above is choosing exactly one.

## Why Git Won't Track an Empty Directory

Here's a quirk that trips up nearly everyone the first time they hit it. Suppose the task calls for creating a new `assets/` directory at the repository root:

```bash
mkdir assets
git add assets
git status
```

`git status` reports nothing staged. This is not a bug — it's a direct consequence of how Git's object model works. Git only ever stores two kinds of objects that make up a project's structure: **blobs** (file content) and **trees** (directory listings that point at blobs and other trees). A tree entry only exists *because* something inside it needed to be recorded. An empty directory has no content to turn into a blob, so there is nothing for Git to hash and nothing for a tree to point at — the directory is invisible to Git until it contains at least one tracked file.

The universal workaround is a placeholder file — conventionally named `.keep` or `.gitkeep` (Git attaches no special meaning to either name; any filename works identically):

```bash
touch assets/.keep
git add assets/.keep
git status
```

Now `git status` shows `assets/.keep` staged as a new file, and the directory itself becomes visible to Git purely as a side effect of tracking something inside it.

## Committing with a Clear Message

```bash
git commit -m "add assets directory"
```

Using `-m` avoids dropping into your configured text editor (`core.editor`, often `vim` by default) for an interactive commit message — a common source of "I'm stuck in a terminal editor and don't know how to exit" panic for anyone unfamiliar with modal editors. In any scripted or time-pressured context, `-m "exact message"` is the reliable path. Running `git status` immediately before the commit is a final, nearly free sanity check confirming exactly what's staged and which branch you're actually on.

## Self-Check and Verification

To prove you can navigate branches and merges without ever losing track of your working tree:

1. Clone a repository containing at least three sibling branches off the same base commit.
2. List all branches with `git branch -a` and identify which ones exist only as remote-tracking references.
3. Use `git show <branch>:<path>` (not `git checkout`) to read a specific file's content on each of the three branches and identify the one matching a target value.
4. Confirm your current branch with `git branch --show-current`, switch to the correct target branch if needed, then merge only the one matching branch into it.
5. Create a new empty directory, confirm `git add` on the empty directory stages nothing, then add a `.keep` placeholder file inside it and confirm the directory becomes trackable.
6. Commit the change with `-m` and confirm with `git log --oneline -3` that exactly one new commit was added on top of the merge.
