#!/bin/bash
set -euo pipefail

STATE_DIR="$HOME/Library/Application Support/botanical-latin"
INSTALLED_LIST="$STATE_DIR/installed-words.txt"

if [[ ! -f "$INSTALLED_LIST" ]]; then
  echo "Nothing to remove — botanical-latin was not installed via install.sh"
  exit 0
fi

LOCAL_PATHS=(
  "$HOME/Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling/LocalDictionary"
  "$HOME/Library/Spelling/LocalDictionary"
)

for LOCAL_DICT in "${LOCAL_PATHS[@]}"; do
  if [[ -f "$LOCAL_DICT" ]]; then
    comm -23 \
      <(LC_ALL=C sort -u "$LOCAL_DICT") \
      <(LC_ALL=C sort -u "$INSTALLED_LIST") \
      > "${LOCAL_DICT}.tmp"
    mv "${LOCAL_DICT}.tmp" "$LOCAL_DICT"
    echo "Removed botanical-latin words from LocalDictionary."
    rm -f "$INSTALLED_LIST"
    echo "Uninstall complete. Quit and reopen your writing apps."
    exit 0
  fi
done

echo "LocalDictionary not found."
