#!/usr/bin/env bash
set -euo pipefail
cat >/home/candidate/scripts/count-lines.sh <<'REFERENCE_FILE'
#!/usr/bin/env bash
if [ "$#" -eq 0 ]; then
    echo "usage: count-lines.sh <directory>" >&2
    exit 2
fi

target_dir=$1
if [ ! -d "$target_dir" ]; then
    echo "not a directory: $target_dir" >&2
    exit 1
fi


total=0
for file in "$target_dir"/*.txt; do
    [ -e "$file" ] || continue
    count=$(wc -l < "$file")
    echo "$(basename "$file"): $count lines"
    total=$((total + count))
done
echo "total: $total lines"
REFERENCE_FILE
chmod +x /home/candidate/scripts/count-lines.sh

