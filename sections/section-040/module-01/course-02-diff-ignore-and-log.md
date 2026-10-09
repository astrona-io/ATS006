# Diff, Ignore And Log

Astronaut, a careful crew checks every logbook entry before it is sealed. This part shows how Git compares the three states with `git diff`, how a `.gitignore` keeps junk out of the archive, and how `git log` reads back what you sealed.

The commands below run inside the `~/projects/recipe-notes` repository, which already has one commit holding `README.md` and `pancakes.txt` (a file with the lines `2 eggs` and `1 cup flour`).

## `git diff` vs `git diff --staged`

This is the most useful distinction in this module, and the one worth learning by heart. Both commands show differences, but they compare different pairs of states.

### See an unstaged change

Edit `pancakes.txt` to add a third ingredient, then ask Git what changed:

```bash
echo "1 tsp baking powder" >> pancakes.txt
git diff
```

With **no arguments**, `git diff` compares the **working tree with the staging area**. The staging area still matches the last commit and you have staged nothing yet, so Git shows exactly the one line you just added. It answers the question *"what have I changed that is not staged yet?"*

### Stage it and run `git diff` again

Now put the change in the outbox tray and run the same command:

```bash
git add pancakes.txt
git diff
```

This time Git prints **nothing at all**. The working tree and the staging area are now the same, so there is no difference to show. This surprises almost everyone the first time. The change did not disappear; the thing Git compares against moved.

### See the staged change

To see what is waiting in the outbox tray, use the other form:

```bash
git diff --staged
```

`--staged` (an exact synonym for `--cached`) compares the **staging area with the last commit (`HEAD`)**. It answers *"what will be committed if I run `git commit` right now?"* That is a different question from plain `git diff`, and often the more important one.

```mermaid
flowchart LR
    W["working tree"] -->|"git diff"| S["staging area"]
    S -->|"git diff --staged"| H["HEAD commit"]
```

The diagram shows which pair of states each command compares: plain `git diff` looks between the working tree and the staging area, and `git diff --staged` looks between the staging area and the last commit.

Now seal the change:

```bash
git commit -m "add baking powder to pancake recipe"
```

> [!TIP]
> Run `git diff` before you stage, to review what you are about to add, and `git diff --staged` right before you commit, to review exactly what is about to become permanent. You can stage part of a change, forget about it, and then commit something different from what you last typed. Checking both catches that.

## Keeping noise out with `.gitignore`

Most real projects create files you never want in the archive: compiled programs, log output, editor swap files, downloaded dependencies. A `.gitignore` file is the list of crates that never go into the archive. It tells Git to stop offering matching paths as untracked files.

### Ignore temporary files

Save this as `.gitignore` in the top directory of the repository:

```text
*.tmp
```

Apply it by committing the file:

```bash
git add .gitignore
git commit -m "ignore temporary files"
```

The rule has one limit that matters. A `.gitignore` pattern only stops Git from noticing files it **is not already tracking**. If a `.tmp` file was committed *before* this rule existed, Git keeps tracking it and reporting changes to it, whatever the pattern says. The rule does not reach back into the history. To stop tracking a file that is already committed, run `git rm --cached <path>` and commit that removal; after that, the ignore rule applies to it.

### Test the rule before anything matches it

Test a `.gitignore` rule with a file in a directory that did not exist before:

```bash
mkdir scratch
echo "leftover data" > scratch/output.tmp
git status
```

If the rule is written correctly, `git status` reports nothing new at all. That proves the pattern works before a real build process or script ever creates matching files.

## Reading history with `git log`

Once a few commits exist, `git log` shows them, newest first.

### List the commits

Show one line per commit:

```bash
git log --oneline
```

Each line is a short commit hash followed by its message. This is the fast, easy-to-scan form you will use all the time. Plain `git log` (no flags) shows the full author, date and message of each commit, which helps when you need more detail than one line gives.

## Common pitfalls

> [!WARNING]
> - **Running `git diff` after `git add` and thinking the change is gone.** Plain `git diff` only shows unstaged changes. Use `git diff --staged` to see what is staged.
> - **Expecting `.gitignore` to hide a file that is already committed.** Git keeps tracking it. Run `git rm --cached <path>` and commit the removal first.
> - **Writing the ignore rule after the junk is committed.** Add the `.gitignore` before the build or script creates the files.
> - **Reading `git log` from the bottom.** The newest commit is at the top.
