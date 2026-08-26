# Section 010 Knowledge Check: Shell Semantics

Test your understanding of stdout/stderr redirection, redirection ordering, exit-code capture, and shell-local versus exported environment variable scope.

---

## Scenario-Based Questions

### Question 1
You run `report-tool 2>&1 > audit.log` expecting `audit.log` to contain both the program's normal output and its error messages. After running it, you notice `audit.log` only contains the normal output, and the error messages printed to your terminal instead. What is the cause?
*   **A)** `report-tool` never wrote anything to stderr, so there was nothing to capture.
*   **B)** The redirections were evaluated left to right: `2>&1` pointed fd 2 at fd 1's *current* target (the terminal) before `> audit.log` repointed fd 1, so fd 2 never followed fd 1 into the file.
*   **C)** `2>&1` is invalid syntax and was silently ignored by the shell.
*   **D)** `audit.log` needs to be created with `touch` before this syntax will work correctly.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** The shell processes redirection operators strictly left to right, and each one captures the target's state *at that instant* rather than creating a live, ongoing link. `2>&1` written first means "point fd 2 at wherever fd 1 currently points" — which, before any file redirection has happened, is still the terminal. The subsequent `> audit.log` then repoints fd 1 to the file, but fd 2 was already locked onto the terminal a moment earlier and has no way to know fd 1 moved afterward. Reversing the order to `> audit.log 2>&1` fixes it, because then fd 1 is pointed at the file *first*, and `2>&1` correctly latches onto that new target.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because the terminal output described in the scenario proves stderr content was in fact written — it just wasn't captured.
    *   *Option C* is incorrect because `2>&1` is valid, well-defined bash/POSIX redirection syntax; it simply didn't do what the user assumed given its placement.
    *   *Option D* is incorrect because `>` creates the target file automatically if it doesn't already exist; no `touch` is required.
</details>

---

### Question 2
A script runs `deploy-check`, then runs `echo "checking result..."` as a status message, and only after that runs `echo $? > result.log`. The team is confused why `result.log` never reflects `deploy-check`'s actual failures. What is the root cause?
*   **A)** `$?` only works when read on the exact same line as the command that set it.
*   **B)** `echo "checking result..."` succeeded and overwrote `$?` with its own (successful) exit status before `deploy-check`'s status could be captured.
*   **C)** `echo $?` cannot be redirected into a file with `>`.
*   **D)** `deploy-check` must be run with `sudo` for its exit code to be readable.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `$?` always holds the exit status of the single most recently completed foreground command — nothing more persistent than that. The intervening `echo "checking result..."` is itself a command that completes and sets its own exit status (almost always `0`, since `echo` rarely fails), silently clobbering whatever `deploy-check` had left behind. By the time `echo $? > result.log` runs, it's reporting on the status message's success, not `deploy-check`'s. The fix is to capture `$?` immediately after the command whose status you need, with no commands — not even seemingly harmless ones — in between.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `$?` can be read on any subsequent line — the problem is *which* command most recently completed, not line adjacency in the source file.
    *   *Option C* is incorrect because `echo $? > file` is a completely standard and valid way to write the captured value to a file.
    *   *Option D* is incorrect because `sudo` has no bearing on whether a program's exit status is readable via `$?`; that mechanism is entirely independent of privilege level.
</details>

---

