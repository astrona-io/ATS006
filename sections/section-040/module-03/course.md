# Cloning an Upstream Repo, Working on a Topic Branch, and Reconciling Changes

Every operator who touches shared configuration eventually lives through the same story: you clone a repository someone else maintains, branch off to make a focused change, and while you're heads-down working, someone else pushes a completely unrelated change to the same shared branch. Nothing about that is a mistake or a conflict by itself — it's the normal, expected rhythm of a repository more than one person touches. What matters is knowing exactly how to notice it happened and how to fold your work back in cleanly.

This module covers that full lifecycle: what a clone automatically sets up for you, how to isolate new work on a topic branch, how to inspect precisely what your branch changed, and the two different tools — `rebase` and `merge` — for reconciling with an upstream that moved on without you.

## What Cloning Sets Up Automatically

```bash
git clone /repositories/network-configs /home/netops/network-configs
cd /home/netops/network-configs
git status
git branch -vv
```

A clone doesn't just copy history — it also checks out the source repository's default branch locally (commonly `main`) and, without any extra configuration, sets it up to **track** the corresponding remote-tracking branch (`origin/main`). That's why `git status` immediately after a clone reports something like "Your branch is up to date with 'origin/main'" — the association already exists. `git branch -vv` (verbose-verbose) makes this tracking relationship visible directly, printing `[origin/main]` next to `main` in its output.

## Isolating Work on a Topic Branch

Before making any change, the first move is always to get off the shared branch and onto one that exists solely for this piece of work:

```bash
git switch -c increase-mtu-value
git branch --show-current
```

`git switch -c` (the modern, purpose-built command) creates the new branch starting from your current `HEAD` and checks it out in the same step. The older equivalent, `git checkout -b increase-mtu-value`, does exactly the same thing — `switch` and `restore` are simply the newer commands Git split out of the older, overloaded `checkout` to make each one's job narrower and less error-prone.

This distinction matters more than it looks: `git branch increase-mtu-value` on its own only *creates* the branch — you remain on whatever branch you were previously on, and it's easy to keep editing files there without noticing the new branch was never actually checked out.

## A Single, Focused Commit

```bash
sed -i 's/mtu: 1500/mtu: 9000/' interfaces.yaml
git diff
git add interfaces.yaml
git commit -m "increase mtu to 9000 for jumbo frame support"
```

A topic branch works best when it carries exactly one logical change with a message explaining *why*, not just *what* changed. Running `git diff` before staging is a deliberate checkpoint — it confirms only the intended line changed and nothing else crept in from an unrelated edit still sitting in the working tree.

## Measuring Exactly What a Branch Changed

Once a topic branch has one or more commits, you often need to answer precisely: "what does this branch add that `main` doesn't have?" Git's two-dot range syntax answers this directly:

```bash
git log main..increase-mtu-value --oneline
```

`git log A..B` lists every commit reachable from `B` but not from `A` — read it as "what does the second branch have that the first doesn't." Getting the operand order backwards (`increase-mtu-value..main`) answers the opposite question instead, which is a common source of "why is this showing nothing" confusion.

```bash
git diff main..increase-mtu-value
```

The same two-dot form applied to `diff` shows the combined content difference between the two tips as a single patch — for a one-commit branch this looks identical to `git show` on that commit, but it scales cleanly to many commits.

## Fetch Tells You What Changed — It Never Touches Your Branch

This is the single most important fact in this module, worth stating as plainly as possible: **`git fetch` never modifies your working directory or your currently checked-out branch, under any circumstances.**

```bash
git fetch origin
git log main..origin/main --oneline
```

`fetch` downloads any new objects from the remote and moves the remote-tracking ref (`origin/main`) to reflect the new upstream tip — nothing else. Your local `main` and your topic branch stay exactly where they were. This makes `fetch` completely safe to run at any time, as often as you like, purely to see what's changed before deciding what to do about it. The moment something actually gets folded into your checked-out branch is when you run `merge`, `rebase`, or `pull` (which is just `fetch` immediately followed by `merge`, bundled into one command).

## Reconciling with Rebase

```bash
git switch increase-mtu-value
git rebase origin/main
```

`git rebase origin/main`, run while sitting on the topic branch, detaches your branch's commits, moves the branch's base to match the new `origin/main` tip, and replays each of your commits on top of it one at a time. The result reads as if you had branched off *after* the new upstream change existed all along — a clean, linear history with no extra merge commit.

```bash
git log --oneline --graph --all
```

If the upstream change and your topic branch touched different lines of the same file, the rebase replays with zero conflicts. If they touched the *same* line, Git pauses mid-rebase with conflict markers (`<<<<<<<` / `=======` / `>>>>>>>`) in the affected file; resolve them by hand, `git add` the resolved file, and run `git rebase --continue`. `git rebase --abort` is always available as a full, clean undo if a rebase turns out messier than expected.

## When to Reach for Merge Instead

Rebase isn't always the right tool. The critical rule: **never rebase a branch that has already been pushed and that someone else may have based their own work on.** Rebase rewrites commit hashes — every commit it replays becomes a brand-new object with a new identity, even though the content is unchanged. If a teammate already has a clone containing the old commits, rebasing out from under them creates two diverging, seemingly-unrelated histories that no longer share commit hashes, a genuinely painful mess to untangle.

```bash
git merge origin/main
```

A merge instead creates a new commit with two parents, weaving both histories together exactly as they actually happened, in their original chronological branches, without rewriting a single existing commit. The trade-off: the resulting history contains an extra merge commit and a visible branch-and-rejoin shape instead of a single straight line.

The practical rule of thumb: rebase freely on a small, not-yet-shared topic branch to keep history clean; merge once a branch is shared, or whenever preserving the true parallel timeline of both lines of work matters more than a tidy straight line.

## Self-Check and Verification

To prove you can carry a topic branch through a full reconciliation cycle:

1. Clone a repository and confirm with `git branch -vv` that your default branch is already tracking `origin`'s default branch with zero extra setup.
2. Create a topic branch with `git switch -c`, make one focused, single-purpose commit, and confirm with `git diff` beforehand that only the intended change is present.
3. Use the two-dot range form of `git log` and `git diff` to show exactly what your topic branch added relative to the branch it came from.
4. Simulate someone else pushing directly to the shared branch (from a second clone, or by committing directly in a bare repository), then run `git fetch` and confirm your working branch is completely unaffected until you act on it.
5. Rebase your topic branch onto the new upstream tip and confirm with `git log --oneline --graph --all` that the result is a single linear line, not a merge bubble.
6. Explain out loud, in one or two sentences, the one condition under which you would choose `merge` over `rebase` for this same reconciliation.
