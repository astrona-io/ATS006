# LFCS Essential Commands Domain Certification Quiz

Welcome to the Final Domain Certification Quiz for the **LFCS Essential Commands** curriculum. This comprehensive test contains **20 high-signal, scenario-based system administration questions** covering all 18 modules inside our 7 Essential Commands sections.

To simulate actual Linux Foundation exam pressure:
*   Answer all 20 questions without consulting external documentation or manual shell helpers.
*   Allow yourself a maximum of **30 minutes** to complete the entire test.
*   Once finished, scroll to the very bottom to check the **Audit and Review Key** to trace any incorrect answers back to their exact section and module chapters.

---

## The Exam Simulator

### Question 1
You run a script as `./deploy.sh > /var/log/deploy.log`, but when it fails you find the log file is empty even though the terminal printed several error lines. What is the most likely explanation?
*   **A)** `>` only ever captures the last line of output.
*   **B)** The script's error lines were written to stderr (file descriptor 2), which `>` alone does not redirect — only stdout (file descriptor 1) was sent to the file.
*   **C)** The log file needs `sudo` to be written to correctly.
*   **D)** `deploy.sh` must be run with `bash -x` to enable logging.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** A bare `>` redirects only file descriptor 1 (stdout). Diagnostic and error output is conventionally written to file descriptor 2 (stderr), which remains connected to the terminal unless separately redirected with `2>`, or merged with stdout using `2>&1`.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `>` truncates and captures the entire stdout stream, not just the last line.
    *   *Option C* is incorrect because permission issues would produce a `Permission denied` error, not a silently empty file.
    *   *Option D* is incorrect because `-x` enables execution tracing, it does not change where output streams are sent.
</details>

---

### Question 2
A monitoring script runs `some_check.sh; echo $?` and needs to distinguish between three outcomes: success, a warning, and a hard failure. Which exit-code design is correct LFCS practice?
*   **A)** Always exit `0` and rely on stdout text for the status.
*   **B)** Exit `0` for success, and any non-zero code (e.g. `1` for warning, `2` for hard failure) for the other states, checked immediately via `$?`.
*   **C)** Exit `-1` for warnings and `-2` for hard failures.
*   **D)** Use `exit true` and `exit false` as the two possible states.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** POSIX exit codes are unsigned 8-bit values where `0` means success and any non-zero value signals a distinct failure/warning condition, by convention. `$?` must be read immediately after the command runs, since it is overwritten by the next command executed (including a bare `echo`).
*   **Why others are incorrect:**
    *   *Option A* is incorrect because it defeats the entire purpose of scriptable exit-code checking.
    *   *Option C* is incorrect because shell exit codes cannot be negative; negative values wrap into the 0-255 range.
    *   *Option D* is incorrect because `true`/`false` are commands, not valid arguments to `exit`.
</details>

---

### Question 3
You run `export DB_HOST=db01` in your interactive shell, then run a script with `./check_db.sh`. Inside that script, `echo $DB_HOST` prints nothing. What is the most likely cause?
*   **A)** `export` only affects the current command, not the whole shell session.
*   **B)** The variable was set in a different shell session than the one that launched `check_db.sh`, or `export` was never actually run before the script started.
*   **C)** Scripts can never see any environment variables from their parent shell.
*   **D)** `DB_HOST` needs to be written in all lowercase to be inherited.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `export` marks a variable to be copied into the environment of every child process spawned *after* that point in the same shell. If the export happened in a different terminal/session, or after the script was already running, the child process never receives it.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `export` persists for the life of the shell session, not just one command.
    *   *Option C* is incorrect because exported variables are precisely how parent shells share configuration with child processes.
    *   *Option D* is incorrect because shell variable name casing is a style convention, not a functional requirement for inheritance.
</details>

---

