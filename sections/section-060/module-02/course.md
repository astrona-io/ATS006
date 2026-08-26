# Mirroring and Space-Efficient Incremental Snapshots with rsync

Backing up a directory tree with `tar` gives you a self-contained archive — a single file you'd restore from later, built once and shipped somewhere safe. But a lot of real backup and deployment work isn't about producing an archive at all; it's about keeping two directory trees, often on two different machines, actually *in sync* with each other on an ongoing basis. That's a different job, and `rsync` is the tool built for it: it compares source and destination directly, transfers only the parts of files that actually changed, and can make a destination a byte-for-byte mirror of a source — including removing anything on the destination that no longer exists on the source.

That last capability is also the single most dangerous flag in the entire tool. Point it the wrong direction, or transpose your source and destination arguments, and you can permanently erase the wrong side instead of the one you meant to prune. This chapter builds the safe habits around that risk, and then covers a second, unrelated trick `rsync` can do that has nothing to do with mirroring: taking a long sequence of space-efficient, independently browsable snapshots using hardlinks.

## What `-a` Actually Bundles Together

Nearly every serious `rsync` invocation starts with `-a` (archive mode), which is documented shorthand for `-rlptgoD`: recursive, preserve symlinks as symlinks, preserve permissions, preserve modification times, preserve group, preserve owner, and preserve device/special files. Bundling all of that into one flag matters because a backup or mirror that silently drops permissions or timestamps isn't really a faithful copy — it just looks like one until something depends on the metadata that got lost.

```bash
rsync -avz -e ssh /photos/2024-shoot/ nas:/backup/2024-shoot/
```

`-v` adds per-file verbose output as things transfer, `-z` compresses data in transit over the link (useful for text-heavy trees, less useful for content that's already compressed), and `-e ssh` explicitly names the remote-shell transport rsync will use to reach the destination.

## The Trailing Slash: rsync's Most-Quoted Gotcha

Whether the *source* path ends in a slash changes what actually lands at the destination, and it trips up experienced admins regularly enough that it's worth memorizing deliberately rather than reasoning out fresh each time.

With a trailing slash, `rsync` syncs the *contents* of the source directory directly into the destination:

```bash
rsync -a /photos/2024-shoot/ nas:/backup/current/
# -> /backup/current/img001.jpg, /backup/current/img002.jpg, ...
```

Without it, `rsync` treats the source directory itself as the thing being copied, creating a same-named directory inside the destination:

```bash
rsync -a /photos/2024-shoot nas:/backup/current/
# -> /backup/current/2024-shoot/img001.jpg, ...
```

Neither behavior is "wrong" — they're both useful in different situations — but only one of them is usually what you actually intended for a given command, and the difference is invisible until you go look at the result.

## `--delete`: True Mirroring, and Why It Demands a Dry Run First

By default, `rsync` is purely additive — it copies new and changed files, but never removes anything from the destination, even if the corresponding source file is long gone. Making a destination a *true* mirror requires opting in explicitly:

```bash
rsync -avz --delete -e ssh /photos/2024-shoot/ nas:/backup/current/
```

If you deleted `img003.jpg` from the source tree, this run removes it from the destination too. That's exactly the point — but it means a mistake in either direction (source and destination swapped, or the wrong path given on either side) doesn't just fail loudly, it can quietly and permanently delete the wrong tree's files. `rsync` has no built-in "are you sure?" confirmation for `--delete`, so you have to build that confirmation step into your own workflow every single time:

```bash
rsync -avzn --delete -e ssh /photos/2024-shoot/ nas:/backup/current/
```

`-n` (or `--dry-run`) performs every comparison and calculation a real run would — scanning both trees, deciding what would transfer, update, or delete — and prints exactly that, without touching a single byte at the destination. Lines prefixed `*deleting` show precisely what would be removed. Reading every one of those lines before dropping `-n` is the entire safety discipline; there is no shortcut for it.

## `--exclude`: Keeping a Subtree Out Entirely

```bash
rsync -avz --delete --exclude=cache/ -e ssh /photos/2024-shoot/ nas:/backup/current/
```

An excluded path is invisible to `rsync`'s comparison in *both* directions — it's neither copied if new, nor deleted if the destination happens to have a stale copy of it. That symmetry matters: if you exclude a directory on one sync but forget to exclude it identically on the next, previously-ignored files can suddenly get deleted as though they'd vanished from the source, or previously-excluded files can suddenly start syncing. Keep exclude lists consistent across every run in a chain.

## `--link-dest`: Space-Efficient Snapshots, a Different Mechanism Entirely

Mirroring keeps one destination current. Sometimes you want something different: a whole sequence of dated snapshots you can browse or restore from independently, without paying full disk cost for each one. `rsync --link-dest` solves that with hardlinks instead of deltas.

```bash
rsync -avz --exclude=cache/ -e ssh \
  --link-dest=/backup/current \
  /photos/2024-shoot/ nas:/backup/snapshots/2024-06-01/
```

For every file `rsync` finds unchanged compared to the reference directory (`--link-dest`'s target, here the existing mirror at `/backup/current`), it creates a hardlink in the new snapshot pointing at the *same underlying data blocks* instead of transferring and storing the content again. The new snapshot directory ends up with a full set of directory entries — `ls` shows what looks like a complete, independent copy — but unchanged files cost zero extra disk space, since a hardlink is just another name for an inode that already exists. Only genuinely new or modified files consume fresh space in that snapshot.

This is a fundamentally different trick from `tar`'s `--listed-incremental` approach. A `tar` incremental archive is a small *delta* that only has meaning replayed in sequence after the full archive and every prior increment — you cannot browse or restore from it alone. An `rsync --link-dest` snapshot is a complete, independently browsable directory on disk from the moment it's created; the savings happen underneath, at the inode level, invisible to anyone just looking at the tree.

One requirement makes or breaks this entirely: **the `--link-dest` reference directory must be on the same filesystem as the destination.** Hardlinks cannot cross filesystem boundaries. If they're on different filesystems, `rsync` doesn't error — it silently falls back to a full copy for every file, and you lose the entire space benefit without any warning that it happened.

```bash
du -sh /backup/snapshots/2024-06-01
du -sh --apparent-size /backup/snapshots/2024-06-01
```

`du -sh` reports true disk usage — small, since unchanged files share inodes with the reference. `--apparent-size` reports what the size *would* be if every file were an independent copy. The gap between those two numbers is exactly what `--link-dest` saved you.

## Self-Check and Verification

To prove you can build both a safe mirror and an efficient snapshot chain:

1. Create a local source directory with a few files, and a local destination directory. Run `rsync -avzn --delete` between them and confirm the dry-run output matches what you expect before ever dropping `-n`.
2. Run the real sync, then delete one file from the source and re-run the dry run — confirm it shows a `*deleting` line for exactly that file, then run it for real and confirm the destination lost it too.
3. Deliberately test the trailing-slash difference: run the same sync once with a trailing slash on the source and once without, and compare the resulting destination layouts.
4. Take a first full copy with `rsync -a` to `backup/full/`, then take a second copy to `backup/snap2/` using `--link-dest=backup/full`.
5. Confirm the hardlinking actually happened: `stat -c '%n %h' backup/snap2/*` — an unchanged file should show a link count greater than 1.
6. Compare `du -sh backup/snap2` against `du -sh --apparent-size backup/snap2` and explain the gap in your own words.
