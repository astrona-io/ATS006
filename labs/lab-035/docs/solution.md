# Solution Walkthrough

Look up two facts in the manual pages, and edit the flight plan in a text editor. Work through the steps in order, and check the result after each one.

---

## Step 1: Find the two facts in the manual pages

`man -k passwd` searches the one-line descriptions of all pages. The number in brackets is the manual section. Section 1 holds commands and section 5 holds file formats. For `ls`, search inside the page: open `man ls`, press `/` and type `modification`, then press Enter.

```sh
man -k passwd
man 5 passwd
man ls
```

In `man -k passwd`, find the line that says `passwd (5)`. In `man ls`, read the entry for the option that sorts by modification time. Press `q` to leave a page.

---

## Step 2: Write the answers file

Write exactly the two lines the question asks for, with the numbers and options you found.

Save this as `/home/candidate/answers.txt`:

```text
passwd-file-section=5
ls-sort-by-time=-t
```

Then check the result:

```sh
cat /home/candidate/answers.txt
```

---

## Step 3: Edit the flight plan in vim

In `vim`, `:%s/PLACEHOLDER/TBD/g` replaces every match in the whole file. `dd` deletes the line the cursor is on. `G` jumps to the last line, `o` opens a new line below it, and `Esc` returns to normal mode. `:wq` saves and quits.

```sh
vim /home/candidate/flightplan.conf
```

Inside `vim`: type `:%s/PLACEHOLDER/TBD/g` and press Enter. Type `:%s/checked=no/checked=yes/` and press Enter. Press `gg` and then `dd` to delete the comment line. Press `G`, then `o`, type `launch=ready`, press `Esc`, and type `:wq` with Enter.

Then check the result:

```sh
cat /home/candidate/flightplan.conf
```

```text
destination=TBD
crew_size=4
fuel=TBD
route=TBD
checked=yes
launch=ready
```

---

## Step 4: Submit

Leave the lab machine and send the mission for grading:

```bash
astrona submit -c labs/lab-035
```
