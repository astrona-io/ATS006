# Section 030 Knowledge Check: Everyday Shell Craft

Test your understanding of grep/sed pattern matching and redaction, shell history configuration and recall, and safe alias design.

---

## Scenario-Based Questions

### Question 1
You need every line in `access.log` where the request path contains `/checkout` **and** the response code is `500`, but you're not certain which of the two substrings appears first on any given line. Which approach is most reliable?
*   **A)** `grep '.*\/checkout.*500.*' access.log`
*   **B)** `grep '/checkout' access.log | grep '500'`
*   **C)** `grep -v '/checkout' access.log | grep -v '500'`
*   **D)** `grep '/checkout' access.log; grep '500' access.log`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** Piping two independent `grep` invocations applies each condition as its own separate filter, regardless of which substring physically appears first on the line. This correctly catches a matching line whether `/checkout` comes before `500` or after it.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because a single `.*A.*B.*` regex only matches when `A` appears *before* `B` on the line. If a line has `500` appearing before `/checkout`, this regex silently fails to match it, producing an incomplete result with no error or warning.
    *   *Option C* is incorrect because `-v` inverts the match, meaning this prints lines that contain **neither** condition — the exact opposite of what's needed.
    *   *Option D* is incorrect because running two separate `grep` commands against the same file, one after another, prints two separate result sets to the terminal (lines matching either condition alone) rather than filtering for lines that satisfy both conditions together.
</details>

---

### Question 2
You run `sed -E 's/^host\.web.*DOWN$/OUTAGE LOGGED/' status.log` and it correctly redacts every line you expect — except it also unexpectedly redacts a line reading `host.webhook-listener heartbeat DOWN`, which should NOT have matched. What is the cause?
*   **A)** `sed -E` cannot use anchors, so `^` and `$` are being ignored entirely.
*   **B)** `^host\.web` matches as a prefix of `host.webhook-listener` too, since the pattern only requires the line to *start with* those literal characters — it has no way to know you meant `host.web` as a complete token.
*   **C)** The `.*` wildcard is matching zero characters, causing the pattern to skip validation entirely.
*   **D)** `sed -E` requires `\b` word-boundary markers by default, and omitting them causes over-matching.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `^host\.web` only asserts that the line begins with the literal characters `host.web` — it says nothing about what has to come immediately after them. Since `host.webhook-listener` also begins with exactly those characters, the anchor is satisfied even though `host.web` was intended to mean the complete token `host.web`, not a prefix of a longer name. This is a real, common gotcha with anchored prefix patterns: `^X` guarantees the match starts at position zero, not that `X` is "the whole first word."
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `-E` only changes whether metacharacters like `|` and `+` need escaping (extended vs. basic regex) — anchors (`^`, `$`) work identically in both modes.
    *   *Option C* is incorrect because `.*` matching zero characters is completely normal and expected behavior for "zero or more" — it doesn't disable anything about the surrounding pattern.
    *   *Option D* is incorrect because `sed` never requires `\b` word-boundary markers by default in either BRE or ERE mode; boundary-awareness has to be added explicitly by the pattern author if it's needed.
</details>

---

### Question 3
You want your shell to permanently skip recording any command that starts with a leading space, while still recording a repeated command if something else ran in between the two occurrences. Which single `HISTCONTROL` value satisfies this exactly?
*   **A)** `HISTCONTROL=ignoredups`
*   **B)** `HISTCONTROL=ignorespace`
*   **C)** `HISTCONTROL=ignoreboth`
*   **D)** `HISTCONTROL=erasedups`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `ignorespace` skips recording exactly one thing: a command that begins with a leading space. It says nothing about duplicate detection at all, so a repeated command (with something else run in between) is still recorded normally — which is exactly the described requirement.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `ignoredups` only affects consecutive duplicate commands — it has no effect on leading-space commands at all, so space-prefixed commands would still be recorded.
    *   *Option C* is incorrect because `ignoreboth` combines `ignorespace` *and* `ignoredups` — it adds consecutive-duplicate suppression that the scenario doesn't call for (though it's harmless if non-consecutive repeats are still allowed through, the question asks for the value that satisfies the requirement *exactly*, and B does so without adding unrequested behavior).
    *   *Option D* is incorrect because `erasedups` is not a value that suppresses future space-prefixed commands from being recorded; it deals with removing older duplicate lines from history entirely, which is a different behavior than what's described.
</details>

---

### Question 4
You typed a command in Terminal A five minutes ago. Terminal B, still open the entire time on the same machine and same user, does not show that command in its `history` output. What is the most accurate explanation?
*   **A)** `history` only ever shows commands from the shell it's run in — no configuration can ever change this.
*   **B)** Terminal A's shell hasn't written that command to `~/.bash_history` yet (it only writes on exit by default), and even after it does, Terminal B won't see it until it re-reads the file.
*   **C)** Bash requires `HISTFILE` to be set to a shared path across terminals for this to work, and it defaults to a per-terminal random path.
*   **D)** Commands are only shared between terminals opened from the exact same parent process.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** Each interactive bash shell keeps its own history in memory and only flushes it to the shared `~/.bash_history` file when that shell exits, or when explicitly told to with `history -a`/`history -w`. A second shell has no way to see entries that were never written, and even after they are written, it won't notice until it re-reads the file with `history -r` (or starts fresh). This exact behavior can be changed by wiring `history -a; history -c; history -r` into `PROMPT_COMMAND`, which is precisely why option A is wrong.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because, while true by default, it's not an absolute limitation — `PROMPT_COMMAND` wiring can make history share near-live between terminals, so "no configuration can ever change this" overstates the case.
    *   *Option C* is incorrect because `HISTFILE` defaults to the same `~/.bash_history` path for every interactive shell of that user by default — it is not randomized per terminal.
    *   *Option D* is incorrect because history sharing has nothing to do with parent-process lineage; it's entirely about when each shell's in-memory history gets written to and read from the shared file.
</details>

---

### Question 5
You run `alias rm='rm -i'` in your interactive shell and add it to `~/.bashrc`. A cron job on the same system, running as the same user, executes a script that calls `rm` on some temporary files. What happens?
*   **A)** The cron job's `rm` prompts for confirmation just like your interactive shell, since it runs as the same user and `~/.bashrc` defines the alias for that user.
*   **B)** The cron job's `rm` runs as the real, unmodified `rm` binary with no prompt, because non-interactive shells don't perform alias expansion by default, regardless of what's defined in that user's `~/.bashrc`.
*   **C)** The cron job fails outright, because aliased commands cannot be referenced from any script.
*   **D)** The behavior depends entirely on whether the script begins with `#!/bin/bash` or `#!/bin/sh`.
<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** Alias expansion is disabled by default in non-interactive shells — the category cron jobs and scripts fall into, regardless of which user runs them or what's defined in that user's interactive startup files. The cron job's `rm` resolves straight to the real binary on `PATH`, deletes without prompting, exactly as if no alias existed anywhere on the system.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because being "the same user" has no bearing on alias expansion — the interactive-vs-non-interactive distinction is what governs it, not user identity.
    *   *Option C* is incorrect because there's no failure at all — the script runs successfully, it simply runs the real `rm`, unaffected by the alias.
    *   *Option D* is incorrect because the shebang choosing `bash` vs. `sh` doesn't change this outcome — non-interactive shells of either kind don't expand aliases by default; the relevant factor is interactivity, not which shell interpreter is invoked.
</details>

---
