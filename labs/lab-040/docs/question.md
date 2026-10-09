# Question

Solve this question on: `terminal` (playing the role of `ops-001` from the scenario)

Astronaut, this is the section capstone. Your team's shared deployment configuration lives in a bare upstream repository at `/repositories/deploy-configs.git`. It has a `main` branch and three candidate environment branches: `env-staging`, `env-canary` and `env-prod`. Each candidate sets `feature_flag` in `app.conf` to a different value. Complete these operations, in order:

1. Clone `/repositories/deploy-configs.git` to `/home/candidate/deploy-configs`.
2. Without checking any of the three candidate branches out, read `app.conf` on each one and find the one branch where `feature_flag: enabled`. Merge only that branch into `main`.
3. Create a new directory `scripts/` at the top of the repository. Git does not track an empty directory, so add a hidden empty placeholder file `scripts/.keep` inside it. Stage and commit only this file with the message `add scripts directory`.
4. Push your updated `main` branch back to `origin` with upstream tracking (`-u`).
5. Create a new topic branch named `bump-retry-limit` off `main`. On that branch, edit `app.conf` so `retry_limit: 3` becomes `retry_limit: 10`, then commit that single focused change with the message `increase retry limit to 10`.
6. Simulate a teammate pushing straight to the shared upstream while you were working: clone `/repositories/deploy-configs.git` again into a throwaway directory of your choice, on its `main` branch append a new line `timeout: 60` to `app.conf`, commit with the message `add default timeout to app.conf`, and push it to `origin`'s `main`. Delete the throwaway clone afterwards.
7. Back in `/home/candidate/deploy-configs`, fetch the new upstream history and **rebase** `bump-retry-limit` onto the updated `origin/main`, so your retry-limit commit replays cleanly on top of the teammate's timeout commit.
8. Fast-forward `main` to the new `origin/main`, then fast-forward `main` again to include your rebased `bump-retry-limit` branch, and push the final `main` back to `origin`.

The grader reads the upstream repository. Its `main` must have a straight history with no merge commits, holding exactly these commits, oldest first: `initial commit`, `enable feature flag for canary rollout`, `add scripts directory`, `add default timeout to app.conf`, `increase retry limit to 10`. The final `app.conf` on `main` must be:

```
feature_flag: enabled
retry_limit: 10
max_connections: 100
log_level: info
timeout: 60
```
