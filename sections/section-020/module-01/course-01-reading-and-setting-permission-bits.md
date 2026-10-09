# Reading And Setting Permission Bits

Astronaut, before you can change a crate's lock badge, you must be able to read it. A file is a crate in the cargo hold, and a directory is a compartment that holds crates. This part shows you the nine permission bits that every file and directory carries, the two ways `chmod` lets you write them, and how to change a whole tree of files safely.

Who does the work here? The kernel, the ship's core, stores the permission bits with each file and checks them every time a program tries to open, change or run the file. `chmod` only asks the kernel to store new bits.

## Reading the badge: `ls -l` and the nine bits

Run `ls -l` on any file and the first column looks something like `-rwxr-xr--`. This section shows how to split that string into its parts.

### The three groups of three

Ignore the leading character for a moment. It says whether this is a file (`-`) or a directory (`d`). Look at the remaining nine characters in three groups of three:

```
rwx r-x r--
 u   g   o
```

The groups are always in the same order:

- **`u` (user):** the owner of the file.
- **`g` (group):** the members of the file's group, the owner's team.
- **`o` (other):** everyone else aboard.

Inside each group, the letters are always read (`r`), write (`w`) and execute (`x`), in that fixed order. A dash means "not granted". So `rwxr-xr--` means the owner can read, write and execute. The group can read and execute, but not write. Everyone else can only read.

### What the bits mean on a directory

On a plain file, `r` means look inside, `w` means change the contents, and `x` means run it as a program. On a directory, the same letters have a slightly different job:

- **`r`** lets you list the names of the files inside.
- **`w`** lets you create, delete and rename entries inside.
- **`x`** lets you enter the directory with `cd` and open files inside it by name.

Without `x`, `r--` on a directory lets you see that file names exist, but you cannot open or enter them. That is why directories almost always have `x` wherever they have `r`.

## Two notations, one meaning: symbolic and octal

`chmod` accepts two very different-looking ways to describe exactly the same permissions. Fluent administrators switch between them without a calculator, and this section shows you how.

### Symbolic notation

Symbolic notation names **who** (`u`, `g`, `o`, or `a` for all three), then an **operator**, then the **permissions**. The operator is `+` to add, `-` to remove, or `=` to set exactly:

```bash
chmod g+w /srv/projects/launch-team
chmod o-rwx /usr/local/bin/nightly-purge.sh
chmod u=rwx,g=rx,o= /srv/projects/launch-team
```

The first line adds write for the group. The second removes every permission from everyone else. The third sets all three groups exactly: full access for the owner, read and enter for the group, nothing for anyone else. Symbolic notation is handy when you want to change one bit and leave the rest alone.

### Octal notation

Octal notation squeezes each group of three bits into one digit. You add up read (`4`), write (`2`) and execute (`1`) for that group:

| Bits | Sum | Digit |
| --- | --- | --- |
| `rwx` | 4 + 2 + 1 | `7` |
| `rw-` | 4 + 2 + 0 | `6` |
| `r-x` | 4 + 0 + 1 | `5` |
| `r--` | 4 + 0 + 0 | `4` |
| `---` | 0 + 0 + 0 | `0` |

So `rwxr-xr--` becomes octal `754`: one digit per group, always in owner, group, other order.

The conversion works just as easily the other way. Given `750`, split it into `7`, `5` and `0`. The owner gets `rwx` (full access). The group gets `r-x` (read and enter, but no write). Everyone else gets nothing at all.

```bash
chmod 750 /srv/projects/launch-team
```

Octal notation sets all nine bits at once. It is the quickest way to reach an exact state.

### Try it: set and read a mode

Create a test file, give it a mode, and read the mode back with `stat`. `stat -c '%a %A'` prints the octal mode and the same mode as letters:

```bash
touch /tmp/badge-test
chmod 754 /tmp/badge-test
stat -c '%a %A' /tmp/badge-test
```

```text
754 -rwxr-xr--
```

The octal `754` and the letters `rwxr-xr--` are the same badge written two ways. Now set the same thing in symbolic notation and check that nothing changes:

```bash
chmod u=rwx,g=rx,o=r /tmp/badge-test
stat -c '%a %A' /tmp/badge-test
```

```text
754 -rwxr-xr--
```

### From a requirement to a number

Exam-style tasks almost never hand you the octal number. They describe the behaviour you want, for example "the group should be able to read and enter, but not change anything", and expect you to work out `750` yourself.

Work it out one group at a time: what does the owner need, what does the group need, what does everyone else need? Turn each answer into a digit. Practising this until it is automatic is worth far more than learning a table of common modes by heart.

> [!TIP]
> Before you type an octal mode, say the three groups out loud: "owner seven, group five, other zero". It catches a swapped digit before the kernel stores it.

## Recursive chmod and the capital `X` trap

`chmod -R` (recursive) applies a mode to a whole directory tree at once. That is useful, but a plain number applied to every entry treats files and directories the same. This section shows the problem and the fix.

### The problem with a blanket number

Picture a tree with some shell scripts and some plain text files. If you run `chmod -R 755` on it, every text file suddenly becomes "executable". Nobody meant that. Directories need `x` so people can enter them, but plain data files do not.

### The fix: capital `X`

Capital `X` grants execute only to entries that are directories, or to files that already have execute set for someone:

```bash
chmod -R u+rwX,g+rX,o+rX /srv/projects/launch-team
```

This walks the whole tree. Every directory stays enterable, and every file that was already executable stays executable. A plain data file that never had execute does not get it. Whenever a tree holds both files and directories, prefer this pattern over a blanket number.

### Try it: capital `X` on a mixed tree

Build a small tree with one plain text file and one script. Give the text file no execute bit, and the script execute for its owner only:

```bash
mkdir -p /tmp/cargo-demo/scripts
touch /tmp/cargo-demo/notes.txt /tmp/cargo-demo/scripts/launch.sh
chmod 600 /tmp/cargo-demo/notes.txt
chmod 700 /tmp/cargo-demo/scripts/launch.sh
```

Now apply the capital `X` pattern to the whole tree and check both files:

```bash
chmod -R u+rwX,g+rX,o+rX /tmp/cargo-demo
stat -c '%a %n' /tmp/cargo-demo/notes.txt /tmp/cargo-demo/scripts/launch.sh
```

```text
644 /tmp/cargo-demo/notes.txt
755 /tmp/cargo-demo/scripts/launch.sh
```

The text file gained read for the group and for others, but no execute bit. The script already had execute for its owner, so capital `X` also gave execute to the group and to others.

## Common pitfalls

> [!WARNING]
> - **Reading the groups in the wrong order.** It is always owner, group, other. `750` gives the group `5`, not the owner.
> - **Forgetting `x` on a directory.** Without `x`, people cannot enter the directory or open files in it, even with `r`.
> - **Using `chmod -R 755` on a mixed tree.** Every plain file becomes executable. Use `u+rwX,g+rX,o+rX` instead.
> - **Using `=` when you meant `+`.** `chmod g=r` removes the group's write and execute bits. `chmod g+r` only adds read.
> - **Typing a requirement's words straight into a number.** Work out each group's digit first: owner, then group, then other.
