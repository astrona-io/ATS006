# Hard Links And Symbolic Links

Astronaut, sometimes one crate needs two labels so two crew members can find it. Linux has two ways to do this, and they behave very differently when someone throws the first label away. This part shows both, and how to tell them apart with one command.

## What a file really is

A file name is only a label. The crate itself is described by a manifest card called an **inode**. The inode holds the owner, the mode, the size, the time stamps and where the data lives on disk. A directory entry is a label that points to one manifest card. The number of labels that point to a card is its **link count**.

Two commands show this. `ls -i` prints the inode number, and `stat` prints the link count:

<!-- astrona:playground:renew -->

```sh
cd ~/cargo
echo "hello" > note-a.txt
ls -i note-a.txt
stat -c 'inode=%i links=%h name=%n' note-a.txt
```

The second command prints the inode number, then `links=1`, then the name. One label points at the card.

## A hard link: a second label on the same crate

A **hard link** is a second label on the same manifest card. Make one with `ln` and look at both names:

```sh
ln note-a.txt note-b.txt
stat -c 'inode=%i links=%h name=%n' note-a.txt note-b.txt
```

Both lines show the same inode number and `links=2`. There is only one crate and two labels. A change through one name shows through the other:

```sh
echo "more" >> note-b.txt
cat note-a.txt
```

The output is `hello` followed by `more`. When you remove one label with `rm note-a.txt`, the crate stays, because `note-b.txt` still points at the card. The data is freed only when the link count reaches `0`.

A hard link has two limits. It cannot point at a folder, and it cannot cross from one filesystem (cargo deck) to another, because an inode number only means something on its own deck.

## A symbolic link: a note that holds a path

A **symbolic link** (also called a symlink or soft link) is a different kind of file. It has its own inode, and its contents are only the path of another file. It is a signpost that says "the crate is over there". Make one with `ln -s`:

```sh
ln -s note-b.txt note-sign.txt
ls -li note-b.txt note-sign.txt
readlink note-sign.txt
```

`ls -l` shows `note-sign.txt -> note-b.txt` and the file type letter `l` at the start of the mode. The inode numbers differ, because the signpost is its own file. `readlink` prints the stored path, `note-b.txt`.

### Write the target as a relative path

The target is stored exactly as you typed it. `ln -s note-b.txt note-sign.txt` stores a path that is relative to the folder of the link, so the pair keeps working if you move the whole folder. A target such as `/home/candidate/cargo/note-b.txt` stops working as soon as the folder moves.

### A signpost can point at nothing

Remove the target and read the signpost:

```sh
rm note-b.txt
ls -l note-sign.txt
cat note-sign.txt
```

The listing still shows the arrow, but `cat` fails with `No such file or directory`. The link is **dangling**: the signpost stays, and the place it points at is empty. A symbolic link can point at a folder and across filesystems, which a hard link cannot.

## Choosing between them

| | Hard link | Symbolic link |
| --- | --- | --- |
| What it is | A second label on the same inode | A small file that holds a path |
| Survives removal of the original | Yes | No, it dangles |
| Can point at a folder | No | Yes |
| Can cross filesystems | No | Yes |
| Shows in `ls -l` as | A normal file | `l` and an arrow |

Use a symbolic link for most jobs, such as `current -> release-42`. Use a hard link when you want two names that stay equal and cannot dangle.

## Common pitfalls

> [!WARNING]
> - **Mixing up the order.** `ln TARGET LINK_NAME`: the existing file comes first, the new label second.
> - **Writing the target relative to the wrong place.** A relative target is read from the folder that holds the link, not from the folder where you typed the command.
> - **Expecting a hard link to a folder or across filesystems.** Both fail. Use `ln -s` instead.
> - **Treating a hard link as a backup.** Both names are the same data. A change or a removal of the data shows through every name.
