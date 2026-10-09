# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Before you move on, look back at what you learned, check yourself, and clean up anything still running.

## What you learned

This module was about the basic mechanics of the flight log archive: writing entries, checking them before they are sealed, and sharing the archive with a second home.

**From [The Three States Of A File](./course-01-the-three-states-of-a-file.md):**

- A change moves from the working tree to the staging area with `git add`, and into the history with `git commit`.
- `git init` only creates the local `.git/` directory. There are no commits until you make the first one.
- `git status` shows which state every file is in. Read it before every commit.

**From [Diff, Ignore And Log](./course-02-diff-ignore-and-log.md):**

- `git diff` compares the working tree with the staging area. `git diff --staged` (or `--cached`) compares the staging area with the last commit.
- A `.gitignore` pattern only affects files Git does not already track. Untrack a committed file with `git rm --cached <path>` first.
- `git log --oneline` lists commits newest first, one line each.

**From [Remotes, Push And Fetch](./course-03-remotes-push-and-fetch.md):**

- A remote is only a name mapped to a URL or a local path, stored in `.git/config`.
- `git init --bare` creates a repository with no working tree, the kind a Git host runs.
- `git push -u` pushes and sets the upstream, so later `push`, `pull` and `fetch` need no arguments.
- `git fetch` only updates the remote-tracking reference. `git pull` fetches and then merges into your branch.

## Your missions

You proved these skills in a graded mission, right after the part that taught the last of them:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Git Fundamentals Lab](../../../labs/lab-041/docs/question.md) | Remotes, Push And Fetch | built a repository in three exact commits, ignored `build/` and pushed to a bare `origin` with tracking |

If you skipped it, go back to it now. It is short, and the exam asks for exactly these skills.

## Practise on your own

To prove you understand the three states and how a remote works, try this from an empty directory:

1. Initialize a brand-new repository in an empty directory with `git init` and confirm `git log` reports no commits yet.
2. Create two files, run `git status` to confirm they show as untracked, then stage and commit them together in one commit.
3. Edit one of the files, and compare the output of `git diff` before staging with `git diff --staged` after staging the same change. Confirm they show the same content, but at different points in the workflow.
4. Write a `.gitignore` entry for a pattern that has no matching files on disk yet, then create a matching file and confirm `git status` never mentions it.
5. Create a second, bare repository with `git init --bare` in a different local directory, add it as a remote, and push your `main` branch to it with `-u`.
6. Run plain `git fetch` and `git pull` with no arguments and confirm both succeed without naming the remote or the branch.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. What are the three states a change moves through?</summary>

The working tree (the files on disk), the staging area or index (what goes into the next commit) and the history (the commits).
</details>

<details>
<summary>2. You run <code>git add pancakes.txt</code> and then <code>git diff</code>. It prints nothing. Where did the change go?</summary>

Nowhere. It is in the staging area. Plain `git diff` compares the working tree with the staging area, and those are now the same. Run `git diff --staged` to see it.
</details>

<details>
<summary>3. You add <code>*.log</code> to <code>.gitignore</code>, but Git still reports changes to <code>app.log</code>. Why?</summary>

`app.log` was committed before the rule existed, so Git still tracks it. Run `git rm --cached app.log` and commit the removal; after that the rule applies.
</details>

<details>
<summary>4. What does <code>git init</code> create, and does it need a network connection?</summary>

It creates the hidden `.git/` directory with an empty object database, references and a configuration file. It needs no network connection and makes no commits.
</details>

<details>
<summary>5. What is a Git remote?</summary>

A name mapped to a location, either a URL or a local path, recorded in `.git/config`. It is not a server or a protocol by itself.
</details>

<details>
<summary>6. What does <code>-u</code> on <code>git push -u origin main</code> add?</summary>

It records that your local `main` follows `origin/main`. After that, plain `git push`, `git pull` and `git fetch` on that branch need no arguments.
</details>

<details>
<summary>7. You want to see what a teammate pushed without changing your branch. Which command do you run?</summary>

`git fetch`. It only updates the remote-tracking reference. `git pull` would also merge the changes into your current branch.
</details>

## Clean up

The lab is a whole virtual machine running on your computer. When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the mission. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-041
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *Write in the logbook, check the tray, seal the entry, and keep a second copy at mission control.*
