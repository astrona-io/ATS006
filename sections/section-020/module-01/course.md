# chmod — Symbolic vs Octal, and the Three Special Bits

Every file and directory on a Linux system carries a small badge of nine permission bits: read, write, and execute, each granted separately to the owner, the owning group, and everyone else. `chmod` is the tool that edits that badge. It sounds simple, and for a single user working alone it is — but the moment more than one person touches the same files, those nine bits (plus three special ones layered on top) become the actual mechanism deciding whether a team collaborates cleanly or steps on each other's work.

Think of a shared office building. Every door has three kinds of people who might want through it: the person whose office it is, their department, and any random visitor off the street. A badge system decides, per door, which of those three groups can open it, walk through it, or leave notes inside. `chmod` is that badge system for files — and just like a building, some doors need special rules beyond "open" or "locked": a supply closet where anything dropped inside should automatically get tagged with the department's name, not the visitor's; a server room only one specific technician's badge should ever open; a shared mailroom where anyone can drop off a package, but nobody except the recipient can take one back out.

## Reading the Badge: `ls -l` and the Nine Bits

Run `ls -l` on any file and the first column looks something like `-rwxr-xr--`. Ignore the leading character for a moment (it says whether this is a file, `-`, or a directory, `d`) and look at the remaining nine characters in three groups of three:

```
rwx r-x r--
 u   g   o
```

Each group is *owner* (`u`), *group* (`g`), and *other* (`o`) — read (`r`), write (`w`), execute (`x`), in that fixed order, with a dash meaning "not granted." `rwxr-xr--` means the owner can read/write/execute, the group can read/execute but not write, and everyone else can only read.

## Two Notations, One Meaning: Symbolic and Octal

`chmod` accepts two completely different-looking ways to describe the exact same permission state, and fluent administrators convert between them without reaching for a calculator.

**Symbolic notation** names *who* (`u`, `g`, `o`, or `a` for all three) and an operator (`+` to add, `-` to remove, `=` to set exactly), followed by which permissions:

```bash
chmod g+w /srv/projects/launch-team
chmod o-rwx /usr/local/bin/nightly-purge.sh
chmod u=rwx,g=rx,o= /srv/projects/launch-team
```

**Octal notation** collapses each three-bit group into a single digit by adding up read (`4`), write (`2`), and execute (`1`) for that group. `rwx` is `4+2+1=7`. `r-x` is `4+0+1=5`. `r--` is `4`. `---` is `0`. So `rwxr-xr--` becomes octal `754` — one digit per group, always in owner-group-other order.

The conversion runs both ways just as easily. Given `750`, split it into `7`, `5`, `0`: owner gets `rwx` (full access), group gets `r-x` (read and enter, no write), other gets nothing at all. On a directory specifically, that execute bit is what lets someone `cd` into it or list files by name inside it — without execute, `r--` on a directory lets you see filenames exist but not open or enter them.

```bash
chmod 750 /srv/projects/launch-team
```

Exam-style tasks almost never hand you the octal number directly — they describe the desired *behavior* ("the group should be able to read and enter, but not modify anything") and expect you to derive `750` yourself. Practicing the arithmetic until it's automatic is worth far more than memorizing a table of common modes.

## The Fourth Digit: Special Bits

Beyond the standard nine bits, three more govern special behavior, and they live in an optional *fourth* digit prepended to the usual three — the digit easiest to forget precisely because three-digit modes are so much more common in everyday use.

### Setuid (`4000`) — Run as the Owner

Placed on an executable file, setuid means: when anyone runs this program, it executes with the *file owner's* privileges, not the privileges of whoever launched it. This is how `passwd` lets an ordinary user change their own password even though the password database is only writable by root — `passwd` runs as root for the duration of that one operation, then hands control back. You'll see it as an `s` in the owner's execute slot: `-rwsr-xr-x`.

### Setgid (`2000`) — Two Different Jobs Depending on What It's On

Setgid means something different depending on whether it's set on a *file* or a *directory*, and mixing these up is one of the most common points of confusion.

On an **executable file**, setgid works like setuid but for the group: the program runs with the file's group privileges rather than the invoking user's group.

