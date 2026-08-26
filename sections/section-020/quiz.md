# Section 020 Knowledge Check: Permissions & File Triage

Test your understanding of `chmod`'s symbolic and octal notation and its three special bits, why `umask` decides new-file permissions before `chmod` ever runs, and how to triage files safely at scale with `find`.

---

## Scenario-Based Questions

### Question 1
You're setting up `/srv/data/finance` as a shared directory for the `finance` group. The owner and group should have full read/write/execute access, everyone else should have no access at all, and any new file a team member creates inside it must automatically belong to group `finance` rather than that user's own personal primary group. Which command achieves all of this in one step?
*   **A)** `sudo chmod 770 /srv/data/finance`
*   **B)** `sudo chmod 2770 /srv/data/finance`
*   **C)** `sudo chmod 7200 /srv/data/finance`
*   **D)** `sudo chmod 4770 /srv/data/finance`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `770` alone (owner and group full access, other none) only covers the standard nine bits — it says nothing about what group new files inherit. Adding the setgid special bit (`2000`) on top, giving `2770`, additionally makes every new file or subdirectory created inside automatically take on the directory's own group (`finance`) instead of the creating user's personal primary group — exactly the requirement described.
*   **Why others are incorrect:**
    *   *Option A* is missing the special-bits digit entirely — `770` alone never triggers group inheritance for new files; it's easy to drop this fourth digit out of habit since three-digit modes are far more common.
    *   *Option C* misplaces the digits — `7200` is not a valid four-digit chmod mode in the intended sense and does not correspond to "owner/group full access, setgid enabled."
    *   *Option D* uses `4`, the setuid bit, not `2`, the setgid bit. Setuid governs run-as-owner behavior for executables and has no group-inheritance effect on a directory at all.
</details>

---

### Question 2
`/srv/uploads/dropbox` is a shared drop location set to `777` so any team member can create files there. Team members report that anyone can also delete files that other people uploaded, which shouldn't be allowed. What is the correct fix, and why does plain `777` not already prevent this?
*   **A)** Change the mode to `755` — removing other's write access will stop deletions.
*   **B)** Add the sticky bit (`chmod +t`, making it `1777`) — standard directory write access governs creating/deleting entries as a directory-level operation, not a file-level one, so only the sticky bit restricts deletion to each file's own owner.
*   **C)** Add the setgid bit (`chmod g+s`, making it `2777`) — group inheritance will prevent cross-user deletion.
*   **D)** Nothing can be done; `777` inherently allows anyone to delete anything inside it, permanently.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** Standard `rwx` on a directory governs whether entries can be created, listed, or traversed — it says nothing about which specific entries a given user is allowed to remove. On any ordinary writable directory, anyone with write access can unlink (delete or rename) any file inside it, regardless of who owns that individual file, because deletion is a directory-level operation. The sticky bit is the one mechanism that closes this gap, restricting deletion to a file's own owner (or root, or the directory's owner) even while the directory stays fully writable by everyone — exactly the pattern `/tmp` itself uses (`1777`).
*   **Why others are incorrect:**
    *   *Option A* would also block team members from creating new files at all, which breaks the "any team member can create files there" requirement — and even if write were left in place for a specific group, plain write access still wouldn't protect one user's files from another user in the same group.
    *   *Option C* is incorrect because setgid governs which *group* new files inherit, not who is allowed to delete an existing entry — it solves a completely different problem.
    *   *Option D* is incorrect; the sticky bit exists specifically to solve this exact scenario.
</details>

---

