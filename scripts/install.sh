#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORDS="$ROOT/dist/words.txt"
STATE_DIR="$HOME/Library/Application Support/botanical-latin"
INSTALLED_LIST="$STATE_DIR/installed-words.txt"
LOCAL_DICT="$HOME/Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling/LocalDictionary"
LEGACY_DICT="$HOME/Library/Spelling/LocalDictionary"

if [[ ! -f "$WORDS" ]]; then
  echo "ERROR: Missing dist/words.txt"
  exit 1
fi

mkdir -p "$STATE_DIR"

verify_install() {
  local target="$1"
  grep -qx "Arctostaphylos" "$target" 2>/dev/null && grep -qx "agrifolia" "$target" 2>/dev/null
}

try_install() {
  local target="$1"
  local added_file
  added_file="$(mktemp)"
  trap 'rm -f "$added_file"' RETURN

  if [[ ! -w "$target" ]] 2>/dev/null; then
    return 1
  fi

  if [[ -f "$target" ]] && [[ -s "$target" ]]; then
    cp "$target" "${target}.backup-botanical-latin" 2>/dev/null || return 1
    comm -23 \
      <(LC_ALL=C sort -u "$WORDS") \
      <(LC_ALL=C sort -u "$target") \
      > "$added_file" 2>/dev/null || return 1
  else
    cp "$WORDS" "$added_file"
  fi

  if [[ ! -s "$added_file" ]]; then
    echo "Already installed."
    return 0
  fi

  cat "$added_file" >> "$target" 2>/dev/null || return 1

  if ! verify_install "$target"; then
    return 1
  fi

  cat "$added_file" > "$INSTALLED_LIST"
  local count
  count="$(wc -l < "$added_file" | tr -d ' ')"
  echo "SUCCESS: Added $count plant names."
  echo "File: $target"
  return 0
}

manual_install() {
  echo ""
  echo "Automatic install was blocked by macOS (Operation not permitted)."
  echo "This is common. Manual install takes about 30 seconds:"
  echo ""
  echo "  1. TextEdit opens words.txt — press Cmd+A, Cmd+C"
  echo "  2. Finder opens the Spelling folder — double-click LocalDictionary"
  echo "  3. In LocalDictionary: click at the end, Cmd+V, Cmd+S to save"
  echo "  4. Quit and reopen iA Writer or Notion"
  echo ""
  open -a TextEdit "$WORDS"
  open "$(dirname "$LOCAL_DICT")" 2>/dev/null || open "$HOME/Library/Spelling" 2>/dev/null || true
  return 1
}

rm -f "$INSTALLED_LIST"

for target in "$LOCAL_DICT" "$LEGACY_DICT"; do
  mkdir -p "$(dirname "$target")"
  touch "$target" 2>/dev/null || true
  if try_install "$target"; then
    echo ""
    echo "Quit and reopen your writing apps."
    exit 0
  fi
done

manual_install
exit 1
