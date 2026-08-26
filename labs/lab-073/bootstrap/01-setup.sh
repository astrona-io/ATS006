#!/usr/bin/env bash
# Bootstrap: ensures openssl is installed and creates the empty working
# directory for the student's key/cert/CSR generation. Does NOT generate
# any key, certificate, or CSR material -- that is the graded task.

set -eu

if ! command -v openssl >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y openssl
fi

sudo mkdir -p /opt/tls/internal-web-srv1
sudo chown "$(whoami)":"$(whoami)" /opt/tls/internal-web-srv1
