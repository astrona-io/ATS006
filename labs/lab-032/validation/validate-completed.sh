#!/usr/bin/env bash
set -u

BASHRC="$HOME/.bashrc"

check_setting() {
  local pattern="$1"
  if ! grep -Eq "$pattern" "$BASHRC" 2>/dev/null; then
    echo "FAIL: $BASHRC is missing a required setting matching: $pattern"
    exit 1
  fi
}

check_setting '^[[:space:]]*export[[:space:]]+HISTSIZE=5000[[:space:]]*$'
check_setting '^[[:space:]]*export[[:space:]]+HISTFILESIZE=10000[[:space:]]*$'
check_setting '^[[:space:]]*export[[:space:]]+HISTCONTROL=ignoreboth[[:space:]]*$'
check_setting '^[[:space:]]*export[[:space:]]+HISTTIMEFORMAT='

RECOVERED="$HOME/recovered-ssh-command.txt"
BEFORE="$HOME/command-before-ssh.txt"

if [ ! -f "$RECOVERED" ]; then
  echo "FAIL: $RECOVERED does not exist"
  exit 1
fi

expected_ssh="ssh admin@db-02.internal"
actual_ssh=$(cat "$RECOVERED")
if [ "$actual_ssh" != "$expected_ssh" ]; then
  echo "FAIL: $RECOVERED content is '$actual_ssh', expected '$expected_ssh'"
  exit 1
fi

if [ ! -f "$BEFORE" ]; then
  echo "FAIL: $BEFORE does not exist"
  exit 1
fi

expected_before="sudo systemctl restart nginx"
actual_before=$(cat "$BEFORE")
if [ "$actual_before" != "$expected_before" ]; then
  echo "FAIL: $BEFORE content is '$actual_before', expected '$expected_before'"
  exit 1
fi

echo "PASS: history configuration is persisted and both recovered commands are correct"
exit 0
