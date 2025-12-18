#!/data/data/com.termux/files/usr/bin/bash

set -e

TYPE="hydrogen_lattice"
INTERVAL=120
LEDGER="RESEARCH.md"
STATE=".state_hash"

echo "[∞] Miner online for $TYPE"

while true; do
  TS=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
  TMP=$(mktemp)

  {
    echo
    echo "## Block $TS"
    echo
    echo "- Topic: $TYPE"
    echo "- Files in repo: $(find . -type f | wc -l)"
    echo "- Code lines: $(find . -name '*.py' -o -name '*.md' -o -name '*.sh' | xargs wc -l 2>/dev/null | awk '{s+=$1} END {print s}')"
  } > "$TMP"

  NEW=$(sha256sum "$TMP" | awk '{print $1}')
  OLD=""
  [ -f "$STATE" ] && OLD=$(cat "$STATE")

  if [ "$NEW" != "$OLD" ]; then
    cat "$TMP" >> "$LEDGER"
    echo "$NEW" > "$STATE"
    git add "$LEDGER" "$STATE"
    git commit -m "∞ $TYPE research block"
    git push origin main
    echo "[∞] New research committed"
  else
    echo "[∞] No change"
  fi

  rm "$TMP"
  sleep "$INTERVAL"
done
