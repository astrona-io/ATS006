# Question

Solve this question on: `terminal`

Astronaut, the Auto-Verifier application keeps its settings in a Git repository, and three crew members have each proposed a different flight path for one setting. Mission control wants only the path that opens user registration joined to the main course, plus a new directory for logs.

The source repository is at `/repositories/auto-verifier`.

1. Clone `/repositories/auto-verifier` to `/home/candidate/repositories/auto-verifier`.
2. In the new clone, find which one of the branches `dev4`, `dev5` and `dev6` has a `config.yaml` containing `user_registration_level: open`.
3. Merge only that branch into the branch `main`. Do not merge the other two.
4. On `main`, create a new directory `logs` at the top of the repository. So that the directory gets committed, create a hidden empty file `.keep` inside it.
5. Commit only `logs/.keep` with the message `added log directory`.

When you finish, the clone must be checked out on `main`, and the last commit on `main` must be the `added log directory` commit.
