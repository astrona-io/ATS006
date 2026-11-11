#!/usr/bin/env bash
set -euo pipefail
rsync -az --delete --exclude=tmp/ -e ssh /srv/appdata/ data-002:/backup/appdata/
ssh data-002 'mkdir -p /backup/snapshots/snap2'
rsync -az --exclude=tmp/ -e ssh --link-dest=/backup/appdata /srv/appdata/ data-002:/backup/snapshots/snap2/

