# Question

Solve this question on: `terminal` (playing the role of `data-001` from the scenario)

Astronaut, a supply archive has docked at this training ship. It is vacuum-packed with `bzip2`, and mission control needs it repacked with `gzip`, as tightly as possible, with proof that no crate went missing.

There is an archive `/imports/import001.tar.bz2` on the machine. Create a new gzip-compressed archive with its raw contents:

1. Store the new archive at `/imports/import001.tar.gz`.
2. Use the best possible gzip compression (level 9).
3. To make sure both archives contain the same files, write a sorted list of the contents of each archive into `/imports/import001.tar.bz2_list` and `/imports/import001.tar.gz_list`.
4. Do not modify or delete the original archive `/imports/import001.tar.bz2`.
<!-- curriculum-links -->

## Related lessons and assessment

Read [module-01](../../../sections/section-050/module-01/course.md).

The grader checks:

- Confirms the gzip archive was created at max compression, both sorted listings exist and match, and the original bz2 archive is byte-for-byte untouched.

Use the inspection commands in the solution to check your work. Submit when you have finished; submission ends this environment.