### Question 3
User `deploy` needs every new file they create to default to `640` and every new directory to default to `750`, persistently, across every future login. What is the correct line to add to their shell login startup file?
*   **A)** `umask 640`
*   **B)** `umask 027`
*   **C)** `chmod 640 ~/* `
*   **D)** `umask 750`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `umask` takes the *mask to subtract*, not the desired result. Files start from a base of `666` and directories from `777`. Working backward from the target: `666 - 027 = 640` and `777 - 027 = 750` — `027` is the mask that produces exactly the required outcome for both file types simultaneously.
*   **Why others are incorrect:**
    *   *Option A* confuses the desired *result* (`640`) with the *mask* that produces it — typing the result directly into `umask` produces a wildly different, incorrect subtraction (`666 - 640` is not how umask math works; `640` interpreted as a mask would strip nearly everything instead).
    *   *Option C* only fixes files that already exist at the moment it runs — it does nothing for files created after that point, and `umask` is specifically the mechanism that governs *future* file creation, not a one-time retroactive fix.
    *   *Option D* is the mask that would produce `640`-style results applied backward incorrectly — `777 - 750 = 027` happens to be the *directory* target expressed as a raw number rather than a mask, and using it directly as the umask value produces the wrong permissions for both files and directories.
</details>

---

### Question 4
A backup directory needs every file modified before January 1st, 2023 deleted. Which `find` invocation correctly and reliably targets that exact absolute cutoff, regardless of what day the command happens to be run?
*   **A)** `find /backup -maxdepth 1 -type f -mtime +365 -delete`
*   **B)** `find /backup -maxdepth 1 -type f ! -newermt "2023-01-01" -delete`
*   **C)** `find /backup -maxdepth 1 -type f -atime +365 -delete`
*   **D)** `find /backup -maxdepth 1 -type f -newermt "2023-01-01" -delete`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `-newermt "2023-01-01"` pins to a literal calendar date rather than a relative offset, matching files modified *after* that date. The leading `!` negates the test, flipping it to match everything modified *on or before* the cutoff — exactly "before January 1st, 2023," and this result never drifts no matter what day the command actually runs.
*   **Why others are incorrect:**
    *   *Option A* uses `-mtime +365`, a relative day count computed from "right now" — it approximates "about a year ago" only on the specific day it's run, and silently produces a different, wrong cutoff date on any other day, which is exactly the fragility an absolute requirement can't tolerate.
    *   *Option C* uses `-atime` (last *access* time, not modification time) and is still relative-day-based like Option A, compounding both problems at once.
    *   *Option D* omits the negation, so it matches files modified *after* the cutoff — the exact opposite of the files that need deleting.
</details>

---

### Question 5
You're triaging `/data/incoming`: first delete old files, then move files under 5KiB to `small/`, then move files over 50KiB to `large/`. After running the delete step, you create `small/` and `large/` as subdirectories, then immediately run the size-based `find` passes over `/data/incoming` without any additional flag. What is the most likely problem with this approach?
*   **A)** There is no problem; `find` never revisits a directory it has already created.
*   **B)** Without `-maxdepth 1`, each size-based pass will recurse into `small/` and `large/` too, potentially re-matching and re-moving files an earlier pass already sorted.
*   **C)** `find -size` cannot be combined with `-exec mv` in the same command.
*   **D)** The destination directories must be created before the delete step runs, not after, or `-delete` will fail.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** By default, `find` recurses into every subdirectory of its starting path. Once `small/` and `large/` exist inside `/data/incoming`, a size-based pass over `/data/incoming` with no depth restriction will walk into those subdirectories too, potentially re-matching files an earlier pass already relocated there — for example, re-moving an already-sorted small file into `large/` if it happens to also satisfy that pass's criteria in a different context. `-maxdepth 1` restricts each pass to files directly inside `/data/incoming`, leaving already-sorted subdirectories alone.
*   **Why others are incorrect:**
    *   *Option A* is incorrect — `find` has no built-in memory of directories it has "already created" or previously matched; it simply walks whatever tree exists at the moment it runs, every time.
    *   *Option C* is incorrect; combining `-size` with `-exec mv {} dir/ \;` (or the `+`-batched form) is a completely standard and supported pattern.
    *   *Option D* is incorrect and also reversed — creating the destination directories before the delete pass would risk the delete pass itself recursing into folders that don't yet hold any triaged files, which isn't the actual problem here; the real risk is creating them before the *size-based* passes without scoping those passes correctly.
</details>
