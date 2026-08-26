# Archive Conversion & Content Verification

An archive and a compression format are two separate ideas that `tar` happens to let you invoke with a single command, and confusing the two is where most mistakes in this topic start. The archive is the bundling: many files and directories flattened into one file, with names, permissions, and structure preserved. The compression is a completely independent second pass applied on top of that bundle to shrink it. `tar` doesn't compress anything itself — it hands the finished archive stream to an external compressor (`gzip`, `bzip2`, `xz`) and lets that program do the squeezing.

Think of it like packing a shipping crate. Building the crate and deciding what goes inside it (the archive) is one job. Vacuum-sealing the crate afterward to save shelf space (the compression) is a completely different job, done by different equipment, and you can swap the vacuum-sealer for a different model without ever repacking the crate.

## The Compression Filters Are Just Flags to an External Program

When you run `tar -czf out.tar.gz files/`, `tar` builds the archive stream internally, then pipes it straight into `gzip` before writing the result to disk. The `-z` flag is really just shorthand telling `tar` "pipe my output through gzip." `-j` does the same thing for `bzip2`, and `-J` does it for `xz`. They are mutually exclusive per invocation for a simple reason: you're choosing one compressor program to pipe through, not several.

```bash
tar -czf backup.tar.gz /var/log/myapp
tar -xjf legacy-export.tar.bz2 -C /tmp/restore
```

Modern GNU `tar` can also usually auto-detect the compression format of an existing archive from its file's magic bytes when you're only reading it (`-x` or `-t`), so `-j` versus `-z` matters most when you're *creating* a new archive — that's the one place you're actively choosing a format rather than just reading whatever is already there.

## Why "Best Compression" Needs a Different Flag Entirely

Here is the trap that catches almost everyone the first time: `tar -czf` does not give you any control over how hard gzip squeezes. The `-z` shortcut just invokes `gzip` with its default settings — compression level 6, a reasonable middle ground gzip picked as its default. If a task calls for "the strongest possible compression," `-z` alone silently ignores that requirement and you'd never know from the archive creating successfully.

Gzip's compression level is controlled by `-1` (fastest, largest output) through `-9` (slowest, smallest output), but `tar -z` has no syntax to pass that flag through. The portable, exam-safe way to do it is `--use-compress-program`, which tells `tar` to invoke a specific compressor command line instead of its built-in shortcut:

```bash
tar --use-compress-program="gzip -9" -cf export-max.tar.gz /srv/reports
```

This bypasses `-z` entirely and gives `tar` an explicit command to pipe through, flags and all. You'll sometimes see the `GZIP` environment variable used instead (`GZIP=-9 tar -czf ...`), which older gzip versions read for default options — but newer gzip releases deprecate that variable in favor of `GZIP_OPT`, so it's a less durable habit to build. `--use-compress-program` works regardless of which gzip version is installed, which is exactly the kind of detail that matters when you don't get to choose the target machine's software versions.

You can actually confirm which level was used after the fact: gzip stores an "extra flags" byte in its file header — value `2` when the file was compressed at level 9 (maximum), value `4` at level 1 (fastest), and `0` for anything in between, including the untouched default of 6. That single byte is proof the right flag was actually passed, not just claimed.

## Listing Contents Without Extracting Anything

Before you trust any archive — one you just built, one you inherited, one you're about to overwrite something with — you can inspect what's inside it without unpacking a single byte:

```bash
tar -tf export-max.tar.gz
```

`-t` is a full operating mode in its own right, distinct from `-x` (extract). It reads the archive's internal index and prints every entry's path, and nothing else touches the disk. This is close to a free operation, so there's no excuse for skipping it — run it on a fresh export before you ship it anywhere, and run it again on the receiving end after a transfer to confirm nothing got truncated.

## Proving Two Archives Hold the Same Content

Converting an archive's compression format is only half the job; proving the conversion didn't drop or corrupt anything is the other half, and it's the half people skip under time pressure. The standard technique is to generate a listing of each archive's contents and diff the two listings:

```bash
tar -tjf legacy-export.tar.bz2 | sort > bz2.listing
tar -tzf export-max.tar.gz      | sort > gz.listing
diff bz2.listing gz.listing
```

The `sort` step matters more than it looks. `tar -t` prints entries in whatever order they were physically written into the archive, which for two independently-built archives of "the same" content is rarely identical — one might list a subdirectory's files before its siblings, the other after. Two listings of genuinely identical content but different internal ordering will produce a `diff` full of noise that looks like a mismatch but isn't. Sorting both listings into the same deterministic order first means an empty `diff` output really does mean "these hold the same files," and any non-empty output is a real discrepancy worth investigating — not an ordering artifact.

## Doing the Conversion Without Touching the Original

The safest way to re-archive a bzip2 file's contents as gzip is to extract into a disposable staging directory, never into the same directory the original archive lives in:

```bash
mkdir -p /tmp/stage
tar -xjf legacy-export.tar.bz2 -C /tmp/stage

cd /tmp/stage
tar --use-compress-program="gzip -9" -cf /srv/reports/export-max.tar.gz .
```

`-C /tmp/stage` changes `tar`'s working directory just for that one extraction — nothing lands anywhere near the original file, and the original archive is only ever opened for reading. Re-archiving from inside the staging directory using `.` as the target also keeps the new archive's internal paths relative, matching whatever path style the original used, rather than baking in an absolute path from your scratch location. Clean up the staging directory once you're done (`rm -rf /tmp/stage`) — leftover extracted files are exactly the kind of thing that confuses a later disk-space audit or a grep for stray files.

If you don't actually need to re-archive — you're purely converting the outer compression layer of an existing `.tar` stream — there's a faster path that never touches the archive layer at all: pipe the decompressed bytes of one compressor straight into another.

```bash
bzip2 -dc legacy-export.tar.bz2 | gzip -9 > export-max.tar.gz
```

This treats the `.tar` bytes as an opaque stream between two compressors and never re-invokes `tar` at all, which sidesteps any risk of accidentally changing path prefixes during a manual extract-and-rearchive.

## Self-Check and Verification

To prove you understand archive conversion and content verification:

1. Create a small directory of test files and archive it with bzip2: `tar -cjf sample.tar.bz2 sample/`.
2. List its contents without extracting anything, sorted, into a listing file: `tar -tjf sample.tar.bz2 | sort > sample.bz2.listing`.
3. Convert it to a maximally-compressed gzip archive using a staging directory and `--use-compress-program="gzip -9"`, without ever opening `sample.tar.bz2` for writing.
4. Generate a sorted listing of the new gzip archive the same way, and `diff` the two listing files — confirm the output is empty.
5. Inspect the gzip header's extra-flags byte (offset 8) and confirm it reads `2`, proving level 9 was actually used and not gzip's default level 6.
6. Delete your staging directory and confirm with `ls -la` that the original `sample.tar.bz2`'s size and modification time are unchanged from before you started.
