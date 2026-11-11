# Question

Solve this question on: `terminal`

Astronaut, tidy the cargo hold in `/home/candidate/cargo`. Work as `candidate`, and use `sudo` only where you must.

1. Create the directory tree `/home/candidate/cargo/archive/2026/q1` with one command. The parent folders do not exist yet.
2. Copy `/home/candidate/cargo/manifest.txt` into `/home/candidate/cargo/archive/2026/q1/`. The copy must keep the **mode** and the **modification time** of the original. Leave the original where it is.
3. **Move** `/home/candidate/cargo/old-crew.txt` into `/home/candidate/cargo/archive/2026/`. It must no longer exist in the old place.
4. Create a **hard link** `/home/candidate/cargo/crew-hard.txt` to `/home/candidate/cargo/crew.txt`, and a **symbolic link** `/home/candidate/cargo/crew-soft.txt` that points at `crew.txt` with a relative target.
5. **Remove** the folder `/home/candidate/cargo/scratch` with everything inside it.
6. Give the group `loaders` ownership of `/home/candidate/cargo/crates` and everything inside it. The owner must stay `candidate`.

The grader checks the tree, the preserved mode and time, the inode numbers of the hard link, the target of the symbolic link and the group of every file under `crates`.
<!-- curriculum-links -->

## Related lessons and assessment

Read [module-04](../../../sections/section-020/module-04/course.md).

The grader checks:

- Checks the new tree, the preserved copy, the moved file, the hard link, the symbolic link, the removed folder and the group ownership.

Use the inspection commands in the solution to check your work. Submit when you have finished; submission ends this environment.