### Question 4
You need every new file created inside `/srv/shared-team` by any user to automatically get group-write permission and to always inherit the directory's owning group, not the creating user's primary group. Which two mechanisms, working together, achieve this?
*   **A)** `umask 022` plus `chmod +x` on the directory.
*   **B)** A `umask` value that does not strip the group-write bit, plus the `setgid` bit (`chmod g+s`) on the directory.
*   **C)** `chattr +i` on the directory.
*   **D)** `chown -R` run after every file is created.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `umask` controls which permission bits are *subtracted* from a new file's default mode — a umask like `002` leaves group-write intact. The `setgid` bit on a directory (`g+s`) makes every new file/subdirectory created inside it inherit the parent directory's group ownership instead of the creating process's primary group. Neither mechanism alone solves both requirements.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `022` strips group-write, and `+x` on a directory only controls traversal, not group inheritance.
    *   *Option C* is incorrect because the immutable attribute prevents any modification at all, including normal file creation.
    *   *Option D* is incorrect because it is a manual, error-prone after-the-fact fix, not a systemic default.
</details>

---

### Question 5
You need to find every file under `/var/backup/archive` that is smaller than 3 KiB and move each one into `/var/backup/archive/small/` in a single pass, without leaving the newly-created `small/` directory to be re-scanned by the same command. Which invocation is correct?
*   **A)** `find /var/backup/archive -size -3k -exec mv {} /var/backup/archive/small/ \;`
*   **B)** `find /var/backup/archive -maxdepth 1 -type f -size -3k -exec mv {} /var/backup/archive/small/ \;`
*   **C)** `find /var/backup/archive -size 3k -delete`
*   **D)** `find /var/backup/archive -perm -3k -exec mv {} small \;`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `-maxdepth 1` keeps the scan from recursing into the destination directory once it exists, `-type f` excludes directory entries, and `-size -3k` matches files strictly under 3 KiB (`find`'s `k` suffix is 1024-byte blocks).
*   **Why others are incorrect:**
    *   *Option A* is incorrect because without `-maxdepth 1`, once `small/` exists and contains files, subsequent runs would recurse into it and re-move already-sorted files.
    *   *Option C* is incorrect because `-size 3k` means exactly 3 KiB, not "smaller than," and `-delete` destroys the files instead of moving them.
    *   *Option D* is incorrect because `-perm` tests permission bits, not file size.
</details>

---

### Question 6
You need to extract every line containing the literal string `ERROR 500` from `/var/log/app.log`, then replace any occurrence of an embedded email address with `[REDACTED]` in the extracted output, without modifying the original log file. Which pipeline is correct?
*   **A)** `sed 's/ERROR 500/[REDACTED]/' /var/log/app.log > out.log`
*   **B)** `grep -F 'ERROR 500' /var/log/app.log | sed -E 's/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/[REDACTED]/g' > out.log`
*   **C)** `grep -F 'ERROR 500' -i /var/log/app.log`
*   **D)** `sed -i 's/@.*//' /var/log/app.log | grep 'ERROR 500'`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `grep -F` treats the search string as a fixed literal (safe against regex metacharacters like the space), filtering only matching lines first. Piping into `sed -E` with an email-matching regex and the global flag `g` redacts every embedded address in the filtered output, writing the result to a new file and leaving the original log untouched.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because it redacts the literal string "ERROR 500" itself, not email addresses, and never filters to matching lines only.
    *   *Option C* is incorrect because it only filters lines; it performs no redaction at all.
    *   *Option D* is incorrect because `-i` edits the original file in place (violating the "don't modify the original" requirement) and the command order is backwards — `sed -i` produces no stdout to pipe into `grep`.
</details>

---

### Question 7
You need to find the exact command you ran three sessions ago that started with `rsync` and included the flag `--link-dest`, but you don't remember any other details. Which is the fastest way to locate it in your shell history?
*   **A)** `history | grep rsync`, then visually scan for the `--link-dest` flag.
*   **B)** Press `Ctrl+R` and type `rsync`, cycling through matches with repeated `Ctrl+R` until the right one appears.
*   **C)** `cat ~/.bash_profile | grep rsync`
*   **D)** Both A and B are reasonable approaches; there is no dedicated history-search-and-filter shortcut for a multi-token pattern in a single step.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: D**

