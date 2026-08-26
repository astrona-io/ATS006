#!/usr/bin/env bash
# Bootstrap: pre-stages a file that the student must remove later using
# the real, non-aliased rm (via the backslash-escape trick) without
# disabling the rm safety alias for anything else. Bootstrap does not
# touch aliases or .bashrc itself -- that persistence is the graded task.

set -eu

echo "temporary artifact -- remove with the real rm, not the aliased one" > "$HOME/lab-artifact-to-delete.txt"
