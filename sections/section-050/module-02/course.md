# Backup Strategy with tar

There's a meaningful difference between "I ran a backup command" and "I have a backup strategy," and it's the gap this module is about. A single `tar -czf` invocation captures a snapshot. A strategy is a repeatable process: it preserves the metadata that actually matters, it knows what to leave out, it doesn't waste time and space re-copying unchanged data every single run, and — the part almost everyone skips — it has actually been proven to restore correctly, because a backup nobody has ever tested is really just a hope.

## Permissions Are Part of the Data

A plain `tar -czf archive.tar.gz /etc/nginx` captures file *content* faithfully, but by default, what happens to ownership and permission bits on extraction depends on the extracting process's own identity and umask — not necessarily what the source files actually had. For most files that's a minor annoyance. For a configuration directory, it can be a real security regression: a restored file that should only be readable by `root` coming back world-readable because the restore process didn't know to preserve the original mode bits.

The `-p` (`--preserve-permissions`) flag fixes this on both ends of the process:

```bash
sudo tar -czpf nginx-backup.tar.gz -C / etc/nginx
sudo tar -xzpf nginx-backup.tar.gz -C /restore/scratch
```

`-p` on backup tells `tar` to record the original mode bits, ownership, and symlink structure into the archive rather than just the byte content. `-p` on restore tells `tar` to apply those recorded values back onto the extracted files, rather than falling back to the extracting process's defaults. Both matter — you can lose fidelity on the way in, and you can lose it again separately on the way out, even if the archive itself was perfectly correct. And restoring the *original* ownership onto a file generally requires running as `root`, since only `root` can `chown` a file to a different user.

## Excluding What Shouldn't Be Backed Up

Not everything under a directory tree belongs in a backup. Cache directories, temp files, and regenerable build artifacts waste space and time without protecting anything you couldn't just rebuild. `tar` skips them with `--exclude`:

```bash
sudo tar -czpf uploads-backup.tar.gz \
  --exclude=var/www/uploads/cache \
  -C / var/www/uploads
```

There's a real difference between excluding an exact path and excluding a bare name pattern, and it's worth being deliberate about which one you mean. `--exclude` patterns are matched against the path as it will be *stored in the archive* — since `-C /` changes `tar`'s working directory before it walks `var/www/uploads`, the stored (and therefore matchable) path is the relative `var/www/uploads/cache`, not the absolute filesystem path with a leading slash; a leading-slash exclude pattern here simply won't match anything and the directory would silently sail straight into the archive. `--exclude=var/www/uploads/cache` matches that one specific relative path. `--exclude=cache` matches the *name* `cache` at any level of the tree `tar` walks — if there happened to be a second, unrelated directory named `cache` somewhere else under the paths you're archiving (say, `var/www/uploads/app/vendor/cache`), the bare-name pattern would silently exclude that too, whether you intended it or not. When you know the exact path you want excluded, name it exactly (relative to wherever `-C` puts you); reach for pattern-style excludes only when you deliberately want that broader match.

`-C /` before the relative paths (`etc/nginx`, `var/www/uploads`) matters for a second reason beyond convenience: it makes the archive store *relative* paths instead of absolute ones. A relative-path archive can be safely extracted into any scratch directory for testing or recovery without ever touching the live filesystem it was extracted from, and without any prefix-stripping games at restore time. It's the same reason the exclude pattern above has to be relative too — both the archive's contents and anything you ask `tar` to match against them live in that same relative-path space once `-C` is in play.

## Full Backups Are Wasteful Every Single Night

A full backup captures everything, every time, whether or not anything actually changed. For a directory that barely changes day to day, that's a lot of redundant I/O and storage for almost no new information. The fix is an incremental backup: capture only what's different since the last run.

```bash
sudo tar -czpf level0.tar.gz \
  --listed-incremental=/var/backups/snapshot.snar \
  -C / etc/nginx var/www/uploads
```

