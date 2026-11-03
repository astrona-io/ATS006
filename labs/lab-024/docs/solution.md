# Solution Walkthrough

Create, copy, move, link and remove files with the right options, and hand a compartment to the right team. Work through the steps in order, and check the result after each one.

---

## Step 1: Build the tree and copy the manifest

`mkdir -p` creates every missing parent folder in one command. Plain `cp` gives the copy a new time stamp and applies your `umask` to the mode. `cp -p` keeps the mode and the time of the original.

```sh
cd /home/candidate/cargo
mkdir -p archive/2026/q1
cp -p manifest.txt archive/2026/q1/
ls -l manifest.txt archive/2026/q1/manifest.txt
```

Both lines of the listing show the same mode and the same modification time.

---

## Step 2: Move the old file and make both links

`mv` renames a file, so the old name is gone. `ln` makes a hard link, a second name for the same inode. `ln -s` makes a symbolic link, a small file that holds a path. Write the target as `crew.txt`, with no folder in front, so the link keeps working if the whole folder moves.

```sh
cd /home/candidate/cargo
mv old-crew.txt archive/2026/
ln crew.txt crew-hard.txt
ln -s crew.txt crew-soft.txt
ls -li crew.txt crew-hard.txt crew-soft.txt
```

`crew.txt` and `crew-hard.txt` show the same inode number in the first column. `crew-soft.txt` shows its own inode and an arrow to `crew.txt`.

---

## Step 3: Remove the scratch folder and change the group

`rm -r` removes a folder and everything inside it. `chgrp -R` changes the group of a whole tree. You are not the owner of the group `loaders`, so use `sudo` for `chgrp`.

```sh
cd /home/candidate/cargo
rm -r scratch
sudo chgrp -R loaders crates
ls -ld crates
ls -l crates
```

The group column of `crates` and of both files in it now reads `loaders`. The owner column still reads `candidate`.

---

## Step 4: Submit

Leave the lab machine and send the mission for grading:

```bash
astrona submit -c labs/lab-024
```
