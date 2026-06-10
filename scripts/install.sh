#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORDS="$ROOT/dist/words.txt"
STATE_DIR="$HOME/Library/Application Support/botanical-latin"
INSTALLED_LIST="$STATE_DIR/installed-words.txt"

if [[ ! -f "$WORDS" ]]; then
  echo "Missing dist/words.txt"
  exit 1
fi

LOCAL_PATHS=(
  "$HOME/Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling/LocalDictionary"
  "$HOME/Library/Spelling/LocalDictionary"
)

mkdir -p "$STATE_DIR"
ADDED_LIST="$(mktemp)"
trap 'rm -f "$ADDED_LIST"' EXIT

for LOCAL_DICT in "${LOCAL_PATHS[@]}"; do
  if [[ -f "$LOCAL_DICT" ]]; then
    cp "$LOCAL_DICT" "${LOCAL_DICT}.backup-botanical-latin"
    comm -23 \
      <(LC_ALL=C sort -u "$WORDS") \
      <(LC_ALL=C sort -u "$LOCAL_DICT") \
      > "$ADDED_LIST"
    if [[ -s "$ADDED_LIST" ]]; then
      cat "$ADDED_LIST" >> "$LOCAL_DICT"
      cat "$ADDED_LIST" >> "$INSTALLED_LIST"
      echo "Added $(wc -l < "$ADDED_LIST" | tr -d ' ') plant names to LocalDictionary."
      echo "Backup saved: ${LOCAL_DICT}.backup-botanical-latin"
    else
      echo "LocalDictionary already contains these plant names."
    fi
    sort -u "$INSTALLED_LIST" -o "$INSTALLED_LIST"
    echo ""
    echo "Done. Keep Spelling on U.S. or Automatic by Language."
    echo "Quit and reopen your writing apps."
    exit 0
  fi
done

mkdir -p "$(dirname "${LOCAL_PATHS[0]}")"
cp "$WORDS" "${LOCAL_PATHS[0]}"
cp "$WORDS" "$INSTALLED_LIST"
echo "Created LocalDictionary with $(wc -l < "$WORDS" | tr -d ' ') plant names."
