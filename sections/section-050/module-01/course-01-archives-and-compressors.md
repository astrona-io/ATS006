# Archives And Compressors

Astronaut, an archive and a compression format are two separate ideas. `tar` lets you use both in one command, and mixing them up is where most mistakes in this topic start. This part pulls them apart, shows you how to force the strongest gzip compression, and shows you how to look inside an archive without unpacking it.

## Two jobs, two programs

A `tar` archive is a sealed shipping container: many crates (files) and compartments (directories) packed into one file. The container keeps their names, permissions and structure. Compression is vacuum-packing that container so it takes less room on the shelf.

The two jobs are done by different programs:

- **The archive.** `tar` does the bundling. It turns a whole directory tree into one stream of bytes.
- **The compression.** `tar` does not compress anything itself. It hands the finished stream to an outside compressor program (`gzip`, `bzip2` or `xz`), and that program does the squeezing.

Building the container and deciding what goes inside is one job. Vacuum-packing it afterwards is a different job, done by different equipment. You can swap the vacuum-packer for another model without repacking the crates.

## The compression flags call an outside program

The short compression flags of `tar` are just a way to pick which compressor the stream goes through. Here is a real example of each direction.

### Create one archive and unpack another

This command creates a gzip-compressed archive, and the second one unpacks a bzip2-compressed archive into `/tmp/restore`:

```bash
tar -czf backup.tar.gz /var/log/myapp
tar -xjf legacy-export.tar.bz2 -C /tmp/restore
```

When you run `tar -czf out.tar.gz files/`, `tar` builds the archive stream, then pipes it straight into `gzip` before it writes the result to disk. The flags mean:

| Flag | Compressor that `tar` pipes through |
| --- | --- |
| `-z` | `gzip` |
| `-j` | `bzip2` |
| `-J` | `xz` |

You can use only one of them per command, for a simple reason: you choose one compressor program to pipe through, not several.

When you only *read* an existing archive (`-x` to extract or `-t` to list), modern GNU `tar` can usually detect the compression format by itself. It reads the first bytes of the file, a signature called the magic bytes. So `-j` versus `-z` matters most when you *create* a new archive. That is the one place where you actively choose a format.

## Best compression needs a different flag

This is the trap that catches almost everyone the first time. `tar -czf` gives you no control over how hard `gzip` squeezes.

The `-z` shortcut starts `gzip` with its default settings: compression level 6, a middle ground that `gzip` picked. If a task asks for "the strongest possible compression", `-z` alone silently ignores that request. The archive is still created, and nothing tells you anything went wrong.

### Force level 9 through `tar`

The `gzip` levels run from `-1` (fastest, largest file) to `-9` (slowest, smallest file). `tar -z` has no way to pass that flag through. The portable way is `--use-compress-program`, which tells `tar` to run an exact compressor command instead of its built-in shortcut:

```bash
tar --use-compress-program="gzip -9" -cf export-max.tar.gz /srv/reports
```

This skips `-z` completely. `tar` now pipes its stream through the command `gzip -9`, flags and all.

You will sometimes see the `GZIP` environment variable used instead (`GZIP=-9 tar -czf ...`). Older `gzip` versions read default options from it. Newer `gzip` releases deprecate that variable in favour of `GZIP_OPT`, so it is a less durable habit. `--use-compress-program` works whichever `gzip` version is installed. That matters, because you do not get to choose the software versions on the machine in front of you.

### Read the level back from the gzip header

You can prove which level was used after the fact. `gzip` writes a small header at the start of every file. Byte number 8 of that header is the "extra flags" byte:

| Extra flags value | Meaning |
| --- | --- |
| `2` | Compressed at level 9 (maximum) |
| `4` | Compressed at level 1 (fastest) |
| `0` | Anything in between, including the untouched default of 6 |

This command prints that one byte as a number:

```bash
od -An -tu1 -j8 -N1 export-max.tar.gz
```

`od` (octal dump) prints raw bytes. `-j8` skips the first 8 bytes, `-N1` reads one byte, and `-tu1` prints it as a plain number. If you see `2`, level 9 was really used, not just claimed.

## Look inside without unpacking

Before you trust any archive (one you just built, one you inherited, one you are about to replace something with), look at what is inside it. You can do this without unpacking a single byte.

### List an archive

```bash
tar -tf export-max.tar.gz
```

`-t` is a full operating mode of its own, separate from `-x` (extract). `tar` reads the archive's index and prints every entry's path. Nothing is written to disk.

Listing is close to free, so there is no reason to skip it. Run it on a fresh export before you ship it anywhere. Run it again on the receiving side after a transfer, to confirm nothing was cut short.

### Practise on your own

Build a small test archive so you have something real to inspect. The steps below use only names you create yourself:

1. Create a small directory called `sample` with a few test files in it, and archive it with bzip2: `tar -cjf sample.tar.bz2 sample/`.
2. List its contents without extracting anything, sorted, into a listing file: `tar -tjf sample.tar.bz2 | sort > sample.bz2.listing`.
3. Create a level 9 gzip archive of the same directory with `--use-compress-program="gzip -9"`, and read its extra flags byte with the `od` command above. It should be `2`.
4. Create a second gzip archive with plain `tar -czf` and read its extra flags byte. It should be `0`, because `-z` used the default level 6.

> [!TIP]
> When a task says "best" or "maximum" compression, reach for `--use-compress-program="gzip -9"` straight away, and check the header byte afterwards. A clean exit from `tar -czf` proves nothing about the level.

## Common pitfalls

> [!WARNING]
> - **Using `tar -czf` for "best compression".** `-z` always runs `gzip` at its default level 6. Use `--use-compress-program="gzip -9"`.
> - **Trying to combine `-z` and `-j`.** One command pipes through one compressor. Pick one.
> - **Relying on `GZIP=-9`.** Newer `gzip` releases deprecate that variable. `--use-compress-program` works on every version.
> - **Trusting an archive you have never listed.** `tar -tf` costs nothing and shows exactly what is inside.
> - **Thinking `tar` does the compression.** `tar` only bundles. The outside compressor program does the squeezing.
