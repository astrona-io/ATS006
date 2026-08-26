#!/usr/bin/env bash
# Bootstrap: seeds /imports/import001.tar.bz2 with a small multi-file
# dataset (loose files plus one subdirectory) so the student has real
# content to convert and verify. Does NOT create the gzip archive or the
# listing files -- that is the graded task.

set -eu

sudo mkdir -p /imports

STAGE=$(mktemp -d)

cat > "$STAGE/customers.csv" <<'EOF'
id,name,plan
1001,Nova Ridge Logistics,enterprise
1002,Blue Anchor Traders,standard
1003,Silverline Metals,enterprise
EOF

cat > "$STAGE/orders.json" <<'EOF'
[
  {"order_id": 5001, "customer_id": 1001, "total": 4820.50},
  {"order_id": 5002, "customer_id": 1003, "total": 1190.00}
]
EOF

mkdir -p "$STAGE/notes"
cat > "$STAGE/notes/import-notes.txt" <<'EOF'
Q3 batch import - reconciled against finance ledger on intake.
Treat these files as a source-of-record snapshot; do not edit after import.
EOF

( cd "$STAGE" && tar -cjf /tmp/import001.tar.bz2 . )
sudo mv /tmp/import001.tar.bz2 /imports/import001.tar.bz2
sudo chown root:root /imports/import001.tar.bz2

rm -rf "$STAGE"

# Record a content baseline for the original archive so validation can
# prove it was never modified, independent of mtime/size which a naive
# "touch" or metadata-only change wouldn't necessarily disturb reliably.
sudo mkdir -p /var/lib/astrona-lab
sha256sum /imports/import001.tar.bz2 | sudo tee /var/lib/astrona-lab/import001.tar.bz2.sha256 > /dev/null
