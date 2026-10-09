# Question

Solve this question on: `terminal`

Astronaut, your crew is starting a brand-new internal tool from scratch: a log parser. There is nothing to clone and no history yet. Mission control wants its flight log archive built cleanly from the first entry, and a second copy kept at a stand-in remote.

Bootstrap has already created the directories `/home/candidate/projects` and `/repositories` and set a Git identity for you.

1. Initialize a new Git repository at `/home/candidate/projects/log-parser`.
2. Create a `README.md` and a `parser.sh` script, check the repository's status, then stage and commit both files together with the message `initial commit`.
3. Edit `parser.sh` to add a comment line that contains the word `Usage`. Inspect exactly what changed before you stage it, then stage and commit that change on its own with the message `add usage comment to parser.sh`.
4. The tool's build will later create a `build/` directory full of compiled files. Before that happens, create a `.gitignore` with the line `build/`, so `build/` and everything inside it stays out of the repository for good. Commit it with the message `add .gitignore for build artifacts`.
5. Create a bare repository at `/repositories/log-parser-origin.git` as a stand-in for a real remote. Register it as the `origin` remote of your repository, and push your `main` branch to it with upstream tracking (`-u`).
6. Confirm that `git fetch` and `git pull` both work against `origin` with no extra arguments.

The history on `main` must hold exactly these three commits, oldest first: `initial commit`, `add usage comment to parser.sh`, `add .gitignore for build artifacts`. `origin`'s `main` must point at the same commit as your local `main`.
