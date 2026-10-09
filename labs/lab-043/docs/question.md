# Question

Solve this question on: `terminal`

Astronaut, your crew shares its configuration through a flight log archive that everyone treats as a read-mostly upstream. You will branch off, make one focused change, and then bring your work back in line after a teammate pushes a change of their own.

A bare repository already exists at `/repositories/upstream-app.git`. Its `main` branch has one commit with this `config.yaml`:

```
timeout: 30
max_connections: 100
log_level: info
retries: 3
```

1. Clone `/repositories/upstream-app.git` to `/home/candidate/repositories/upstream-app`.
2. Create a local topic branch named `fix-timeout-value` off the default branch.
3. On that branch, change `timeout: 30` to `timeout: 90` in `config.yaml`, and commit that single focused change with the message `increase timeout to 90s`.
4. Using Git's history and diff tools, show exactly what `fix-timeout-value` changed compared with the commit it branched from.
5. Simulate the upstream moving on without you: in a separate throwaway clone of `/repositories/upstream-app.git`, change `retries: 3` to `retries: 5` in `config.yaml` directly on its default branch, commit with the message `bump retry count for flaky network`, and push it to `origin`'s default branch. Delete the throwaway clone afterwards.
6. Back in `/home/candidate/repositories/upstream-app`, fetch that change and bring `fix-timeout-value` up to date with the new upstream tip using a **rebase**. Your focused commit must end up replayed directly on top of the upstream commit, with no merge commit.
