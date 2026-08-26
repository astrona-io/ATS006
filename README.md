# ATS006 - LFCS: Essential Commands

[![Liberapay](https://img.shields.io/badge/Liberapay-Support_Astrona.io-F6C915?logo=liberapay&logoColor=black&style=for-the-badge)](https://liberapay.com/Astrona.io)

Welcome to **ATS006**, a comprehensive, free training curriculum designed to help you fully master and pass the **Essential Commands** domain of the **Linux Foundation Certified System Administrator (LFCS)** exam.

Essential Commands represents **20% of the total LFCS exam weight**. This repository bridges everyday command-line fluency with real-world, muscle-memory sysadmin practice, transforming you from a Linux beginner into a confident systems administrator.

---

## The Symmetrical 1:1:1 Learning Framework

To make learning intuitive, digestible, and robust, this curriculum is built around a symmetrical **1:1:1 educational architecture**:

1.  **The Textbook Lesson (`sections/section-XXX/module-YY/course.md`):** Narrative, book-style chapters written in a warm, expert "teacher's voice" that explain *why* the shell and its tools behave the way they do using real-world metaphors, inline command option breakdowns, and clear diagrams.
2.  **The Interactive Quiz (`sections/section-XXX/quiz.md`):** A scenario-based theoretical knowledge check testing diagnostic reasoning, complete with collapsible answers and technical explanation keys.
3.  **The Dedicated Laboratory (`labs/lab-XXX/`):** A virtual machine sandbox environment launched instantly via the `astrona` CLI where you must solve practical command-line objectives and validate your system states using automated testing scripts.

---

## Complete Curriculum & Lab Mapping

The training series is divided into **7 main sections** containing **18 highly focused modules**, **18 targeted lab sandboxes**, and **7 comprehensive Section Capstone Challenges**:

| Section & Domain | Module & Chapter Reader | Practice Lab Sandbox | astrona CLI Run Command |
| :--- | :--- | :--- | :--- |
| **010: Shell Semantics** | [M1: Redirection & Exit Codes](sections/section-010/module-01/course.md) | [lab-011](labs/lab-011) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-011` |
| | [M2: Environment Variables & Scope](sections/section-010/module-02/course.md) | [lab-012](labs/lab-012) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-012` |
| | **Section Capstone Challenge** | **[lab-010](labs/lab-010)** | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-010` |
| **020: Permissions & Triage** | [M1: chmod Bits](sections/section-020/module-01/course.md) | [lab-021](labs/lab-021) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-021` |
| | [M2: umask Defaults](sections/section-020/module-02/course.md) | [lab-022](labs/lab-022) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-022` |
| | [M3: find Triage by Criteria](sections/section-020/module-03/course.md) | [lab-023](labs/lab-023) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-023` |
| | **Section Capstone Challenge** | **[lab-020](labs/lab-020)** | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-020` |
| **030: Everyday Shell Craft** | [M1: grep & sed](sections/section-030/module-01/course.md) | [lab-031](labs/lab-031) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-031` |
| | [M2: Shell History](sections/section-030/module-02/course.md) | [lab-032](labs/lab-032) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-032` |
| | [M3: Command Aliases](sections/section-030/module-03/course.md) | [lab-033](labs/lab-033) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-033` |
| | **Section Capstone Challenge** | **[lab-030](labs/lab-030)** | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-030` |
| **040: Version Control (Git)** | [M1: Git Fundamentals](sections/section-040/module-01/course.md) | [lab-041](labs/lab-041) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-041` |
| | [M2: Branches, Clone & Merge](sections/section-040/module-02/course.md) | [lab-042](labs/lab-042) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-042` |
| | [M3: Upstream Reconciliation](sections/section-040/module-03/course.md) | [lab-043](labs/lab-043) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-043` |
| | **Section Capstone Challenge** | **[lab-040](labs/lab-040)** | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-040` |
| **050: Archiving & Backup** | [M1: Archive Conversion](sections/section-050/module-01/course.md) | [lab-051](labs/lab-051) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-051` |
| | [M2: tar Backup Strategy](sections/section-050/module-02/course.md) | [lab-052](labs/lab-052) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-052` |
| | **Section Capstone Challenge** | **[lab-050](labs/lab-050)** | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-050` |
| **060: Diskspace & Sync** | [M1: Diskspace Troubleshooting](sections/section-060/module-01/course.md) | [lab-061](labs/lab-061) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-061` |
| | [M2: rsync Mirroring & Snapshots](sections/section-060/module-02/course.md) | [lab-062](labs/lab-062) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-062` |
| | **Section Capstone Challenge** | **[lab-060](labs/lab-060)** | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-060` |
| **070: Service Configuration** | [M1: systemd Unit Creation](sections/section-070/module-01/course.md) | [lab-071](labs/lab-071) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-071` |
| | [M2: systemd Unit Override](sections/section-070/module-02/course.md) | [lab-072](labs/lab-072) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-072` |
| | [M3: SSL Certificates](sections/section-070/module-03/course.md) | [lab-073](labs/lab-073) | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-073` |
| | **Section Capstone Challenge** | **[lab-070](labs/lab-070)** | `astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-070` |

---

## How to Navigate This Course

To get the most value out of this curriculum, follow this step-by-step roadmap:

1.  **Enter a Domain Portal:** Navigate into a domain directory, such as `sections/section-010/`, and open its `README.md` to review the section's core philosophy and administrative master competencies.
2.  **Read the Chapters:** Open and read the narrative chapters in order (e.g., `module-01/course.md` and then `module-02/course.md`). Focus on the metaphors, diagrams, and inline command breakdowns.
3.  **Take the Chapter Self-Check:** Challenge yourself with the conceptual questions at the bottom of the course modules.
4.  **Test Your Diagnostics:** Open `quiz.md` inside that section and answer its 5 scenario questions. Expand the HTML details tags to read the deep-dive teacher's explanations.
5.  **Practice the Sandboxes:** Run the targeted module sandboxes (e.g., `lab-011`, `lab-012`, etc.) to build muscle memory on atomic tasks.
6.  **Conquer the Capstone Challenges:** Ready for high-stakes practice? Boot up the section's comprehensive **Capstone Challenge Lab** (e.g., `lab-010`, `lab-020`, etc.), solve the integration prompts, and run the automated test validation suites to confirm your passing state.
7.  **Simulate the Exam:** Once you have completed all 18 modules, open **`sections/final-domain-quiz.md`** and complete the final 20-question, closed-book domain exam simulator under a 30-minute time cap to audit your readiness.

---

## Pure-Linux Administrative Focus

This curriculum is designed with strict educational boundaries. To align perfectly with the off-grid, host-level environment of the practical LFCS exam, **all modules and labs focus exclusively on standard host-level Linux system administration.** There are no Kubernetes, container, or cloud-native concepts introduced, allowing you to master core operating system concepts with zero external noise.

---

## Support This Project

ATS006 is free LFCS training material. If it helped you on your administrative journey, consider supporting ongoing work and resource development via [Liberapay](https://liberapay.com/Astrona.io).
