# Permissions And Excludes

Astronaut, a backup is more than the contents of the crates. Every crate (file) also carries a lock setting and an owner, and some crates should never be shipped at all. This part shows how `tar` keeps permissions, how it leaves a directory out, and why relative paths make an archive safe to restore anywhere.

## Permissions are part of the data

A plain `tar -czf archive.tar.gz /etc/nginx` keeps the *content* of every file. What happens to ownership and permission bits when you extract it depends on who runs the extraction and on that process's `umask` (the default lock setting for new crates). It does not necessarily match what the source files had.

For most files that is a small annoyance. For a configuration directory it can be a real security problem: a file that only `root` should read can come back readable by everyone, because the restore did not keep the original mode bits.

### Keep permissions on both ends

The `-p` (`--preserve-permissions`) flag fixes this on both ends:

```bash
sudo tar -czpf nginx-backup.tar.gz -C / etc/nginx
sudo tar -xzpf nginx-backup.tar.gz -C /restore/scratch
```

Here is what `-p` does on each side:

- **On backup**, `-p` tells `tar` to record the original mode bits, ownership and symbolic link structure in the archive, not only the file content.
- **On restore**, `-p` tells `tar` to put those recorded values back on the extracted files, instead of using the extracting process's defaults.

Both matter. You can lose detail on the way in, and you can lose it again on the way out, even when the archive itself is perfect. Putting the *original* owner back on a file normally needs `root`, because only `root` can change a file's owner (`chown`) to another user. That is why both commands run with `sudo`.

## Leave out what should not be backed up

Not everything under a directory belongs in a backup. Cache directories, temporary files and build output that can be made again waste space and time and protect nothing. `tar` skips them with `--exclude`.

### Exclude a cache directory

```bash
sudo tar -czpf uploads-backup.tar.gz \
  --exclude=var/www/uploads/cache \
  -C / var/www/uploads
```

`--exclude` patterns are matched against the path **as it will be stored in the archive**. `-C /` makes `tar` change into `/` before it walks `var/www/uploads`. So the stored path, and the path you can match, is the relative `var/www/uploads/cache`, not the absolute path with a leading slash.

A pattern with a leading slash here matches nothing. No error appears, and the cache directory sails straight into the archive.

### Exact path or bare name

There is a real difference between excluding an exact path and excluding a bare name. Be deliberate about which one you mean:

| Pattern | What it matches |
| --- | --- |
| `--exclude=var/www/uploads/cache` | That one relative path only |
| `--exclude=cache` | Any file or directory named `cache`, at any level `tar` walks |

The bare name can surprise you. If there is a second, unrelated directory named `cache` somewhere else (for example `var/www/uploads/app/vendor/cache`), the bare-name pattern silently leaves that out too. When you know the exact path, name it exactly, relative to where `-C` puts you. Use a bare-name pattern only when you really want that wider match.

## Relative paths make an archive safe to restore

`-C /` in front of relative paths (`etc/nginx`, `var/www/uploads`) does more than save typing. It makes the archive store *relative* paths instead of absolute ones.

A relative-path archive can be extracted safely into any scratch directory for testing or recovery. It never touches the live filesystem, and you do not need any tricks to strip a path prefix at restore time. It is also the reason the exclude pattern must be relative: once `-C` is in play, the archive's contents and anything you ask `tar` to match against them live in the same relative-path space.

### Practise on your own

Pick a small directory tree that has one subdirectory of disposable data (a `tmp/` or `cache/` style folder):

1. Take a full backup with `-p` and with `--exclude` for the disposable subdirectory, storing relative paths with `-C`.
2. Confirm the excluded directory is really absent: run `tar -tzf archive.tar.gz | grep <name>`. You should get no output.
3. Repeat the backup with a leading slash in the exclude pattern, and run the same check. This time the directory is in the archive, which shows why the pattern must be relative.

> [!TIP]
> After every backup that uses `--exclude`, run `tar -tzf <archive> | grep <excluded name>`. No output is the proof. A wrong pattern never raises an error.

## Common pitfalls

> [!WARNING]
> - **Leaving out `-p` on one side.** Use it on the backup and on the restore. Either side alone can lose permissions.
> - **Restoring as a normal user.** Only `root` can give a file back to its original owner. Use `sudo`.
> - **A leading slash in `--exclude` after `-C /`.** The stored path is relative, so `/var/www/uploads/cache` matches nothing and the directory is backed up anyway.
> - **Using a bare name by accident.** `--exclude=cache` leaves out every `cache` at any level, not only the one you meant.
> - **Archiving absolute paths.** Use `-C /` with relative paths so the archive can be restored into a scratch directory safely.
