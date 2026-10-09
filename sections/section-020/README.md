# Permissions & File Triage

Astronaut, this section is about one of the oldest problems on a shared ship: who may look inside a crate, change it or run it, and what lock a brand-new crate gets before anyone touches it. A file is a crate in the cargo hold, and a directory is a compartment that holds crates. Every crate carries a lock badge for its owner, the owner's team, and everyone else aboard.

Two tools decide almost every permission on a Linux machine. `chmod` sets a file's permissions right now, including three special bits beyond read, write and execute. The `umask` decides the permissions a file gets the moment it is created, before anyone runs `chmod`. A shared folder with the wrong group bit, or a service with the wrong `umask`, causes exactly the "it works for me" problems that eat hours.

Once you can set and read permissions with confidence, the next skill is finding files by the things that matter in daily work: age, size and permission. `find`, your cargo search drone, sorts thousands of files safely, without a single line of custom script.

**Exam topics covered:** file permissions, searching for files

---

## What You Will Master

- Reading the nine permission bits in `ls -l`, and writing them in symbolic (`u+x`, `go-w`) and octal (`750`) notation.
- Turning a plain-English requirement into an octal mode by hand.
- Changing a whole tree safely with capital `X`, so plain data files never become executable.
- The three special bits: setuid (`4000`), setgid (`2000`) and sticky (`1000`), and what each does on a file and on a directory.
- Why a new file starts from `666` and a new directory from `777`, and how the `umask` switches bits off.
- Working backwards from a required result to the mask, and making the mask last for every login.
- Why services have their own `umask`, and why a team folder needs setgid as well as a loose mask.
- Matching files with `find` by absolute date (`-newermt`), by size (`-size`) and by permission (`-perm`), and acting on them with `-delete` and `-exec`.
- Running a triage of several passes in the order given, with `-maxdepth 1`, so no pass undoes another.

---

## Modules In This Section

Work through the modules in this order. Each part teaches one idea. A mission (a graded lab) comes right after the part it practises, and the last page of each module is a wrap-up. The capstone at the end uses everything in the section at once.

### [chmod: Symbolic vs Octal, and the Three Special Bits](module-01/course.md)

2 parts and 1 mission:

1. [Reading And Setting Permission Bits](module-01/course-01-reading-and-setting-permission-bits.md)
2. [The Three Special Bits](module-01/course-02-the-three-special-bits.md)
   - Mission: [chmod Permission Bits Lab](../../labs/lab-021/docs/question.md)
3. [Wrap-Up: Mission Debrief](module-01/course-03-wrap-up.md)

### [umask: Why New Files Are Not 777 By Default](module-02/course.md)

2 parts and 1 mission:

1. [How The umask Shapes New Files](module-02/course-01-how-the-umask-shapes-new-files.md)
2. [Making The umask Stick](module-02/course-02-making-the-umask-stick.md)
   - Mission: [umask Default Permissions Lab](../../labs/lab-022/docs/question.md)
3. [Wrap-Up: Mission Debrief](module-02/course-03-wrap-up.md)

### [Find, Filter, And Triage Files By Age, Size, And Permission](module-03/course.md)

2 parts and 1 mission:

1. [Matching Files By Age, Size And Permission](module-03/course-01-matching-files-by-age-size-and-permission.md)
2. [Triage In The Right Order](module-03/course-02-triage-in-the-right-order.md)
   - Mission: [find Triage by Criteria Lab](../../labs/lab-023/docs/question.md)
3. [Wrap-Up: Mission Debrief](module-03/course-03-wrap-up.md)

### Knowledge check

Before the capstone, test your reasoning with the **[Section 020 Knowledge Check](quiz.md)**: scenario questions with a full explanation for every answer.

### Capstone

Your final mission for this section: **[Permissions & File Triage Capstone Lab](../../labs/lab-020/docs/question.md)**. You set a persistent `umask` for a user, lock down a shared team workspace with setgid, owner-only and sticky permissions, and triage a legacy folder with `find`, all on one training ship.
