# Section 020: Permissions & File Triage

Welcome to Section 020. In this section, we solve one of the oldest problems in multi-user systems: who is allowed to read, write, or run a given file — and what happens the instant a brand-new file is born, before anyone has touched it at all.

Every permission decision on a Linux box ultimately traces back to two mechanisms working together. `chmod` answers the question *"what should this file's permissions be right now?"* — including three special bits (setuid, setgid, sticky) that go beyond plain read/write/execute. `umask` answers a quieter but equally important question: *"what permissions does a file get the moment it's created, before anyone runs `chmod` on it at all?"* Neither one is optional knowledge — a shared directory with the wrong group-inheritance bit, or a service whose umask is silently wrong, produces exactly the kind of "it works on my machine" permission bug that eats hours of troubleshooting time.

Once you can set and reason about permissions with confidence, the next skill is finding files at scale by the criteria that actually matter operationally — age, size, and permission bits — and triaging them safely with `find`, without a single line of custom scripting.

---

## What You Will Master

By completing this section, you will acquire three core permission and triage capabilities:

*   **Permission Bit Fluency:** Converting between symbolic (`u+x`, `go-w`) and octal (`750`) `chmod` notation on sight, and applying the three special bits — setuid, setgid, and sticky — correctly.
*   **Default Permission Control:** Understanding why new files and directories get the permissions they do before `chmod` ever runs, and setting `umask` persistently so new files come out correct from the moment of creation.
*   **File Triage at Scale:** Using `find`'s time, size, and permission predicates to locate and relocate files safely across a large tree, in an order that doesn't corrupt later passes.

---

## The Learning & Lab Path

This section is divided into three modules, each paired with hands-on practice inside its own single-node lab environment:

### 1. chmod — Symbolic vs Octal, and the Three Special Bits
*   **Module Reader:** **[Module 1: chmod — Symbolic vs Octal, and the Three Special Bits](./module-01/course.md)**
*   **Associated Lab:** **`labs/lab-021`**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-021
    ```
*   **Hands-on Objective:** Configure a shared team directory with setgid group inheritance, lock an owner-only script down completely, and apply the sticky bit to a shared drop location.

### 2. umask — Why New Files Aren't 777 By Default
*   **Module Reader:** **[Module 2: umask — Why New Files Aren't 777 By Default](./module-02/course.md)**
*   **Associated Lab:** **`labs/lab-022`**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-022
    ```
*   **Hands-on Objective:** Compute the permissions a given umask produces for both new files and new directories, then set a persistent per-user umask that survives new login sessions.

### 3. Find, Filter, and Triage Files by Age, Size, and Permission
*   **Module Reader:** **[Module 3: Find, Filter, and Triage Files by Age, Size, and Permission](./module-03/course.md)**
*   **Associated Lab:** **`labs/lab-023`**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-023
    ```
*   **Hands-on Objective:** Run a multi-stage `find` cleanup — delete-by-age, then triage-by-size, then triage-by-permission — over a backup directory, without letting any pass re-match files an earlier pass already relocated.

---

## Ready for Assessment?

Test your theoretical knowledge and diagnostic reasoning before tackling the permissions and triage capstone mission:

*   **[Take the Section 020 Knowledge Check Quiz](./quiz.md)**