*   **Why D is correct:** Bash's reverse incremental search (`Ctrl+R`) searches interactively but matches on a single substring at a time, and piping `history` through `grep` is the standard non-interactive way to filter for a specific token — neither one natively supports matching two independent substrings (`rsync` AND `--link-dest`) in a single filter step, so a sysadmin reasonably reaches for either depending on habit, or chains `grep` twice (`history | grep rsync | grep -- --link-dest`).
*   **Why others are incorrect:**
    *   *Option A* alone is incomplete because it still requires manual visual scanning for the second detail.
    *   *Option B* alone is incomplete because `Ctrl+R` searching for one term may surface many `rsync` invocations before the right one appears.
    *   *Option C* is incorrect because `.bash_profile` is a login-shell startup file, not a command history log.
</details>

---

### Question 8
You define `alias rm='rm -i'` in your `~/.bashrc` to prevent accidental deletions. A teammate later complains that a cleanup script using `rm -f` inside a cron job is now hanging, prompting for confirmation on every file. What is the correct diagnosis and fix?
*   **A)** Aliases are also expanded inside non-interactive scripts and cron jobs, so the alias intercepted the script's `rm` calls; the fix is to make the alias interactive-shell-only, or have scripts call `\rm` / `/bin/rm` directly.
*   **B)** Cron jobs always run with root's aliases regardless of the user's shell config, so this is unavoidable.
*   **C)** `alias` definitions can never affect scripts; the real cause must be a `sudoers` misconfiguration.
*   **D)** The script must be rewritten to use `unlink` instead of `rm`.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: A**

*   **Why A is correct:** Bash aliases are expanded in any shell that reads the file defining them, interactive or not, if that shell sources `~/.bashrc` (or the alias is otherwise re-declared for non-interactive shells). Scripts that need to bypass a user's aliases should invoke the unaliased binary via a leading backslash (`\rm -f`) or a full path (`/bin/rm -f`), which are both standard, portable ways to sidestep alias expansion.
*   **Why others are incorrect:**
    *   *Option B* is incorrect because cron's non-interactive shells typically do not source `~/.bashrc` at all by default — the more common trigger for this exact symptom is actually running the cleanup interactively or from a wrapper that does source it, but the underlying fix (escape the alias) applies regardless of which shell context caused it.
    *   *Option C* is incorrect because aliases absolutely can affect any shell that has them active.
    *   *Option D* is incorrect because it avoids the root cause entirely instead of fixing the alias-shadowing problem.
</details>

---

### Question 9
You clone a repository and need to check whether a config value exists in branches `dev4`, `dev5`, or `dev6` before deciding which one to merge, without disturbing your currently checked-out branch. Which command lets you read a file's content on another branch with zero risk to your working tree?
*   **A)** `git checkout dev4 -- config.yaml`
*   **B)** `git show dev4:config.yaml`
*   **C)** `git stash && git switch dev4`
*   **D)** `git diff dev4 dev5`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** The `<rev>:<path>` revision syntax lets `git show` print a file's blob content exactly as it exists at the tip of any ref, entirely independent of what is currently checked out — no branch switch, no stash, no working-tree changes of any kind.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because it stages `dev4`'s version of the file into your current working tree, modifying it.
    *   *Option C* is incorrect because it actually switches your checked-out branch, which is exactly what the question asks to avoid.
    *   *Option D* is incorrect because it compares two branches against each other, not a specific file's content against a value you're looking for.
</details>

---

