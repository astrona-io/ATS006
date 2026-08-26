# Question

Solve this question on: `terminal` (playing the role of `data-001` from the scenario)

You're asked to perform changes in the Git repository of the Auto-Verifier app.

1. Clone repository `/repositories/auto-verifier` to `/home/candidate/repositories/auto-verifier`.
2. In the newly cloned directory, find which one of the branches `dev4`, `dev5`, and `dev6` has a `config.yaml` containing `user_registration_level: open`.
3. Merge only that branch into branch `main`.
4. In branch `main`, create a new directory `logs` at the top level of the repository. To ensure the directory gets committed, create a hidden empty file `.keep` inside it.
5. Commit your change with the message `"added log directory"`.
