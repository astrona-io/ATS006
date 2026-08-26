#!/usr/bin/env bash
# Bootstrap: installs a fixed-output diagnostic program at /bin/output-generator.
# It always writes one line to stdout, one line to stderr, and exits 7 --
# never 0 -- so the exit-code capture step in the lab is unambiguous and
# can't be confused with a script that "just happened" to succeed.

set -eu

sudo tee /bin/output-generator > /dev/null <<'EOF'
#!/usr/bin/env bash
echo "OUTPUT_OK: primary payload generated"
echo "WARNING_STREAM: secondary diagnostic notice" >&2
exit 7
EOF

sudo chmod +x /bin/output-generator

# The lab's own task is to create /var/output-generator itself as the first
# step, so bootstrap deliberately does NOT create it here.
