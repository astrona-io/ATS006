# The Three States Of A File

Astronaut, before you can work with branches, merges or remotes, you need to know where a change lives at every moment. This part shows the three places a change can be, how a new repository starts, and how `git status` tells you which place each file is in.

## The three-state model

Every file Git manages moves through three states. Almost every beginner's confusion with Git comes from losing track of which state a file is in. Think of the flight log archive: you write in an open logbook, put the pages you want to keep in an outbox tray, and then seal them into the archive.

1. **Working tree** (the open logbook): the files as they sit on disk right now, exactly as you last saved them in your editor.
2. **Staging area**, also called **the index** (the outbox tray): a holding place where you put exactly the changes you want in your *next* commit, no more and no less.
3. **History**, made of **commits** (the sealed entries): the permanent, timestamped entries. Once Git commits a change, it is part of the project's recorded story.

```mermaid
flowchart LR
    W["working tree"] -->|"git add"| S["staging area"]
    S -->|"git commit"| H["history"]
```

The diagram shows the path every change takes: `git add` moves it from the working tree to the staging area, and `git commit` seals it into the history.

## Creating a repository with `git init`

A brand-new repository has none of these entries yet. You create one with `git init`, and it is worth knowing exactly what that command does and does not do.

### Create your first repository

Run these commands to make a directory and turn it into a repository:

```bash
mkdir -p ~/projects/recipe-notes
cd ~/projects/recipe-notes
git init
```

`git init` creates a hidden `.git/` subdirectory inside the directory: an empty object database, a set of references and a configuration file. Nothing else happens. No commits exist yet, Git makes no network call, and it touches none of your files. You could run `git init` on an airplane with no internet connection and it would work the same way.

At this point `git log` refuses to run, because the repository "does not have any commits yet". That is expected: the archive exists, but nobody has written an entry in it.

## Reading `git status`

`git status` is the one command that tells you, at any moment, which of the three states every file is in. Use it often; it costs nothing.

### Create two files and look at them

Create two files in your new repository and ask Git what it sees:

```bash
echo "# Recipe Notes" > README.md
printf "2 eggs\n1 cup flour\n" > pancakes.txt
git status
```

Git lists both files under **"Untracked files"**. It has noticed them on disk, but they sit fully outside the staging area and the history. Nothing is lost if you delete them; Git simply has not been asked to remember them yet.

### Stage the files

Now put both files in the outbox tray and check again:

```bash
git add README.md pancakes.txt
git status
```

The same two files now appear under **"Changes to be committed"**. They have moved into the staging area. This is the moment to stop and read that list. It is very common to run `git add .` by accident and stage a file you did not mean to include. `git status` right before a commit is the cheap insurance that catches it.

### Seal the first commit

Write the staged snapshot into the history:

```bash
git commit -m "initial commit"
```

Git turns the staged snapshot into a permanent entry in the history. If you run `git status` right after, it reports "nothing to commit, working tree clean": all three states now agree.

> [!TIP]
> Make `git status` a reflex before every `git add` and every `git commit`. It is the fastest way to see which branch you are on and what is about to be sealed.

## Common pitfalls

> [!WARNING]
> - **Running `git log` in a new repository and thinking something broke.** Before the first commit there is no history, so `git log` refuses to run. That is normal.
> - **Staging too much with `git add .`.** It stages every changed and untracked file. Read `git status` before you commit.
> - **Expecting `git init` to contact a server.** It only creates the local `.git/` directory. Sharing comes later, with a remote.
> - **Forgetting that an untracked file is not protected.** Git only remembers a file after you add and commit it.
