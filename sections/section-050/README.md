# Section 050: Archiving, Compression & Backup Strategy

Welcome to Section 050. Every other skill in this course eventually produces something worth protecting — a configuration you tuned by hand, a dataset a team depends on, a service directory you don't want to rebuild from memory. This section is about the two Linux disciplines that keep that work safe: packaging data into portable archives with the compression format the situation calls for, and running an actual, provable backup strategy instead of a folder of `.tar.gz` files nobody has ever tried to restore from.

Both skills sit on the same tool — `tar` — but they test very different instincts. Converting an archive's compression format is a precision exercise: get the flags right, prove nothing was lost. Running a real backup strategy is a discipline exercise: preserve the metadata that actually matters, exclude what shouldn't be copied, avoid silently re-doing full work every night, and never assume a backup is good until you've dragged it back out and compared it to the original.

---

## What You Will Master

By completing this section, you will acquire two core data-protection capabilities:
*   **Archive Format Conversion with Verification:** How to move an archive between compression formats (bzip2 to gzip) without touching the source, how to force a specific compression level through `tar`, and how to prove two archives hold identical contents using sorted listings instead of assuming it.
*   **Full & Incremental Backup Strategy:** How to build a `tar` backup that preserves ownership and permissions correctly, exclude directories that should never be backed up, run true incremental backups with `--listed-incremental`, and prove a restore is correct with `diff -r` rather than trusting a clean exit code.

---

## The Learning & Lab Path

This section is divided into two focused modules, each paired with a hands-on practice lab, and concluded with a Capstone Integration Challenge:

### 1. Archive Conversion & Content Verification
*   **Module Reader:** **[Module 1: Archive Conversion & Content Verification](./module-01/course.md)**
*   **Practice Lab Sandbox:** **`labs/lab-051`**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-051
    ```
*   **Hands-on Objective:** Convert a bzip2 archive to a gzip archive at the strongest compression level without ever modifying the original file, then generate sorted content listings for both archives and prove they match.

### 2. Backup Strategy with tar
*   **Module Reader:** **[Module 2: Backup Strategy with tar](./module-02/course.md)**
*   **Practice Lab Sandbox:** **`labs/lab-052`**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-052
    ```
*   **Hands-on Objective:** Take a full `tar` backup that preserves permissions and excludes a disposable cache directory, capture a true incremental backup of only what changed, and restore both into a scratch directory to verify correctness with `diff -r`.

### 3. Section Capstone Challenge
*   **Comprehensive Challenge:** **`labs/lab-050` (Archiving & Backup Integration)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-050
    ```
*   **Hands-on Objective:** Convert an existing report archive to a different compression format with a verified sorted-listing diff, and — independently — run a full-then-incremental `tar` backup of a live service directory with an exclusion pattern, then prove a real restore recovers exactly the right files.

---

## Ready for Assessment?

Test your theoretical knowledge and diagnostic reasoning before tackling the capstone lab mission:

*   **[Take the Section 050 Knowledge Check Quiz](./quiz.md)**