The `--listed-incremental=<snapshot-file>` flag is what makes a backup "true incremental" rather than just "another full copy with a different name." The snapshot file (conventionally given a `.snar` extension) records per-file metadata — modification time, inode number, size — as of this run. On the very first run, that snapshot file doesn't exist yet, so `tar` has no baseline to compare against; it creates the file and this first run is necessarily a full backup, which is expected and correct. It's the *next* run using the same snapshot file that becomes genuinely incremental:

```bash
sudo tar -czpf level1.tar.gz \
  --listed-incremental=/var/backups/snapshot.snar \
  -C / etc/nginx var/www/uploads
```

This second invocation reads the existing snapshot file, compares the current filesystem state against what's recorded there, and archives only the files that are new or have changed since — then updates the snapshot file to reflect the new baseline for next time. The resulting archive is typically dramatically smaller than the first, which is directly visible by comparing file sizes.

## The Snapshot File *Is* the Incremental Mechanism

This is the single fact about incremental backups worth committing to memory, because it fails silently: if the snapshot file is lost, deleted, or a different path is used by mistake, `tar` has no baseline to compare against on the next run. It doesn't error. It doesn't warn you the chain is broken. It simply treats the run as a fresh level-0 backup and archives everything again, exactly as if `--listed-incremental` had never been used, while still reporting success. The only way to notice is to check the resulting archive's size against what you expected, or to check the snapshot file's own modification time against your backup schedule. Whatever process runs your backups needs to guarantee that snapshot file survives between runs — a cleanup job that doesn't know it's special is a realistic way to quietly turn every "incremental" backup back into a full one.

## A Clean Exit Code Is Not Proof of a Correct Restore

`tar -x` returning exit status 0 only tells you it didn't hit an I/O error or encounter a malformed archive while extracting. It says nothing about whether the extracted files, their permissions, or the directory structure actually match what was backed up. The only way to actually know a restore is correct is to compare it against a known-good original:

```bash
sudo mkdir -p /restore/scratch
sudo tar -xzpf level0.tar.gz -C /restore/scratch

sudo diff -r /etc/nginx /restore/scratch/etc/nginx
```

`diff -r` recursively walks both directory trees and reports any file that differs in content or exists on only one side. No output means the two trees are identical. Note what `diff -r` does *not* check by default — it compares file content, not ownership or permission bits — so if you specifically need to verify that `-p` preservation worked, pair it with an explicit `stat` or `ls -l` comparison on a file whose permissions actually matter, rather than relying on `diff -r` alone to catch a permissions regression.

Restoring an incremental chain follows the same "layer on top" logic as the backups themselves: extract the full (level-0) backup first, then extract each subsequent incremental archive on top of that same destination, in the order they were taken. Each incremental archive lays its changed and new files over what's already there — including bookkeeping for files that were deleted from the source since the previous run, which get removed from the restore target too, not just left behind as stale leftovers.

## Self-Check and Verification

To prove you understand full and incremental `tar` backup strategy:

1. Pick a small directory tree with a subdirectory that represents disposable data (a `tmp/` or `cache/`-style folder) you want excluded.
2. Take a full backup with `-p` (preserve permissions) and `--exclude` for that disposable subdirectory, storing relative paths via `-C`.
3. Confirm the excluded directory is genuinely absent with `tar -tzf archive.tar.gz | grep <name>` (expect no output).
4. Modify one existing file and create one brand-new file in the source tree, then take a second backup using `--listed-incremental=snapshot.snar` with the same snapshot file path as a first (level-0) incremental run.
5. Compare the sizes of the level-0 and level-1 archives — the level-1 archive should be visibly smaller, proving only the changes were captured.
6. Restore the full backup into a scratch directory, then layer the incremental archive on top of that same destination.
7. Run `diff -r` between the original source tree and the restored scratch directory (excluding the disposable directory from the comparison) and confirm the output is empty.
