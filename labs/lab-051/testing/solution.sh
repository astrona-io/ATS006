#!/usr/bin/env bash
sudo -n bash <<'ARCHIVE_REFERENCE'
set -euo pipefail
tar -tjf /imports/import001.tar.bz2 | sort > /imports/import001.tar.bz2_list
work=$(mktemp -d)
tar -xjf /imports/import001.tar.bz2 -C "$work"
tar --use-compress-program='gzip -9' -cf /imports/import001.tar.gz -C "$work" .
tar -tzf /imports/import001.tar.gz | sort > /imports/import001.tar.gz_list
rm -rf "$work"

ARCHIVE_REFERENCE