### Question 3
A tool prints both diagnostic output and real results to stdout, and you want to discard only the diagnostic noise while still seeing (and keeping) the real results on your terminal, without touching any files. The tool is well-behaved and sends diagnostics to stderr. Which command achieves this?
*   **A)** `noisy-tool > /dev/null`
*   **B)** `noisy-tool 2> /dev/null`
*   **C)** `noisy-tool &> /dev/null`
*   **D)** `noisy-tool 2>&1 > /dev/null`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `/dev/null` is the standard destination for "I don't want this stream at all." Since the tool sends diagnostics to stderr (fd 2) and real results to stdout (fd 1), redirecting only fd 2 to `/dev/null` discards exactly the noise while leaving fd 1 completely untouched, so results still print normally to the terminal.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because it discards stdout — the real results — while leaving stderr (the noise you wanted gone) printing to the terminal, the exact opposite of the goal.
    *   *Option C* is incorrect because `&>` sends *both* streams to `/dev/null`, discarding the real results along with the diagnostics.
    *   *Option D* is incorrect due to ordering: `2>&1` first points stderr at the terminal (fd 1's location at that moment), then `> /dev/null` sends stdout to the void — leaving diagnostics on the terminal and hiding the real results, again the reverse of what's wanted.
</details>

---

### Question 4
A script sets `API_KEY=abc123` (no `export`) at the top, then later in the same script calls `curl-wrapper.sh`, a separate script invoked as `./curl-wrapper.sh`, which tries to read `$API_KEY` to authenticate. `curl-wrapper.sh` reports the variable as empty. What is the most likely cause?
*   **A)** Variable names longer than 8 characters are not supported in bash.
*   **B)** `API_KEY` was assigned as a plain shell variable, never exported, so `curl-wrapper.sh` — running as its own separate child process — never inherited it.
*   **C)** `curl-wrapper.sh` must be sourced with `source`, not executed directly, for any variables to work at all.
*   **D)** Shell scripts cannot pass any data between each other under any circumstances.
<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `API_KEY=abc123` without `export` creates a shell variable local to the parent script's own process. Running `./curl-wrapper.sh` launches a brand-new child process, which only inherits the parent's *environment* (its exported variables) at the moment it's spawned — not its private, unexported shell variables. Since `API_KEY` was never flagged with `export`, the child process starts up with no knowledge of it at all. Adding `export API_KEY=abc123` (or `export API_KEY` after the plain assignment) fixes it.
*   **Why others are incorrect:**
    *   *Option A* is incorrect — bash variable names have no meaningful length restriction like this.
    *   *Option C* is incorrect because directly executing a script is the normal, correct way to run it as a subprocess; sourcing is a different mechanism (running in the *current* shell) with different scope implications, not a prerequisite for basic variable inheritance.
    *   *Option D* is incorrect and overly absolute — exported environment variables are exactly the standard mechanism scripts use to pass configuration to child processes.
</details>

---

### Question 5
You need `RELEASE_TAG` to expand inside a longer string as `${RELEASE_TAG}_final`, but after running `export RELEASE_TAG='${RELEASE_TAG}_final'`, a child process reads the variable and sees the literal text `${RELEASE_TAG}_final` instead of an expanded value. What went wrong?
*   **A)** `export` does not support reassigning a variable to a value derived from itself.
*   **B)** Single quotes were used, which suppress all variable expansion in bash, so the string was exported completely literally instead of being expanded first.
*   **C)** The braces around `RELEASE_TAG` are invalid syntax and caused expansion to silently fail.
*   **D)** `_final` is a reserved bash suffix that blocks expansion of any preceding variable.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** Single quotes in bash disable all forms of expansion, including variable substitution — everything between them is treated as completely literal text. Writing `'${RELEASE_TAG}_final'` therefore assigns and exports the seven-character-plus literal string `${RELEASE_TAG}_final` rather than first substituting the existing value of `RELEASE_TAG` and appending `_final` to it. Using double quotes instead — `export RELEASE_TAG="${RELEASE_TAG}_final"` — allows the expansion to happen while still protecting the result from word-splitting and glob expansion.
*   **Why others are incorrect:**
    *   *Option A* is incorrect — reassigning a variable based on its own current value (`VAR="${VAR}_suffix"`) is a completely standard and well-supported pattern, provided expansion isn't suppressed by quoting.
    *   *Option C* is incorrect because `${VAR}` brace syntax is valid, standard bash expansion syntax; the failure here is entirely due to quote style, not the braces.
    *   *Option D* is incorrect — there is no such reserved suffix concept in bash; any literal text can immediately follow a properly expanded variable.
</details>
