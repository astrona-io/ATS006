# Writing style for this repo

All study text here (course pages, lab docs, READMEs, comments in YAML and
scripts) is for people learning a technical subject, often for a
certification exam. Many of them are not native English speakers and have no
university degree.

## Plain English

Write the text in Plain English for a general adult audience (18+) without a
university degree. The content must be highly accessible and easy to
understand for non-technical readers, without feeling childish.

Strict guidelines:

1. Target a Flesch-Kincaid Grade Level of 8 or 9 (equivalent to a standard
   newspaper article).
2. Avoid all technical jargon, acronyms, and corporate buzzwords. If a
   technical term is necessary, explain it immediately using an everyday
   analogy.
3. Keep sentences conversational and direct. Split long sentences into two.
4. Use short paragraphs (max 3-4 sentences per paragraph) and clear
   subheadings to make the text scannable.
5. Use the active voice (e.g., "We did this" instead of "This was done by us").

## How this applies to course material

- **Know which file you are in.** A module has a short landing page and a few
  deep-dive parts. The landing page is a map: goals, what to know first, the
  order of the parts, where it fits. The real teaching goes in the parts. A lab
  has a task, a step-by-step solution and a short intro. Keep each file to its
  job. Do not add "Prerequisite: ... Next: ..." navigation lines to pages;
  the landing page and the course outline already give the order.
- **Keep each part short.** One idea per part, about 5 to 8 minutes of
  reading and at most about 8 command blocks, so a learner can finish it with
  the playground in one sitting of about 15 minutes. Split at a natural seam
  where each half ends with something the learner has seen work. Never split
  only to hit a number. When you split, renumber the files, fix every "Part N"
  reference in the module, the wrap-up links and `astrona.yaml`.
- **Every heading gets an intro.** A `##` section that has `###`
  subsections starts with one to three sentences that say what the section
  is about and why it matters, before the first `###`. Never put a `###`
  directly under a `##`.