### Question 10
After running `git clone`, you create an empty directory named `logs/` at the top of the repository and immediately run `git add logs && git commit -m "add logs dir"`. Checking `git log --stat` afterward shows no changes were committed. Why?
*   **A)** `git add` silently failed due to insufficient permissions.
*   **B)** Git's object model only tracks blobs (file content) and trees built from them — an empty directory has no content to hash, so there is nothing for Git to record until a file exists inside it.
*   **C)** Directories require `git mkdir` instead of the shell's `mkdir`.
*   **D)** The commit message must not contain the word "logs" since it matches the directory name.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** Git's fundamental storage units are content-addressed blobs and the trees that reference them. A directory with nothing inside it produces no blob and therefore has nothing for Git to track. The conventional workaround is a placeholder file (commonly `.keep` or `.gitkeep`) inside the directory, which gives Git a real blob to commit.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because a permission failure produces an explicit error, not a silent no-op commit.
    *   *Option C* is incorrect because no such command exists; standard `mkdir` is all that's needed.
    *   *Option D* is incorrect because commit messages are free-form text with no such restriction.
</details>

---

### Question 11
You have a local topic branch `feature/retry-limit` based on an older commit of `main`. A teammate has since pushed new commits to `main`. You want your branch's changes to appear as if they were written on top of the *latest* `main`, producing a clean linear history with no merge commit. Which command achieves this?
*   **A)** `git merge main` while on `feature/retry-limit`.
*   **B)** `git rebase main` while on `feature/retry-limit`.
*   **C)** `git cherry-pick main`
*   **D)** `git reset --hard origin/main`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `git rebase main` replays your branch's commits one by one on top of the current tip of `main`, producing a linear history with no merge commit — exactly the "as if written on the latest main" outcome described.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because a merge preserves both histories and creates a merge commit, which is not a linear result.
    *   *Option C* is incorrect because `cherry-pick` takes specific commit hashes, not a branch name, as its normal usage.
    *   *Option D* is incorrect because it destructively discards your branch's own commits entirely, replacing them with `main`'s state.
</details>

---

### Question 12
You need to convert `/data/import001.tar.bz2` into a new archive `/data/import001.tar.gz` using the strongest gzip compression level, without ever extracting files into the same directory as the original or modifying it. Which approach correctly forces maximum compression?
*   **A)** `tar -czf import001.tar.gz import001.tar.bz2`
*   **B)** `bzip2 -dc import001.tar.bz2 | gzip -9 > import001.tar.gz`
*   **C)** `tar -xjf import001.tar.bz2 && tar -czf import001.tar.gz *`
*   **D)** `mv import001.tar.bz2 import001.tar.gz`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** Since the payload is a `.tar` stream regardless of its outer compression, piping the decompressed bytes from `bzip2 -dc` straight into `gzip -9` re-compresses the exact same tar archive at maximum compression, with no intermediate extraction and zero risk to the original file.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because it would tar the compressed `.tar.bz2` file itself as a single member, not its contents, and `tar -z` alone uses gzip's default compression level (6), not `-9`.
    *   *Option C* is incorrect because it extracts into the current directory, risking collisions with existing files, and still does not control the compression level.
    *   *Option D* is incorrect because renaming a bzip2-compressed file to a `.gz` extension does not actually re-compress it; the byte format is unchanged and unreadable by gzip tools.
</details>

---

### Question 13
You are designing a backup strategy for `/srv/appdata` that must exclude a large `cache/` subdirectory, run a full backup weekly, and run space-efficient incremental backups daily that only capture files changed since the last run. Which `tar` flag is the key mechanism that makes true incremental backups possible?
*   **A)** `--exclude`
*   **B)** `--listed-incremental=<snapshot-file>`
*   **C)** `--verbose`
*   **D)** `--same-owner`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `--listed-incremental` maintains a snapshot metadata file that records every file's state at the time of the last backup. Each subsequent run compares the current filesystem against that snapshot and archives only what changed, then updates the snapshot — this is the actual mechanism that makes an "incremental" backup incremental, not just a naming convention.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `--exclude` controls which paths are skipped entirely, unrelated to detecting what changed since the last run.
    *   *Option C* is incorrect because `--verbose` only affects console output during the archive operation.
    *   *Option D* is incorrect because it controls ownership metadata during extraction, not incremental change detection.
</details>

---

