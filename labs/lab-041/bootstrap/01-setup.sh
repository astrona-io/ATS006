#!/usr/bin/env bash
# Bootstrap: pre-stages the directories the scenario expects to exist and
# configures a throwaway global git identity so the student's own `git
# init`/`git commit` calls don't fail on a machine with no git identity
# configured. It does NOT create the log-parser repository or the bare
# "origin" repository -- both are part of the graded task.

set -eu

sudo mkdir -p /home/candidate/projects
sudo chown -R "$(whoami):$(whoami)" /home/candidate

sudo mkdir -p /repositories
sudo chown -R "$(whoami):$(whoami)" /repositories

git config --global user.email "candidate@lab.local"
git config --global user.name "Candidate"
git config --global init.defaultBranch main
