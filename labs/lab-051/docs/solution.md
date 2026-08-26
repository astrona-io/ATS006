# Solution Guide: Archive Conversion & Verification

This guide converts `import001.tar.bz2` to a maximally-compressed gzip archive and proves the two archives hold identical content.

---

## Step 1: Inspect the source archive

```bash
ls -lh /imports/import001.tar.bz2
```

Note the size before touching anything — a quick baseline in case anything looks off later.

---

## Step 2: List the bzip2 archive's contents, sorted

```bash
tar -tjf /imports/import001.tar.bz2 | sort > /imports/import001.tar.bz2_list
```

`-t` lists the archive's index without extracting anything. `sort` gives a deterministic ordering so this listing can be compared against the new archive's listing later.

---

## Step 3: Extract into a disposable staging directory

```bash
mkdir -p /tmp/import001-extract
tar -xjf /imports/import001.tar.bz2 -C /tmp/import001-extract
```

`-C` redirects the extraction into the staging directory only — the original archive in `/imports` is only ever opened for reading, never for writing.

---

## Step 4: Re-archive as gzip at maximum compression

```bash
cd /tmp/import001-extract
tar --use-compress-program="gzip -9" -cf /imports/import001.tar.gz .
```

`tar -czf` alone would silently use gzip's *default* level (6), not the best level. `--use-compress-program="gzip -9"` bypasses that shortcut and passes `-9` through explicitly. Archiving `.` from inside the staging directory keeps the new archive's internal paths structured the same way the original's were.

---

## Step 5: List the new gzip archive's contents, sorted

```bash
tar -tzf /imports/import001.tar.gz | sort > /imports/import001.tar.gz_list
```

---

## Step 6: Clean up the staging directory

```bash
rm -rf /tmp/import001-extract
```

---

## Verification

```bash
diff /imports/import001.tar.bz2_list /imports/import001.tar.gz_list
# (no output — same content in both archives)

file /imports/import001.tar.gz
# gzip compressed data

ls -la /imports/import001.tar.bz2
# unchanged size/mtime from Step 1
```

> **Note:** Don't rely on `GZIP=-9 tar -czf ...` alone as your only method — newer gzip releases deprecate that environment variable, and `--use-compress-program` is the more durable, version-independent way to force a compression level through `tar`.