### Question 14
`df -h` shows `/var` at 98% full, but running `du -sh /var/* | sort -rh` only accounts for a fraction of that space. What is the most likely explanation, and what command would confirm it?
*   **A)** `du` is buggy and undercounts sparse files; reboot to fix it.
*   **B)** A process is still holding an open file handle to a file that has been deleted from the directory tree — `du` can no longer see it (it was unlinked), but the kernel still reserves its blocks until the handle closes. Confirm with `sudo lsof +L1` or by inspecting `/proc/<pid>/fd/`.
*   **C)** `df` always overstates usage by design and should be ignored in favor of `du`.
*   **D)** The filesystem needs to be reformatted to reclaim the missing space.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `du` walks the visible directory tree and can only report space used by files that still have a name (a link) somewhere on disk. A process that opened a file and then had that file deleted (`rm`) out from under it still holds a valid file descriptor — the kernel keeps the blocks allocated until the last open handle is closed, even though the file is invisible to any directory listing or `du`. `lsof +L1` (or `lsof | grep deleted`) lists files with a link count of 1 or less that are still open, exposing exactly this gap.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because this is expected kernel behavior, not a `du` defect.
    *   *Option C* is incorrect because `df` reports the kernel's actual block allocation, which is authoritative for real free space.
    *   *Option D* is incorrect and unnecessarily destructive; restarting or fixing the offending process (releasing the file handle) reclaims the space immediately.
</details>

---

### Question 15
You need to mirror `/srv/www` from `web01` to `web02` such that files deleted on the source are also removed from the destination, while excluding a `tmp/` subdirectory entirely. Which `rsync` invocation is correct?
*   **A)** `rsync -av /srv/www/ web02:/srv/www/`
*   **B)** `rsync -av --delete --exclude='tmp/' /srv/www/ web02:/srv/www/`
*   **C)** `rsync -av --exclude='tmp' web02:/srv/www/ /srv/www/`
*   **D)** `scp -r /srv/www web02:/srv/www`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `--delete` propagates deletions from the source to the destination during a sync (without it, rsync only ever adds/updates, never removes), and `--exclude='tmp/'` skips the specified subdirectory entirely. The trailing slash on the source path (`/srv/www/`) copies the *contents* of the directory rather than the directory itself, matching a typical mirror layout.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because it omits `--delete`, so files removed from the source will never be removed from the destination, and it does not exclude `tmp/`.
    *   *Option C* is incorrect because the source and destination arguments are reversed, which would overwrite the source with the destination's content instead of mirroring outward.
    *   *Option D* is incorrect because `scp` performs a full copy every time with no delta-transfer, no deletion propagation, and no exclude support.
</details>

---

### Question 16
You've written a plain bash script at `/opt/monitor/watcher.sh` that should run continuously in the background, restart automatically if it crashes, and start on every boot. What is the correct way to manage it under systemd?
*   **A)** Add `/opt/monitor/watcher.sh &` to `/etc/rc.local`.
*   **B)** Create a unit file at `/etc/systemd/system/watcher.service` with `ExecStart=/opt/monitor/watcher.sh`, `Restart=on-failure` under `[Service]`, enable it with `systemctl enable --now watcher.service`.
*   **C)** Add a `cron` entry with `@reboot /opt/monitor/watcher.sh`.
*   **D)** Run `nohup /opt/monitor/watcher.sh &` manually after every reboot.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** A proper systemd unit file with `ExecStart` pointing at the script, `Restart=on-failure` for crash recovery, registered under `[Install]` with `WantedBy=multi-user.target`, and enabled via `systemctl enable --now` gives you boot-time startup, supervised restarts, and standard `systemctl status`/`journalctl -u` observability — the modern, LFCS-tested way to manage a long-running script as a service.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `rc.local` is a legacy mechanism with no crash-restart supervision and is not enabled by default on many modern distributions.
    *   *Option C* is incorrect because cron's `@reboot` runs the command once at boot with no restart-on-crash behavior.
    *   *Option D* is incorrect because it requires manual intervention after every reboot and provides no supervision at all.
</details>

---

