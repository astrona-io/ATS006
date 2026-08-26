# Question

Solve this question on: `terminal`

You're starting a brand-new internal tool from scratch — nothing to clone, no existing history.

1. Initialize a new Git repository at `/home/candidate/projects/log-parser`.
2. Create a `README.md` and a `parser.sh` script, check the repository's status, then stage and commit both files together with the message `"initial commit"`.
3. Edit `parser.sh` to add a comment line, inspect exactly what changed before staging it, then stage and commit that change separately with the message `"add usage comment to parser.sh"`.
4. The tool's build process will eventually generate a `build/` directory full of compiled artifacts. Before that happens, create a `.gitignore` that keeps `build/` (and everything inside it) out of the repository permanently, and commit it with the message `"add .gitignore for build artifacts"`.
5. Treat `/repositories/log-parser-origin.git` (a bare repository you create yourself as a stand-in for a real remote) as `origin`: initialize it, register it as your `origin` remote, and push your `main` branch to it with upstream tracking configured (`-u`).
6. Confirm `git fetch` and `git pull` both work against `origin` with no additional flags after that.
