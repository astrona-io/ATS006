#!/usr/bin/env bash
set -u

REPO=/home/candidate/projects/log-parser
ORIGIN=/repositories/log-parser-origin.git

if [ ! -d "$REPO/.git" ]; then
  echo "FAIL: no git repository found at $REPO"
  exit 1
fi

# Exact commit history, oldest to newest.
messages=$(git -C "$REPO" log --reverse --format=%s 2>/dev/null)
expected=$'initial commit\nadd usage comment to parser.sh\nadd .gitignore for build artifacts'

if [ "$messages" != "$expected" ]; then
  echo "FAIL: commit history does not match expected 3 commits in order (got: $(echo "$messages" | tr '\n' ' | '))"
  exit 1
fi

if [ ! -f "$REPO/README.md" ] || [ ! -f "$REPO/parser.sh" ]; then
  echo "FAIL: README.md and/or parser.sh missing from working tree"
  exit 1
fi

if ! grep -q "Usage" "$REPO/parser.sh"; then
  echo "FAIL: parser.sh does not contain the expected usage comment"
  exit 1
fi

if [ ! -f "$REPO/.gitignore" ] || ! grep -q "^build/$" "$REPO/.gitignore"; then
  echo "FAIL: .gitignore missing or does not ignore build/"
  exit 1
fi

if ! git -C "$REPO" check-ignore -q build/output.bin; then
  echo "FAIL: build/output.bin is not actually ignored by .gitignore"
  exit 1
fi

origin_url=$(git -C "$REPO" remote get-url origin 2>/dev/null)
if [ "$origin_url" != "$ORIGIN" ]; then
  echo "FAIL: origin remote is not set to $ORIGIN (got: '${origin_url:-none}')"
  exit 1
fi

upstream=$(git -C "$REPO" rev-parse --abbrev-ref main@{upstream} 2>/dev/null)
if [ "$upstream" != "origin/main" ]; then
  echo "FAIL: local main is not tracking origin/main (got: '${upstream:-none}')"
  exit 1
fi

if [ ! -d "$ORIGIN" ]; then
  echo "FAIL: bare repository $ORIGIN was not created"
  exit 1
fi

if ! git -C "$ORIGIN" rev-parse --is-bare-repository >/dev/null 2>&1 || \
   [ "$(git -C "$ORIGIN" rev-parse --is-bare-repository)" != "true" ]; then
  echo "FAIL: $ORIGIN is not a bare repository"
  exit 1
fi

local_head=$(git -C "$REPO" rev-parse main 2>/dev/null)
remote_head=$(git -C "$ORIGIN" rev-parse main 2>/dev/null)

if [ -z "$remote_head" ] || [ "$local_head" != "$remote_head" ]; then
  echo "FAIL: origin's main does not match local main (local: ${local_head:-none}, origin: ${remote_head:-none})"
  exit 1
fi

echo "PASS: log-parser history, .gitignore, and origin remote all match the expected end-state"
exit 0
