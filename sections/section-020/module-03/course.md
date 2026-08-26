# Find, Filter, and Triage Files by Age, Size, and Permission

Any directory that accumulates files over time without active curation eventually turns into a junk drawer: old files nobody needs anymore, oddly tiny files that hint at a truncated write, oddly huge files bloating disk usage, and files with permissions far looser than anyone intended. Sorting that out by eye doesn't scale past a handful of files — but `find` can classify and relocate thousands of files in seconds, as long as you understand exactly how its tests combine, and in what order to run multiple passes so each one only ever sees the files still actually relevant to it.

Picture a librarian triaging a returns cart. If they sort by "damaged, discard" first, then "oversized, shelve in the large-format section," then "reference-only, restricted shelf," each pass only has to deal with what's left after the previous pass already pulled its share out. Try to do it in a different order — say, shelving by size before pulling the damaged books out — and the damaged pile ends up scattered across every other section instead of removed cleanly. `find`-based triage works exactly the same way: get the order of operations right, and each pass is simple; get it wrong, and passes start stepping on each other.

## Time: Relative Days vs an Absolute Date

`find -mtime` expresses time as a relative day count from *right now* — `-mtime +30` means "modified more than 30 days ago as of this exact moment." That's useful for genuinely relative questions ("what hasn't changed in the last month"), but it's the wrong tool the instant a requirement names an absolute calendar date, because a relative count silently drifts depending on when you happen to run the command.

For an absolute cutoff, `-newermt` (GNU find's "newer than this time" test) pins to a literal date instead:

```bash
find /var/log/app-events -maxdepth 1 -type f ! -newermt "2022-06-01" -print
```

`-newermt "2022-06-01"` matches files with a modification time *after* midnight on that date. The leading `!` negates the whole test, flipping it to match everything *not* newer than the cutoff — in other words, everything modified on or before it. Running this first with just `-print` (which is `find`'s default action anyway, so omitting any action does the same thing) costs nothing and shows you exactly what you're about to affect before you add anything destructive:

```bash
find /var/log/app-events -maxdepth 1 -type f ! -newermt "2022-06-01" -delete
```

`-delete` removes matched files directly as a `find` action — safer than piping to `xargs rm`, since it only ever fires on files `find` itself matched, with no intermediate shell word-splitting to worry about. On systems without GNU find's `-newermt`, the same result is reachable with a reference file:

```bash
touch -d "2022-06-01" /tmp/cutoff-marker
find /var/log/app-events -maxdepth 1 -type f ! -newer /tmp/cutoff-marker -delete
```

## Size: Bare, Minus, and Plus

`find -size` filters by file size, and its three prefix forms mean genuinely different things: a bare number (`3k`) means *exactly* that size (rounded to block granularity), `-3k` means *strictly less than*, and `+3k` means *strictly greater than*. The lowercase `k` suffix specifically means 1024-byte blocks — KiB — which matters if a requirement is phrased in KiB rather than the decimal-KB sense some tools default to.

```bash
find /srv/exports -maxdepth 1 -type f -size -500k -exec mv {} /srv/exports/tiny/ \;
find /srv/exports -maxdepth 1 -type f -size +50M -exec mv {} /srv/exports/oversized/ \;
```

`-exec cmd {} \;` runs one process per matched file — simple, and safe even against filenames with unusual characters, but slower against a large number of files since it spawns a fresh process every time. The `+`-terminated form batches many matched filenames into far fewer invocations, similar in spirit to how `xargs` batches arguments:

```bash
find /srv/exports -maxdepth 1 -type f -size -500k -exec mv {} /srv/exports/tiny/ +
```
This only behaves correctly when the underlying command genuinely accepts multiple trailing arguments the way plain `mv file1 file2 ... dir/` does — which is the common case for `mv`, `cp`, and similar tools, but not a universal guarantee for every command.

## Permission: Exact Match vs "Any Bit" vs "All Bits"

`find -perm` has three distinct argument forms that are easy to mix up:

- A bare mode (`-perm 0777`) matches permissions that are *exactly* that value — nothing more, nothing less.
- A mode prefixed with `-` (`-perm -0002`) matches files where *all* the listed bits are set, regardless of what else is also set — useful for a broader "is this world-writable at all" search rather than an exact-match one.
- A mode prefixed with `/` (`-perm /022`) matches files where *any* of the listed bits are set.

```bash
find /srv/exports -maxdepth 1 -type f -perm 0777 -exec mv {} /srv/exports/quarantine/ \;
```

For an exact-match audit — "flag only files that are precisely wide open" — the bare-mode form is correct. For a security sweep looking for *any* group- or other-writable file regardless of what else is set, `-perm -0002` (or `-perm -0022` to catch either group or other write) casts a much wider net and typically finds more candidates worth a second look.

## Order of Operations: Why Sequencing Isn't Optional

Multi-stage triage almost always needs to run in a specific order, and getting that order backwards produces subtly wrong results that are easy to miss. Two traps show up constantly:

**Destination directories created too early.** If the `tiny/`, `oversized/`, and `quarantine/` destination folders already exist *before* a size or permission pass runs, that pass's `find` invocation will happily recurse into them too — potentially re-matching and re-moving files a previous pass already sorted, sometimes into the wrong bucket entirely. `-maxdepth 1` guards against this by restricting each pass to files directly inside the parent directory, never descending into subdirectories that live at that same level.

**Deletion has to happen before triage, not after.** If a task defines "delete old files, *then* sort what's left by size," running the size-based sort first and the age-based delete second changes what "the remaining files" actually means — files that should have been deleted outright might get sorted into a bucket first, and then survive there since a later delete pass wouldn't necessarily be scoped to check subdirectories at all. When a task spells out an explicit multi-step order, that ordering usually exists specifically to prevent exactly this kind of overlap — reordering steps "for efficiency" without checking for side effects is a common way to produce a technically-different, incorrect end state.

A file that happens to satisfy more than one rule (small *and* permission-777, for instance) gets resolved implicitly by whichever pass runs first — once a pass relocates it out of the parent directory, later passes scoped with `-maxdepth 1` simply never see it again. That's a feature, not a bug, as long as the task's stated order is followed faithfully.

## Self-Check and Verification

To prove you can triage a directory correctly and in the right order:

1. Build a test directory containing files with a spread of modification dates (some old, some recent), a spread of sizes (some tiny, some large, some in between), and at least one file with wide-open `777` permissions.
2. Run a dry-run `find ... -print` (no `-delete`, no `-exec`) for an absolute-date cutoff using `-newermt`, and confirm the file list matches your expectation before adding `-delete`.
3. Delete the old files first, *then* create your destination subdirectories, and explain out loud why that ordering matters before your next `find` pass runs.
4. Triage by size into two destination folders using `-maxdepth 1`, then triage by permission into a third, and confirm with a final `find -maxdepth 1 -type f` that nothing improperly sorted remains at the top level.
5. Deliberately create one file that would match two different rules (e.g., both small and `777`), run your passes in the documented order, and confirm it lands in the bucket the *first* matching pass claims — not the second.
