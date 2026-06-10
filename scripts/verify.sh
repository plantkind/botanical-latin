#!/bin/bash
set -euo pipefail

WORDS="$(cd "$(dirname "$0")/.." && pwd)/dist/words.txt"
LOCAL_DICT="$HOME/Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling/LocalDictionary"

if [[ ! -f "$LOCAL_DICT" ]]; then
  echo "LocalDictionary not found."
  exit 1
fi

total=$(wc -l < "$LOCAL_DICT" | tr -d ' ')
echo "LocalDictionary: $total lines"

for w in Arctostaphylos agrifolia fasciculatum Eriogonum; do
  if grep -qx "$w" "$LOCAL_DICT"; then
    echo "  $w: installed"
  else
    echo "  $w: MISSING"
  fi
done

if [[ -f "$WORDS" ]]; then
  missing=$(comm -23 <(LC_ALL=C sort -u "$WORDS") <(LC_ALL=C sort -u "$LOCAL_DICT") | wc -l | tr -d ' ')
  echo "Plant names still missing: $missing"
fi
