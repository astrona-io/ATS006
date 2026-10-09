# Merge And Commit A New Directory

Astronaut, once you have found the right flight path, you join it to the main course. This part shows where a merge lands, why Git ignores an empty directory and how to work around it, and how to write the commit that seals the result.

The examples use the `garden-blog` repository cloned at `/home/writer/garden-blog`, where the branch `draft-summer` holds the tagline you want.

## Merging applies to whatever you have checked out

A **merge** joins the history of one flight path onto another. The one thing that is easy to forget: `git merge` always brings the named branch's history **into the branch you have checked out right now**, never the other way around.

### Merge the chosen branch into `main`

Switch to `main` first, then merge:

```bash
git switch main
git merge origin/draft-summer
```

`git switch main` (or the older `git checkout main`) makes sure the merge lands in the right place. If you were still on a different branch when you ran `git merge`, Git would merge into *that* branch instead. That mistake is easy to make and easy to miss until much later.

Merging straight from a remote-tracking reference such as `origin/draft-summer` is fine when you do not need a local `draft-summer` branch for anything else. If you do want one, `git branch draft-summer origin/draft-summer` followed by `git merge draft-summer` gives the same result.

Merge only the one branch that matched your requirement. Merging every candidate "just to be safe" mixes in changes nobody asked for; the whole point of inspecting the branches first is to choose exactly one.

> [!TIP]
> Run `git branch --show-current` before every merge. It prints the branch you are on, so you know where the merge will land.

## Why Git won't track an empty directory

Here is a quirk that trips up nearly everyone the first time. Suppose the task asks for a new `assets/` directory at the top of the repository.

### Try to add an empty directory

Create the directory and try to stage it:

```bash
mkdir assets
git add assets
git status
```

`git status` reports nothing staged. This is not a bug; it follows from how Git stores a project. Git keeps only two kinds of objects for a project's structure: **blobs** (file content) and **trees** (directory listings that point at blobs and other trees). A tree entry exists only *because* something inside it needed to be recorded. An empty directory has no content to turn into a blob, so Git has nothing to store and no tree points at it. The directory stays invisible to Git until it holds at least one tracked file.

### Add a placeholder file

The usual workaround is a placeholder file, by convention named `.keep` or `.gitkeep`. Git gives neither name any special meaning; any file name works the same way:

```bash
touch assets/.keep
git add assets/.keep
git status
```

Now `git status` shows `assets/.keep` staged as a new file. The directory itself becomes visible to Git only as a side effect of tracking something inside it.

## Committing with a clear message

The last step seals the staged change into the history.

### Commit with `-m`

Write the commit with the message on the command line:

```bash
git commit -m "add assets directory"
```

`-m` stops Git from opening your configured text editor (`core.editor`, often `vim`) to ask for a message. Being dropped into an editor you do not know how to leave is a common source of panic. In any script or timed task, `-m "exact message"` is the reliable way. Run `git status` right before the commit as a final, nearly free check of exactly what is staged and which branch you are on.

## Common pitfalls

> [!WARNING]
> - **Merging while on the wrong branch.** `git merge` lands on the branch you have checked out. Check with `git branch --show-current` first.
> - **Merging every candidate branch.** Only the branch that matches the requirement belongs in `main`.
> - **Expecting `git add` to stage an empty directory.** Git tracks content, not directories. Put a `.keep` file inside.
> - **Committing more than the task asked for.** If the commit should only add `logs/.keep`, make sure `git status` shows nothing else staged.
> - **Typing the commit message from memory.** Graders compare it word for word, including capital letters.

## Your mission: Git Branch Inspection & Merge Lab

You can now find the right branch without checking it out, merge only that branch into `main`, and commit a new directory with a placeholder file. The mission asks you to do exactly that in the Auto-Verifier application's repository.

Start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-042
```

Open a terminal on the lab machine:

```sh
astrona ssh ats-006-lab-042
```

Read the task in [`question.md`](../../../labs/lab-042/docs/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona submit -c labs/lab-042
```

When the mission is done, remove it:

```sh
astrona destroy ats-006-lab-042
```
