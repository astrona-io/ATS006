# Question

Solve this question on: `terminal`

Astronaut, new crates on this ship come out with the wrong default lock. Set up the default permissions for the user `candidate`:

1. New files that `candidate` creates anywhere must default to `640` (owner read and write, group read, others nothing). New directories must default to `750`. This must last for every future login, and it must come from the user's `umask`, not from `chmod`.
2. Before you make the change, show the math: from the *current* `umask`, work out by hand which permissions a brand-new file and a brand-new directory would get, and check your prediction against a real test file and directory.
3. After the change, prove that a new file really comes out `640` and a new directory `750` in a fresh login, without running any `chmod` afterwards.

The grader starts a fresh login shell for `candidate`, creates a file and a directory in the home directory, and checks that they come out `640` and `750`.
