# Section 040: Version Control with Git

Welcome to Section 040. Configuration-as-code has quietly made Git a core system administration tool, not just a developer one. Ansible playbooks, Terraform manifests, dotfiles, cron scripts, and firewall rule sets increasingly live in Git repositories long before they touch a production host — and LFCS expects you to be fluent enough with Git to be trusted with that history.

This section does not attempt to teach Git as a full development workflow. It builds exactly the baseline fluency an operator needs: creating and inspecting a repository from nothing, cloning a shared repository and hunting across its branches without disturbing your working tree, merging the right change into `main`, and reconciling your own in-progress work against an upstream that moved on while you weren't looking.

---

## What You Will Master

By completing this section, you will acquire three core version-control capabilities:
*   **Local Repository Fundamentals:** How to initialize a repository, read `git status` and `git diff` output correctly at every stage of a change's lifecycle, write a working `.gitignore`, and understand what a Git remote actually is.
*   **Cross-Branch Inspection & Merging:** How to clone a repository, inspect file content across multiple branches without checking any of them out, merge only the correct branch into `main`, and work around Git's refusal to track empty directories.
*   **Upstream Reconciliation:** How to create a topic branch, make a focused commit, detect that a shared upstream has moved on using `fetch`, and reconcile your branch against it with `rebase` — while knowing when a `merge` is the safer choice instead.

---

## The Learning & Lab Path

This section is divided into three focused modules, each paired with a dedicated hands-on practice lab, and concluded with a comprehensive Capstone Integration Challenge:

### 1. Git Fundamentals: Init, Status, Diff, Log, and Remotes
*   **Module Reader:** **[Module 1: Git Fundamentals — Init, Status, Diff, Log, and Remotes](./module-01/course.md)**
*   **Practice Lab Sandbox:** **`labs/lab-041`**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-041
    ```
*   **Hands-on Objective:** Initialize a brand-new repository from scratch, make and inspect isolated commits with `status`/`diff`/`diff --staged`, write a `.gitignore` that keeps generated files out permanently, and wire up a local bare repository as a stand-in remote with tracked `push`/`fetch`/`pull`.

### 2. Git Branches: Clone, Inspect, Merge, Commit
*   **Module Reader:** **[Module 2: Git Branches — Clone, Inspect, Merge, Commit](./module-02/course.md)**
*   **Practice Lab Sandbox:** **`labs/lab-042`**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-042
    ```
*   **Hands-on Objective:** Clone an existing repository, inspect a config file's content across three candidate branches without checking any of them out, merge only the branch matching the required value into `main`, and commit a new directory using the `.keep` placeholder convention.

### 3. Cloning an Upstream Repo, Working on a Topic Branch, and Reconciling Changes
*   **Module Reader:** **[Module 3: Cloning an Upstream Repo, Working on a Topic Branch, and Reconciling Changes](./module-03/course.md)**
*   **Practice Lab Sandbox:** **`labs/lab-043`**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-043
    ```
*   **Hands-on Objective:** Clone a shared upstream repository, create a topic branch and make a single focused commit, simulate upstream moving on without you, then `fetch` and `rebase` your branch cleanly onto the new upstream tip.

### 4. Section Capstone Challenge
*   **Comprehensive Challenge:** **`labs/lab-040` (Git Operations Integration)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-040
    ```
*   **Hands-on Objective:** Connect the dots. Clone a shared deployment-configs repository, identify and merge the one candidate branch with the correct feature flag, commit a new directory the `.keep` way, push your update upstream, then open a topic branch, reconcile it against a simulated teammate's upstream commit with a rebase, and push the final, fully linear history back to `origin`.

---

## Ready for Assessment?

Test your theoretical knowledge and diagnostic reasoning before tackling the Git lab missions:

*   **[Take the Section 040 Knowledge Check Quiz](./quiz.md)**
