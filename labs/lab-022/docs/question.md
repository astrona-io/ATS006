# Question

Solve this question on: `terminal`

Working directory conventions need setting up for user `candidate`:

1. New files `candidate` creates anywhere should default to `640` (owner read/write, group read, other nothing) and new directories should default to `750` — persistently, for every future login.
2. Before making the change, show the math: given the *current* default umask, compute by hand what permissions a brand-new file and a brand-new directory would get, and verify your prediction against an actual test file/directory.
3. After the change, prove that a new file really does come out `640` and a new directory `750`, without needing to run any `chmod` afterward.