### Question 17
`nginx.service` is a vendor-shipped unit. You need to add `Restart=on-failure` to it without ever editing the file at `/lib/systemd/system/nginx.service` directly (so a package upgrade won't silently wipe your change). What is the correct approach?
*   **A)** Edit `/lib/systemd/system/nginx.service` directly, then run `systemctl daemon-reload`.
*   **B)** Run `systemctl edit nginx.service`, add the override under `[Service]` in the generated drop-in file, then run `systemctl daemon-reload` and restart the service.
*   **C)** Copy the entire unit file to `/etc/systemd/system/`, delete the original, and edit the copy.
*   **D)** Add the setting to `/etc/nginx/nginx.conf`.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `systemctl edit` creates a drop-in override file (typically `/etc/systemd/system/nginx.service.d/override.conf`) that layers additional or overriding directives on top of the vendor unit at runtime, without ever touching the original shipped file. A package upgrade that replaces `/lib/systemd/system/nginx.service` leaves your override intact since it lives in a completely separate path.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because directly editing a vendor-managed file under `/lib/systemd/system/` risks the change being silently overwritten on the next package upgrade.
    *   *Option C* is incorrect because it is unnecessarily destructive and loses the benefit of automatically inheriting future vendor unit updates.
    *   *Option D* is incorrect because `nginx.conf` configures nginx's own application behavior, not how systemd supervises the process (restart policy, environment, resource limits).
</details>

---

### Question 18
You need to generate a self-signed SSL certificate and private key for `internal.web-srv1.local` that is valid for 365 days, using a 2048-bit RSA key, in a single command. Which `openssl` invocation is correct?
*   **A)** `openssl genrsa -out server.key 2048`
*   **B)** `openssl req -x509 -newkey rsa:2048 -keyout server.key -out server.crt -days 365 -nodes -subj "/CN=internal.web-srv1.local"`
*   **C)** `openssl x509 -in server.crt -text -noout`
*   **D)** `openssl verify server.crt`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `req -x509` combined with `-newkey rsa:2048` generates a new 2048-bit RSA key and a self-signed X.509 certificate in one step. `-keyout`/`-out` name the resulting key and certificate files, `-days 365` sets validity, `-nodes` skips encrypting the private key with a passphrase (needed for services that must start unattended), and `-subj` supplies the certificate subject (here, the Common Name) without an interactive prompt.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because it only generates the private key, producing no certificate at all.
    *   *Option C* is incorrect because it only inspects an already-existing certificate's contents; it generates nothing.
    *   *Option D* is incorrect because it only verifies a certificate's trust chain; it does not create key or certificate material.
</details>

---

### Question 19
You need to verify that a given private key (`server.key`) and certificate (`server.crt`) genuinely belong to the same key pair before deploying them to a web server. Which technique correctly confirms this?
*   **A)** Compare the file sizes of `server.key` and `server.crt`.
*   **B)** Compute the modulus of both with `openssl rsa -noout -modulus -in server.key | openssl md5` and `openssl x509 -noout -modulus -in server.crt | openssl md5`, and confirm the two hashes match.
*   **C)** Check that both files were created on the same date with `stat`.
*   **D)** Open both files in a text editor and visually compare their contents.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** The RSA modulus is a mathematical property shared uniquely between a private key and its corresponding public certificate. Extracting and hashing the modulus from each file and comparing the two hashes is the standard, reliable way to prove they form a matching pair — a mismatch here is a classic cause of TLS handshake failures after a key/cert mix-up.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because file size has no cryptographic relationship to key/certificate pairing.
    *   *Option C* is incorrect because timestamps are metadata, not cryptographic proof of a matching pair.
    *   *Option D* is incorrect because both files are encoded (typically PEM/base64) and not meaningfully comparable by eye, nor does visual similarity prove a mathematical relationship.
</details>

---