On a **directory**, setgid means something entirely different and far more relevant to everyday teamwork: any new file or subdirectory created inside automatically inherits the *directory's* group, instead of the creating user's own primary group. Picture a shared supply closet for a whole department — anything anyone drops off gets automatically labeled with the department's name, not the individual employee's name. Without setgid, every teammate's uploads scatter across their own personal group, and nobody else on the team can access files a colleague created using only their group membership.

```bash
sudo chown root:launch-team /srv/projects/launch-team
sudo chmod 2770 /srv/projects/launch-team
```

`2770` is setgid (`2000`) plus `770` (owner and group get full `rwx`, other gets nothing). From this point forward, anything any `launch-team` member creates inside that directory belongs to group `launch-team` automatically — no one has to remember to `chgrp` it afterward. One important caveat: setgid only affects entries created *after* the bit is applied. It does not retroactively relabel files that already existed in the directory, and a subdirectory created before the parent had setgid won't itself inherit the behavior unless setgid is applied to it directly too.

### Sticky (`1000`) — Protect Files in a Shared Writable Space

Ordinary write access to a directory is an all-or-nothing proposition: if you can write into a directory at all, you can delete or rename *any* file inside it, regardless of who owns that particular file — because unlinking an entry is a directory-level operation, not a file-level one. That's a problem the instant a directory needs to be writable by everyone, like a shared mailroom where any employee can drop off a package for someone else. Without an extra safeguard, any employee could also just as easily walk off with someone else's package.

The sticky bit closes that gap: on a directory, it restricts *deletion* specifically to a file's own owner (or root, or the directory's owner), even while the directory itself remains fully writable by everyone.

```bash
sudo mkdir -p /srv/uploads/public-drop
sudo chmod 1777 /srv/uploads/public-drop
```

`1777` is sticky (`1000`) plus `777` (everyone gets full `rwx`). This exact pattern is what `/tmp` itself uses system-wide — run `ls -ld /tmp` on any Linux machine and you'll see `drwxrwxrwt`. That trailing `t` (lowercase) means sticky *and* other-execute are both set, which is the normal, expected combination; an uppercase `T` would mean sticky is set but other-execute is missing — unusual, and worth investigating if you ever see it.

Special bits stack by simple addition if more than one applies (`4000 + 2000 + 1000 = 7000` would set all three at once, though that combination is rare in practice), and each has its own symbolic letter — `s` for setuid/setgid, `t` for sticky — set with `chmod u+s`, `chmod g+s`, or `chmod +t` respectively.

## Recursive chmod and the Capital-`X` Trap

`chmod -R` applies a mode to an entire directory tree at once, but a blanket numeric mode applied recursively treats every file and directory identically — including granting execute permission to plain data files that never needed it. A directory tree with a mix of shell scripts and plain text files, recursively `chmod -R 755`'d, comes out with every text file suddenly "executable," which is almost always a mistake nobody intended.

The fix is the capital `X` permission, which only grants execute to entries that are directories, or to files that *already* had execute set for someone:

```bash
chmod -R u+rwX,g+rX,o+rX /srv/projects/launch-team
```

This walks the whole tree, ensures every directory remains traversable and every already-executable file stays executable, but never flips execute on for a plain data file that never had it. Whenever a tree contains both files and directories, prefer this pattern over a blanket recursive numeric mode.

## Self-Check and Verification

To prove you can move fluently between symbolic and octal notation and apply all three special bits correctly:

1. Create a test directory and a test group, then set the group as its owner and apply `2770` to it. Confirm with `stat -c '%a %A' <dir>` that the mode reads `2770 drwxrws---`.
2. As one member of that group, create a file inside the directory. Check the file's group ownership with `stat -c '%G' <file>` and confirm it shows the *directory's* group, not that user's own primary group.
3. Create a small script file, apply `chmod 700` to it, and verify with `stat -c '%a %A'` that it now reads `700 -rwx------` — accessible only to its owner.
4. Create a second test directory, apply `chmod 1777` to it, and confirm the sticky bit appears as a lowercase `t` in `ls -ld`'s output (`drwxrwxrwt`), not an uppercase `T`.
5. Build a small directory tree containing both a shell script and a plain text file. Run `chmod -R u+rwX,g+rX,o+rX` on it and confirm only the script ends up executable — the text file should not.
