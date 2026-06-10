#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SPELLING="$HOME/Library/Spelling"
LOCAL_DICT="$HOME/Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling/LocalDictionary"

mkdir -p "$SPELLING"
cp "$ROOT/dist/botanical-latin.dic" "$ROOT/dist/botanical-latin.aff" "$SPELLING/"

# Obsidian and some Electron apps read LocalDictionary, not custom Hunspell files.
if [[ -f "$LOCAL_DICT" ]]; then
  comm -23 \
    <(tail -n +2 "$ROOT/dist/botanical-latin.dic" | LC_ALL=C sort -u) \
    <(LC_ALL=C sort -u "$LOCAL_DICT") \
    >> "$LOCAL_DICT"
  echo "Merged new plant names into LocalDictionary (used by Obsidian)."
else
  echo "LocalDictionary not found — skipped merge. Hunspell files copied to ~/Library/Spelling/."
fi

echo "Installed. Restart your Mac, then enable botanical-latin in Keyboard → Text Input → Edit → Spelling → Set Up."
