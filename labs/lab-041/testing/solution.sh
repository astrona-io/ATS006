#!/usr/bin/env bash
set -euo pipefail
mkdir -p /home/candidate/projects/log-parser
cd /home/candidate/projects/log-parser
git init
printf '# log-parser\n' > README.md
printf '#!/usr/bin/env bash\necho "parsing logs"\n' > parser.sh
git add README.md parser.sh
git commit -m 'initial commit'
printf '# Usage: ./parser.sh <logfile>\n' >> parser.sh
git add parser.sh
git commit -m 'add usage comment to parser.sh'
printf 'build/\n' > .gitignore
git add .gitignore
git commit -m 'add .gitignore for build artifacts'
git init --bare /repositories/log-parser-origin.git
git remote add origin /repositories/log-parser-origin.git
git push -u origin main

