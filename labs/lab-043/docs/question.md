# Question

Solve this question on: `terminal`

Your team publishes shared configuration through a repository your group treats as read-mostly upstream. A bare repository already exists at `/repositories/upstream-app.git`, seeded with one initial commit containing `config.yaml`:

```
timeout: 30
max_connections: 100
log_level: info
retries: 3
```

1. Clone `/repositories/upstream-app.git` to `/home/candidate/repositories/upstream-app`.
2. Create a local topic branch named `fix-timeout-value` off the default branch.
3. On that branch, change `timeout: 30` to `timeout: 90` in `config.yaml` and commit that single focused change with the message `"increase timeout to 90s"`.
4. Using Git's history and diff tools, show exactly what `fix-timeout-value` changed relative to the commit it branched from.
5. Simulate upstream having moved on without you: using a separate throwaway clone of `/repositories/upstream-app.git`, change `retries: 3` to `retries: 5` in `config.yaml` directly on its default branch, commit with the message `"bump retry count for flaky network"`, and push it to `origin`'s default branch. Discard the throwaway clone afterward.
6. Back in `/home/candidate/repositories/upstream-app`, fetch that change and reconcile `fix-timeout-value` with the new upstream tip using a **rebase**, ending with your focused commit replayed cleanly on top of upstream's latest state.
