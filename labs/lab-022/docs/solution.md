# Solution Walkthrough

This walkthrough reads the current `umask`, predicts its result and checks it, then makes a new mask last for every login of `candidate`. The `umask` is the default lock setting on every new file: the kernel switches the mask's bits off the starting mode, `666` for a file and `777` for a directory.

`sudo -iu candidate` starts a fresh login shell for `candidate`, the same way the grader does, so every check below sees what a new login sees.

---

## Step 1: Read the current mask and predict

```bash
sudo -iu candidate umask
sudo -iu candidate umask -S
```

Plain `umask` prints the current mask in octal: the bits that get switched off. `umask -S` prints the permissions you get, in symbolic form.

Write your prediction down. For a mask of `022`, for example: file `666 - 022 = 644`, directory `777 - 022 = 755`. Use the number your machine printed, not this example.

---

## Step 2: Check the prediction against reality

```bash
sudo -iu candidate bash -lc 'touch ~/predict-file; mkdir ~/predict-dir; stat -c "%a %n" ~/predict-file ~/predict-dir'
```

`stat` prints each mode followed by its path. Confirm that both numbers match your prediction from Step 1.

---

## Step 3: Set the new mask persistently for `candidate`

Check the math before you write anything. With mask `027`, the file base gives `666 - 027 = 640`: the mask's last digit `7` switches off every bit of the file's `6`, leaving `0`. The directory base gives `777 - 027 = 750`. Both match the requirement. `umask` takes the mask, not the result, so you write `027`, never `640` or `750`.

The lab already has an empty `/home/candidate/.bash_profile`, which a login shell reads at every login. Add the line to it:

```bash
echo 'umask 027' | sudo tee -a /home/candidate/.bash_profile
sudo chown candidate:candidate /home/candidate/.bash_profile
```

```text
umask 027
```

`tee` repeats the line it appended. The `chown` keeps the file owned by `candidate`.

---

## Step 4: Prove it in a fresh login

```bash
sudo -iu candidate bash -lc 'umask; touch ~/verify-file; mkdir ~/verify-dir; stat -c "%a %n" ~/verify-file ~/verify-dir'
```

```text
0027
640 /home/candidate/verify-file
750 /home/candidate/verify-dir
```

The fresh login read `~/.bash_profile` and got the mask `0027`. The new file came out `640` and the new directory `750`, with no `chmod` at any point.

A `umask` typed straight at a prompt only affects that one session. It has to live in a login startup file (`~/.bash_profile` or `~/.profile`) to survive future logins.

---

## Step 5: Submit

Leave the lab machine and send the mission for grading:

```bash
astrona submit -c labs/lab-022
```
