# Question

Solve this question on: `terminal` (playing the role of `ops-001` from the scenario)

Your team's shared deployment configuration lives in a bare upstream repository at `/repositories/deploy-configs.git`, containing a `main` branch and three candidate environment branches: `env-staging`, `env-canary`, and `env-prod`. Complete the following operations, in order:

1. Clone `/repositories/deploy-configs.git` to `/home/candidate/deploy-configs`.
2. Without checking any of the three candidate branches out, inspect `app.conf` on each and find the one branch where `feature_flag: enabled`. Merge only that branch into `main`.
3. Create a new directory `scripts/` at the top level of the repository. Since Git won't track an empty directory, add a hidden empty placeholder file `scripts/.keep` inside it. Stage and commit this with the message `"add scripts directory"`.
4. Push your updated `main` branch back to `origin` with upstream tracking configured (`-u`).
5. Create a new topic branch named `bump-retry-limit` off `main`. On that branch, edit `app.conf` so `retry_limit: 3` becomes `retry_limit: 10`, then commit that single focused change with the message `"increase retry limit to 10"`.
6. Simulate a teammate pushing directly to the shared upstream while you were working: clone `/repositories/deploy-configs.git` again into a throwaway directory of your choice, on its `main` branch append a new line `timeout: 60` to `app.conf`, commit with the message `"add default timeout to app.conf"`, and push it to `origin`'s `main`. Discard the throwaway clone afterward.
7. Back in `/home/candidate/deploy-configs`, fetch the new upstream history and **rebase** `bump-retry-limit` onto the updated `origin/main`, so your retry-limit commit replays cleanly on top of the teammate's timeout commit.
8. Fast-forward `main` to the new `origin/main`, then fast-forward `main` again to include your rebased `bump-retry-limit` branch, and push the final `main` back to `origin`.