### Question 20
While troubleshooting a failed `find -exec mv {} dir/ \;` cleanup pass that appears to have moved some files twice, you want to re-run it safely to see exactly what would match before anything is actually deleted or moved again. What is the safest first step?
*   **A)** Re-run the exact same command again immediately.
*   **B)** Run the same `find` expression with `-print` (or no action at all, since printing is `find`'s default action) instead of `-delete`/`-exec`, review the matched file list, then re-add the destructive action only once it looks correct.
*   **C)** Run `rm -rf` on the destination directory and start over from a backup.
*   **D)** Disable the shell's error output with `2>/dev/null` and re-run blindly.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** Because `find`'s default action (when no `-exec`/`-delete` is given) is simply to print matching paths, swapping out the destructive action for a dry-run listing costs nothing and lets you confirm exactly which files match the expression's predicates before anything irreversible happens — critical when an earlier pass already changed the directory's state (e.g. by moving files into a subdirectory that a later, badly-scoped pass might now recurse into).
*   **Why others are incorrect:**
    *   *Option A* is incorrect because it repeats the same mistake without any verification, likely compounding the problem if the expression is over-broad.
    *   *Option C* is incorrect because it is destructive and unnecessary when a simple dry run tells you what's wrong.
    *   *Option D* is incorrect because suppressing error output hides diagnostic information instead of revealing the actual scope of the problem.
</details>

---

## Audit and Review Key

| Question | Core Competency Tested | Review Chapter |
| :--- | :--- | :--- |
| **Q1** | stdout vs stderr redirection | **[Section 010, Module 01](./section-010/module-01/course.md)** |
| **Q2** | Exit code design and `$?` semantics | **[Section 010, Module 01](./section-010/module-01/course.md)** |
| **Q3** | Environment variable export and scope | **[Section 010, Module 02](./section-010/module-02/course.md)** |
| **Q4** | `umask` and `setgid` for shared directories | **[Section 020, Module 02](./section-020/module-02/course.md)** |
| **Q5** | `find` size/maxdepth triage without re-scanning results | **[Section 020, Module 03](./section-020/module-03/course.md)** |
| **Q6** | `grep -F` filtering piped into `sed -E` redaction | **[Section 030, Module 01](./section-030/module-01/course.md)** |
| **Q7** | Shell history search techniques | **[Section 030, Module 02](./section-030/module-02/course.md)** |
| **Q8** | Alias expansion in scripts vs interactive shells | **[Section 030, Module 03](./section-030/module-03/course.md)** |
| **Q9** | Cross-branch inspection with `git show <rev>:<path>` | **[Section 040, Module 02](./section-040/module-02/course.md)** |
| **Q10** | Git's content-only tracking model (no empty directories) | **[Section 040, Module 02](./section-040/module-02/course.md)** |
| **Q11** | `git rebase` for linear history vs `git merge` | **[Section 040, Module 03](./section-040/module-03/course.md)** |
| **Q12** | `tar`/compression-filter pipelines and compression levels | **[Section 050, Module 01](./section-050/module-01/course.md)** |
| **Q13** | `tar --listed-incremental` backup chains | **[Section 050, Module 02](./section-050/module-02/course.md)** |
| **Q14** | Deleted-but-open file handles (`du` vs `df` gap) | **[Section 060, Module 01](./section-060/module-01/course.md)** |
| **Q15** | `rsync --delete`/`--exclude` mirroring | **[Section 060, Module 02](./section-060/module-02/course.md)** |
| **Q16** | Wrapping a script as a supervised systemd service | **[Section 070, Module 01](./section-070/module-01/course.md)** |
| **Q17** | `systemctl edit` drop-in overrides for vendor units | **[Section 070, Module 02](./section-070/module-02/course.md)** |
| **Q18** | Generating a self-signed cert/key pair with `openssl req -x509` | **[Section 070, Module 03](./section-070/module-03/course.md)** |
| **Q19** | Verifying key/certificate pairing via RSA modulus | **[Section 070, Module 03](./section-070/module-03/course.md)** |
| **Q20** | Safe dry-run discipline before destructive `find` operations | **[Section 020, Module 03](./section-020/module-03/course.md)** |
