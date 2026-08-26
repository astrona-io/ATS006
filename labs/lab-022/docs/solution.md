# Solution Guide: umask Default Permissions

This guide shows the umask math and how to persist a new mask for one user.

---

## Step 1: Read and predict from the current umask

```bash
sudo -iu candidate umask
sudo -iu candidate umask -S
```

Plain `umask` prints the current mask in octal. Given whatever value this shows (commonly `022`), predict on paper: file `666 - 022 = 644`, directory `777 - 022 = 755`.

## Step 2: Verify the prediction against reality

```bash
sudo -iu candidate bash -lc 'touch ~/predict-file; mkdir ~/predict-dir; stat -c "%a %n" ~/predict-file ~/predict-dir'
```

Confirm the actual modes match the Step 1 prediction.

## Step 3: Set the new mask persistently for `candidate`

```bash
echo 'umask 027' | sudo tee -a /home/candidate/.bash_profile
sudo chown candidate:candidate /home/candidate/.bash_profile
```

Check the math before writing anything: file base `666 - 027 = 640` and directory base `777 - 027 = 750` — exactly matching the requirement. `umask` takes the *mask*, not the desired result, so `027` (not `640`/`750`) is what gets written.

## Step 4: Apply and verify in a fresh login context

```bash
sudo -iu candidate bash -lc 'umask; touch ~/verify-file; mkdir ~/verify-dir; stat -c "%a %n" ~/verify-file ~/verify-dir'
```

`sudo -iu candidate` starts a fresh login shell for `candidate`, which reads `~/.bash_profile` exactly the way a new login session would. Expect `640` for the file and `750` for the directory, with no `chmod` involved at any point.

> **Note:** A `umask` typed directly at an interactive prompt only affects that one session — it must live in a login shell startup file (`~/.bash_profile` or `~/.profile`) to survive future logins.
