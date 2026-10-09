# Archiving, Compression & Backup Strategy

Astronaut, every other skill you train eventually produces something worth protecting: a configuration you tuned by hand, a dataset a team depends on, a service directory you do not want to rebuild from memory. This section is about the two habits that keep that cargo safe. You pack data into sealed shipping containers (archives) with the right vacuum-packing (compression), and you run a real, provable backup strategy instead of keeping a folder of `.tar.gz` files nobody has ever restored.

Both habits use the same tool, `tar`, but they test different instincts. Converting an archive's compression is a precision job: get the flags right and prove nothing was lost. Running a backup strategy is a discipline job: keep the permissions that matter, leave out what should not be copied, do not repeat full work every night, and never trust a backup until you have restored it and compared it with the original.

**Exam topic covered:** archive, back up, compress and restore files

---

## What You Will Master

- The difference between the archive (`tar`) and the compression (`gzip`, `bzip2`, `xz`), and which program does each job.
- Forcing the best gzip level through `tar` with `--use-compress-program="gzip -9"`, and proving it from the gzip header.
- Listing an archive without extracting it, and proving two archives hold the same files with sorted listings and `diff`.
- Converting a bzip2 archive to gzip without ever writing to the original.
- Keeping ownership and permissions with `-p` on both backup and restore.
- Leaving a directory out with `--exclude`, and writing the pattern so it matches the stored, relative path.
- Full and true incremental backups with `--listed-incremental`, and why the snapshot file must survive between runs.
- Restoring a full backup alone and with incrementals layered on top, and proving the result with `diff -r` and `stat`.

---

## Modules In This Section

Work through the modules in this order. Each part teaches one idea. A mission (a graded lab) comes right after the part it practises, and the last page of each module is a wrap-up. The capstone at the end uses everything in the section at once.

### [Archive Conversion & Content Verification](module-01/course.md)

2 parts and 1 mission:

1. [Archives And Compressors](module-01/course-01-archives-and-compressors.md)
2. [Convert And Prove](module-01/course-02-convert-and-prove.md)
   - Mission: [Archive Conversion & Verification Lab](../../labs/lab-051/docs/question.md)
3. [Wrap-Up: Mission Debrief](module-01/course-03-wrap-up.md)

### [Backup Strategy with tar](module-02/course.md)

3 parts and 1 mission:

1. [Permissions And Excludes](module-02/course-01-permissions-and-excludes.md)
2. [Full And Incremental Backups](module-02/course-02-full-and-incremental-backups.md)
3. [Restore And Prove](module-02/course-03-restore-and-prove.md)
   - Mission: [tar Backup Strategy Lab](../../labs/lab-052/docs/question.md)
4. [Wrap-Up: Mission Debrief](module-02/course-04-wrap-up.md)

### Knowledge check

Test your reasoning before the capstone: **[Section Knowledge Check Quiz](./quiz.md)**.

### Capstone

Your final mission for this section: **[Archiving & Backup Capstone Lab](../../labs/lab-050/docs/question.md)**. It asks you to convert a report archive to gzip with proof, and, separately, to run a full and incremental backup of a service directory and prove both restores.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-050
astrona ssh ats-006-lab-050
astrona submit -c labs/lab-050
astrona destroy ats-006-lab-050
```