- **Every module stands on its own.** Never refer to other sections or
  modules: no "see section 040", "as module 3 showed", "you met this in
  section 000", and no links to pages in another module. If the reader needs
  a fact from elsewhere, state the fact directly in one or two sentences.
  This also goes for parts of the same module: never write "Part 2 shows",
  "from Part 1" or "as in Part 3". Say the fact itself ("the commands below
  need the `/var/output-generator` directory created first"). The wrap-up page is the one
  exception: it recaps each part and links to it.
  The landing page does not have a "Where this fits" section.
- **Write words out in full.** Do not use informal short forms in prose:
  write "communications", "configuration", "repository", "administrator",
  "for example" and "that is", never "comms", "config", "repo", "admin",
  "e.g." or "i.e.". Names in code, commands and file paths stay as they are.
- **Exam terms stay.** The product's own names are what the reader must learn
  (for example a resource kind, a field, a command). Keep them, but explain
  each one in plain words, with an everyday analogy, the first time it appears
  in a file. Spell out acronyms on first use, with a short plain meaning.
- **Analogies come from space, and the reader is an astronaut.** When a term
  needs an everyday picture, use space: spaceships, planets, solar systems,
  space stations, mission control, signals, docking, star charts, airlocks,
  even the Death Star. Talk to the reader as an astronaut (for example "your
  first mission", "astronaut, check your flight log"), but not in every
  sentence. Requests are **signals** that ships send to each other. Use one
  analogy per hard idea, keep it short, and keep it the same everywhere (if
  the repository has an analogy glossary, use it). The analogy helps the reader; it
  never replaces the real term, and it never changes code or output.
- **Show one real example before the rule.** Start with a concrete case the
  reader can run, then give the general rule.
- **Say which part does the work.** Readers often mix up the parts of a system
  that sit close together. Whenever something happens, say which component
  did it.
- **Never change code to fit the style.** Commands, configuration files, field
  names, resource names, log lines and command output stay exactly as they
  are. They were run and checked on a real system. Never make up command
  output. If you shorten it, say that you did.
- **Prose only.** The grade-level and sentence rules apply to explanations.
  They do not apply to code blocks, tables of field names or reference lists
  (those may stay short and dense).
- **Keep the page furniture the same.** Hands-on steps are normal page
  content, not boxes: a short `###` subsection (for example "See it in your
  playground") with one sentence saying what to do, the command, the real
  output, and one or two sentences saying what it shows. A `> [!TIP]` box is
  only for a real tip: advice the reader can reuse beyond this one step (a
  habit, a shortcut, how to spot a problem, an exam habit). Everything else
  is a normal sentence: notes about the current step ("if the log line is
  old, run it again"), background facts, optional extra steps, and plain
  information. Never a command snippet, never two in a row, and most pages
  need zero or one tip. Each part ends with a
  `## Common pitfalls` `> [!WARNING]` block for that part only. Use a Mermaid
  diagram for a flow, an order or a state change, keep it under about 12
  boxes, and follow it with one sentence that says what it shows.
- **Labs come right after the part they practise.** Do not collect all
  graded labs at the end of a module. In `astrona.yaml`, put each lab (its
  `question.md` reading and the `lab` entry) right after the reading part it
  tests. If a part teaches a gradeable skill and no lab covers it, create a
  new lab. That part then ends with a `## Your mission: <lab title>` section:
  one sentence on what the reader can now do, one on what the mission asks,
  then pause the playground (`astrona stop <playground name>`), the
  `astrona run` and `astrona submit` commands, and finally
  `astrona destroy <lab name>` plus `astrona start <playground name>`. The
  wrap-up lists the missions and ends with cleaning up the playground
  (`astrona list`, `astrona destroy <playground name>`).
- **Renew the playground before hands-on work.** Every reading part that
  runs commands has `<!-- astrona:playground:renew -->` exactly once, on its
  own line, right before the first hands-on step (the first "Save this as"
  or the first command block), so the playground timer is reset before the
  learner needs the playground. Not on landing pages (they carry
  `<!-- astrona:playground -->`), wrap-up pages or pages without commands.
- **Mermaid without HTML.** The platform renders Mermaid with HTML labels
  switched off, so `<br/>` and any other HTML tag break the drawing. Rules:
  - One line per box, no `<br/>`, no HTML. Keep the box to the thing's name
    (`"bash"`, `"systemd"`, `"fd 1: stdout"`).
  - Put the logic on the arrows: `P -->|"fork"| C`,
    `O -->|"2>&1"| F`, `S -->|"daemon-reload"| U`. Keep edge labels short.
  - Quote every label. Prefer `flowchart TB`; use `LR` only for a short chain.
  - Sequence diagrams: short participant aliases (`participant S as shell`)
    and short message text.
  - Anything longer (full paths, full hostnames) goes in the sentence under
    the diagram.
- **No links to outside sources.** Course pages, labs and playground docs do
  not link to or point at outside websites (the one exception is the
  `resources` field of a lab entry in `astrona.yaml`) (official docs, GitHub, blogs,
  RFCs), and they have no "Reference" or "Official docs" lists. Everything the
  reader needs is explained on the page itself. Not affected: addresses the
  reader actually uses in a command or browser (`http://127.0.0.1:8080`,
  `git clone /repositories/deploy-configs.git`), and the Mission Briefing's contributors and
  "report a mistake" links.
- **Configuration goes to a file first.** Whenever the reader should apply
  a configuration file (a unit file, a script, a `.gitignore`, YAML) in
  course parts, playground docs or labs, use three separate steps:
  1. "Save this as `/etc/systemd/system/collector.service`:" followed by a
     plain block (` ```ini `, ` ```bash `, ` ```yaml `) with only the file's
     content. No `cat > file <<'EOF'`, no `sudo tee file <<EOF`, no shell
     around it.
  2. "Apply it:" followed by a ` ```sh ` block with only the command that
     makes the system use the file (`sudo systemctl daemon-reload`,
     `chmod +x run-check.sh`).
  3. "Then check the result:" followed by the check commands, if any.
  The file name says what the file is for. If a value must come from the
  reader's machine (an IP address), use a placeholder like `<PARTNER>` in the
  file and say how to get the value (`echo $PARTNER`); never put shell
  variables inside a configuration file that does not expand them. Apply a
  file the first time its content appears; do not show it once "to read" and
  paste it again later. Never tell the reader to apply something from the
  playground's `examples/` folder: they start the playground with
  `astrona run`, so that folder is not on their machine.
- **Helpers have readable names.** Shell helper functions and variables use
  names that say what they do (`check_mode`, `count_lines`,
  `$BACKUP_DIR`), never single letters.


## About this repo (ATS006 only)

Everything above is general and can be copied to other course repositories. This
section is only true for this one.

### What the student is trying to learn

- **The goal:** pass the **Essential Commands** domain of the **Linux
  Foundation Certified System Administrator (LFCS)** exam. It is 20% of the
  exam.
- **What the exam really tests:** doing real administration work on a live
  Linux machine, from a terminal, under time pressure, and leaving the
  machine in the right state. So the student must *do* things (redirect a
  stream, set a permission, clone and merge, take a backup, free disk space,
  write a service), not just recognise words. Every explanation should lead
  to something they can run, and every result should be proved with a check
  command (`ls -l`, `stat`, `git log`, `tar -tvf`, `df`, `systemctl status`).
- **The exam topics this course covers:** shell redirection, exit codes and
  the environment; file permissions and finding files; text processing,
  history and aliases; basic Git operations; archives and backups;
  disk space troubleshooting and remote copies; creating and overriding
  services; and working with SSL certificates.
- **The sections:**

  | Section | Title | Exam topic |
  | --- | --- | --- |
  | 010 | Shell Semantics: Redirection, Exit Codes & Environment | Input and output redirection, the shell environment |
  | 020 | Permissions & File Triage | File permissions, searching for files |
  | 030 | Everyday Shell Craft: Text Processing, History & Aliases | Analysing text with regular expressions, using the shell |
  | 040 | Version Control with Git | Basic Git operations |
  | 050 | Archiving, Compression & Backup Strategy | Archive, back up, compress and restore files |
  | 060 | Diskspace Management & Remote Sync | Troubleshoot disk space issues, copy data between machines |
  | 070 | Service Configuration: systemd Units & SSL Certificates | Create, configure and troubleshoot services; work with SSL certificates |

- **The version:** every lab runs on **Ubuntu 24.04** in a `qemu` virtual
  machine built from `ghcr.io/astrona-io/ubuntu-qcow2-image:24.04-lfcs-{ARCH}`,
  with **bash** as the shell and **systemd** as the service manager. Do not
  teach options or behaviour from other distributions or shells without
  saying so (for example `&>` is a bash feature, not POSIX `sh`).
- **The main sources:** the manual pages on the lab machine (`man bash`,
  `man chmod`, `man find`, `man tar`, `man rsync`, `man systemd.unit`,
  `man openssl-req`) and the official Git book. Check every page against them.

### Space analogy glossary

Use these pictures for these terms, in every course page, lab and playground.
Keep them consistent so the astronaut builds one picture of the universe. It
is the same universe as the other Astrona courses: the learner is an
astronaut, and a single Linux machine is one spaceship. Most pages written
before these rules have no space analogies yet; add them when you rework a
page, using this table.

**The ship**

| Term | Space picture |
| --- | --- |
| The learner | An astronaut (a cadet on their first missions) |
| Linux machine / virtual machine | A spaceship |
| Lab virtual machine (`qemu`) | A training ship in the simulator |
| Two machines on one network (`data-001`, `data-002`) | Two ships flying in formation, linked by their communications arrays |
| Kernel | The ship's core: it runs everything and hands out power and time |
| Process | A crew member doing one job |
| Parent and child process | A crew member who hands a task to a new crew member |
| PID | The crew member's badge number |
| Shell (`bash`) | The bridge console where the astronaut types orders |
| Command | An order typed at the console |
| `sudo` / `root` | Borrowing the captain's authority / the captain |

**Signals in and out of a process**

| Term | Space picture |
| --- | --- |
| stdin, stdout, stderr | The three signal lines of a crew member: orders in, reports out, alarms out |
| File descriptor (fd 0, 1, 2) | The numbered socket each signal line plugs into |
| Redirection (`>`, `2>`, `2>&1`) | Re-patching a signal line to another place |
| Pipe (`\|`) | A tube that carries one crew member's reports straight to the next |
| `/dev/null` | An airlock to open space: whatever goes in is gone |
| Exit code (`$?`) | The status code a crew member radios back when the job is done; `0` means success |
| Shell variable | A note on the console: only this console sees it |
| Environment variable / `export` | A line in the briefing pack every new crew member receives / putting the note into that pack |
| `PATH` | The list of decks the ship searches to find a crew member by name |
| Alias | A nickname for an order |
| Shell function | A short standard procedure with its own steps |
| History (`~/.bash_history`) | The bridge's order log |

**Cargo: files, owners and permissions**

| Term | Space picture |
| --- | --- |
| File | A crate in the cargo hold |
| Directory | A cargo compartment that holds crates |
| Filesystem / mount point | A cargo deck / the hatch where that deck is attached to the ship |
| Inode, link count | The crate's manifest card / how many labels point at that card |
| Hard link | A second label on the same crate |
| User, group, other | The crate's owner, the owner's team, everyone else aboard |
| `r`, `w`, `x` | Look inside, change the contents, run it (or walk into the compartment) |
| setuid | An order carried out with the owner's rank, not the caller's |
| setgid on a directory | Every crate stored here gets the team's tag |
| Sticky bit | A shared locker: anyone may store, only the owner may remove |
| `umask` | The default lock setting on every new crate |
| `find` | A cargo search drone: it walks every compartment and reports crates that fit |

**Reading the logs**

| Term | Space picture |
| --- | --- |
| Regular expression | A signal pattern: a shape to look for, not one exact message |
| `grep` | The signal scanner: it keeps only the lines that fit the pattern |
| `sed` | The redaction officer: it rewrites or blanks out lines as they pass |

**The flight log archive (Git)**

| Term | Space picture |
| --- | --- |
| Repository | The flight log archive |
| Working tree / staging area / commit | The open logbook / the outbox tray / an entry sealed into the archive |
| Branch | An alternative flight path |
| Merge / rebase | Joining two flight paths / replaying your path on top of the newest one |
| Remote (`origin`) / clone / fetch | Mission control's copy of the archive / copying the whole archive aboard / downloading mission control's new entries without changing your course |
| `.gitignore` | The list of crates that never go into the archive |

**Storage and supply runs**

| Term | Space picture |
| --- | --- |
| `tar` archive | A sealed shipping container of crates |
| Compression (`gzip`, `bzip2`) | Vacuum-packing the container so it takes less room |
| Full / incremental backup | Shipping every crate / shipping only crates changed since the last run |
| Snapshot file (`--listed-incremental`) | The inventory list that tells the next run what already shipped |
| `df` vs `du` | The deck's fuel gauge (what the filesystem says is used) vs counting the crates you can see |
| Deleted file still held open | A crate taken off the manifest that a crew member still holds: it still takes space |
| `lsof` | The roster of which crew member holds which crate |
| `rsync` | A supply run that copies only what changed to another ship |
| `--delete` / `--link-dest` | Removing crates at the destination that the source no longer has / reusing unchanged crates by adding a second label instead of copying |
| SSH | A sealed communications channel between two ships |

**Services and certificates**

| Term | Space picture |
| --- | --- |
| `systemd` | The ship's duty officer: it starts every station, watches it and restarts it |
| Service | A station that must always be staffed |
| Unit file | The duty card for one station |
| Drop-in override (`systemctl edit`) | A sticky note on the duty card that changes one line |
| `daemon-reload` | Telling the duty officer to read the duty cards again |
| `enable` / `start` | Putting the station on the launch checklist / staffing it right now |
| Journal (`journalctl`) | The ship's log, written by the duty officer |
| Private key | The ship's secret seal: it never leaves the ship |
| Certificate | The ship's ID badge, stamped with its seal |
| SAN (Subject Alternative Name) | The names printed on the badge |
| CSR (certificate signing request) | The badge application form sent to the badge office |
| Self-signed certificate | A badge the ship stamped for itself |
| Certificate authority | The badge office that stamps badges for others |

### The lab machines and what they contain

There is no shared sample application. Every graded lab boots its own
training ship (one Ubuntu 24.04 virtual machine, two for lab-062) and its
`bootstrap/` script sets up a small scenario. The learner works as the user
`candidate` (home `/home/candidate`) with `sudo`. Use these names exactly as
the scripts create them:

| Lab | What the bootstrap sets up |
| --- | --- |
| lab-010 | `/usr/local/bin/service-probe` and an empty `/var/log/monitor` |
| lab-011 | `/bin/output-generator`: one stdout line, one stderr line, exit code `7` |
| lab-012 | An existing exported `VARIABLE1` in `~/.bashrc` |
| lab-020 | Group `ops`, user `opsuser`, `/srv/teamspace/` (`shared`, `bin/deploy.sh`, `dropbox`, `incoming`) |
| lab-021 | Group `analysts`, user `someanalyst`, a shared reports directory, `backup-runner.sh` and a dropbox folder |
| lab-022 | The default system `umask` for `candidate`, with no override yet |
| lab-023 | `/var/backup/backup-015` with files of mixed ages, sizes and permissions |
| lab-030 | Incident `access.log` and `service.log`, and a seeded `~/.bash_history` |
| lab-031 | `/var/log-collector/003/nginx.log` and `server.log` |
| lab-032 | A seeded `~/.bash_history` |
| lab-033 | A file that must be removed with the real, non-aliased `rm` |
| lab-040 | A bare upstream repository `/repositories/deploy-configs.git` with three environment branches |
| lab-041 | Working directories and a throwaway Git identity |
| lab-042 | The source repository `/repositories/auto-verifier` with three candidate branches |
| lab-043 | A bare upstream repository `/repositories/upstream-app.git` with one initial commit |
| lab-050 | `/exports/reports-2026-08.tar.bz2` and `/opt/services` |
| lab-051 | `/imports/import001.tar.bz2` |
| lab-052 | `/srv/appdata` with `notes.txt`, a reports file and a `cache/` directory |
| lab-060 | An extra disk at `/var/log/audit-svc`, `audit-svc.service` holding a deleted log open, and `/backup` |
| lab-061 | An extra disk at `/var/log/reporting-app` and `reporting-app.service` holding a deleted log open |
| lab-062 | Two machines: `data-001` (`10.10.60.5`, source `/srv/appdata`) and `data-002` (`10.10.60.10`, destination `/backup/appdata`) |
| lab-070 | `healthcheck.sh`, its log directory and an empty TLS working directory (`healthcheck.internal.local`) |
| lab-071 | `collector.sh`, to be wrapped as a service |
| lab-072 | The packaged `nginx.service` and a checksum of its vendor unit file |
| lab-073 | `openssl` and an empty working directory `/opt/tls/internal-web-srv1` |

Course pages use small made-up examples (`backup-tool`, `report-tool`,
`/srv/shared`) to show an idea. When a page shows a lab's own names, they
must match the table above.

### Environment facts the text must respect

- **No playgrounds yet.** No module has a `playground/` folder. So landing
  pages have no `<!-- astrona:playground -->` marker, parts have no
  `<!-- astrona:playground:renew -->` marker, and a `## Your mission`
  section has only the `astrona run`, `astrona submit` and
  `astrona destroy` steps (no `astrona stop` or `astrona start` of a
  playground). The reader tries the commands in a part on any Ubuntu 24.04
  machine or inside a running lab. When a playground is added, add the
  markers and the stop and start steps.
- **Labs are virtual machines, not clusters.** Every lab uses
  `runtime.type: "qemu"` with 2 CPUs, 2048 MB of memory and a 15 GB disk.
  The learner reaches it with `astrona ssh <lab name>`; there is no
  `kubectl`.
- **Extra disks are found by serial.** lab-060 and lab-061 add a 2 GB disk.
  Its device letter is not fixed, so scripts reach it through
  `/dev/disk/by-id/virtio-<serial>`. Never tell the reader to use `/dev/vdb`.
- **Two machines in lab-062.** `data-001` has key-based SSH trust to
  `data-002` (`sshAccess`), so `ssh data-002` and `rsync -e ssh` work with
  no password. Both names are in each machine's `/etc/hosts`.
- **Packages are installed by bootstrap.** `rsync`, `openssh-server`,
  `openssl` and `nginx` are installed by the lab scripts that need them. Do
  not tell the reader to install them.
- **Real services, real clocks.** lab-060 and lab-061 run a real service
  that keeps writing through a deleted file. The fix is to truncate the open
  file or restart the service; the graders check that the space came back
  and the legitimate logs stayed.

### Where things are in this repo

| What | Where |
| --- | --- |
| Course outline the platform reads: every reading page and lab, in order. Never list `solution.md` here | `astrona.yaml` |
| Overview, sections table, how to run things | `README.md` |
| Section overview and its modules | `sections/section-0N0/README.md` |
| Module reading: landing page, deep-dive parts, wrap-up | `sections/section-0N0/module-0M/course.md`, `course-0N-*.md` |
| Section knowledge check (multiple choice) | `sections/section-0N0/quiz.md` |
| Final domain quiz | `sections/final-domain-quiz.md` |
| Graded labs, all in one folder: module labs `lab-0NM` (section `0N0`, module `M`) and section capstones `lab-0N0` | `labs/lab-0NN/` |

A lab folder holds:

| Path | Purpose |
| --- | --- |
| `config.yaml` | Lab definition; `metadata.docs` has `question: "docs/question.md"` and `solution: "docs/solution.md"` |
| `README.md` | Short intro with the run command |
| `docs/question.md` | The exam-style task. Starts with `# Question` and a `Solve this question on:` line that names the machine or machines from `config.yaml` (`terminal` by default, for example `` `data-001`, syncing to `data-002` `` in lab-062); keep that line as it is, the platform may use it to pick a machine |
| `docs/solution.md` | Step-by-step walkthrough with real output |
| `bootstrap/` | Starting state of the machine, never the graded result |
| `validation/` | Grading scripts that check the machine's real state |

### Lab metadata in `astrona.yaml`

`astrona.yaml` has one entry per section under `modules:` (`module-010`,
`module-020` and so on, plus `module-080` for the final quiz). Each
section's `content` lists, in order: the section `README.md`, then for each
module its landing page, its parts, and right after the part a lab tests, a
`Question` reading (`labs/lab-0NN/docs/question.md`) followed by the
`type: lab` entry; the module's wrap-up page comes last. The section quiz
and then the section capstone close the section.

Every `type: lab` entry (module labs and capstones) carries these fields, in
this order:

```yaml
      - type: reading
        title: Question
        path: labs/lab-011/docs/question.md
      - type: lab
        title: "Shell Redirection & Exit Code Diagnostics Lab"
        path: labs/lab-011
        difficulty: intermediate
        estimated_duration: 15m
        topic: redirection
        task_kind: build
        tags: [stdout, stderr, redirection, exit-codes, dev-null]
        learning_goals:
          - Send a program's stdout and stderr to separate files
          - Capture both streams in one file with the redirections in the right order
          - Record a program's exit code before another command overwrites it
        resources:
          - name: "Bash Reference Manual: Redirections"
            url: https://www.gnu.org/software/bash/manual/html_node/Redirections.html
```

- `difficulty`: `beginner`, `intermediate` or `advanced`.
- `estimated_duration`: realistic time to solve it, for example `15m`, `30m`, `45m`.
- `topic`: exactly one of `redirection`, `environment`, `permissions`,
  `file-search`, `text-processing`, `shell-usage`, `git`, `archiving`,
  `backup`, `disk-space`, `remote-sync`, `services`, `certificates`.
- `task_kind`: exactly one of `build` (create the result from scratch),
  `troubleshooting` (find and fix what is broken) or `migration` (move a
  working setup to another form or place, for example one archive format to
  another). The platform filters labs by it, so it is a field of its own,
  never a tag.
- `tags`: 4 to 8 ids, only from the tag list below. Add a new tag to the list
  first if nothing fits.
- `learning_goals`: 2 or 3 plain sentences, each starting with a verb, saying
  what the learner proves in this lab.
- `resources`: 1 to 4 documentation pages, each with a `name` and a `url`
  that loads. This is the **only** place outside links are allowed: the
  platform shows them as optional further reading next to the lab.

**Tag list** (lower case, hyphens, never synonyms):

- Shell: `stdout`, `stderr`, `redirection`, `exit-codes`, `dev-null`,
  `environment-variables`, `export`, `bashrc`, `shell-scripts`,
  `history`, `aliases`, `alias-bypass`, `shell-functions`,
  `non-interactive-shell`, `ip-address`
- Permissions: `chmod`, `octal-mode`, `symbolic-mode`, `setuid`, `setgid`,
  `sticky-bit`, `umask`, `chown`, `groups`
- Finding and text: `find`, `file-age`, `file-size`, `file-permissions`,
  `grep`, `sed`, `regular-expressions`, `log-analysis`
- Git: `git-clone`, `git-commit`, `git-branch`, `git-merge`, `git-rebase`,
  `git-remote`, `git-log`, `git-diff`, `gitignore`
- Archives and backup: `tar`, `gzip`, `bzip2`, `incremental-backup`,
  `restore`, `exclude`, `archive-verification`
- Disk and sync: `df`, `du`, `lsof`, `deleted-open-files`, `rsync`,
  `link-dest`, `ssh`
- Services: `systemd`, `unit-files`, `drop-in-override`, `daemon-reload`,
  `systemctl`, `journalctl`, `restart-policy`
- Certificates: `openssl`, `private-key`, `self-signed-certificate`, `csr`,
  `subject-alt-name`, `key-certificate-match`

### Running things

```bash
# Lab or capstone (graded against the live virtual machine)
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-011
astrona ssh ats-006-lab-011        # open a terminal on the lab machine
astrona submit -c labs/lab-011
astrona destroy ats-006-lab-011    # takes metadata.name from config.yaml, not the path

# Authors: run a local, uncommitted copy and check its configuration
astrona run -c labs/lab-011
astrona validate -c labs/lab-011
```

Names: every lab is `ats-006-lab-<number>`, the folder number
(`ats-006-lab-010` to `ats-006-lab-073`). A new lab takes the next free
number in its section, so two labs never share a name. The local
developer build of `astrona validate` currently reports
`unknown field "solution"` and `"question"` in `metadata.docs` for every
lab in every course; that is a validator issue, not a lab issue.

Graders check **the machine's real state** (file modes, file contents, Git
history, archive listings, a running service, a matching key and
certificate), not what the learner typed. A lab's `question.md` and
`solution.md` must match what its `validation/` scripts actually check.

Test machines on the maintainer's computer: one at a time. Podman has 10 GiB
and also runs the platform stack; parallel labs run it out of memory.

### Where to find trusted sources

Check facts here before writing them down. Prefer these over memory.

- **Shell:** the Bash Reference Manual,
  <https://www.gnu.org/software/bash/manual/bash.html> (redirections,
  shell parameters, environment, aliases, history).
- **Core tools:** GNU Coreutils
  <https://www.gnu.org/software/coreutils/manual/>, GNU findutils
  <https://www.gnu.org/software/findutils/manual/html_mono/find.html>, GNU
  grep <https://www.gnu.org/software/grep/manual/grep.html>, GNU sed
  <https://www.gnu.org/software/sed/manual/sed.html>, GNU tar
  <https://www.gnu.org/software/tar/manual/>.
- **Git:** the Pro Git book and reference, <https://git-scm.com/book> and
  <https://git-scm.com/docs>.
- **rsync:** <https://download.samba.org/pub/rsync/rsync.1>.
- **systemd:** <https://www.freedesktop.org/software/systemd/man/latest/>
  (`systemd.unit`, `systemd.service`, `systemctl`).
- **OpenSSL:** <https://docs.openssl.org/3.0/man1/> (`openssl-req`,
  `openssl-x509`, `openssl-genpkey`).
- **Ubuntu specifics:** <https://manpages.ubuntu.com/> for the 24.04 (noble)
  man pages the labs run.
- **The exam itself:** the LFCS page on the Linux Foundation training site
  lists the official curriculum. The domain weight (20%) and the exam topic
  names above come from this repository's README and `astrona.yaml` and have
  not been re-checked against it.

### Skills to use here

The `astrona-course-*` skills do most authoring jobs in this repository: planning
(`domain-plan`), creating the tree (`domain-scaffold`), building modules
(`domain-build`), deep-dive parts (`deep-dive`), labs and playgrounds (`lab`),
lab docs (`lab-docs`), challenges (`create-challenge`), quizzes
(`generate-assessment`) and fact-checking (`review-accuracy`).
