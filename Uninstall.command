#!/bin/bash
cd "$(dirname "$0")"
clear
echo "botanical-latin — uninstall"
echo "==========================="
echo ""

WORDS="$(pwd)/dist/words.txt"

if [[ ! -f "$WORDS" ]]; then
  echo "ERROR: dist/words.txt not found."
  read -r -p "Press Return to close."
  exit 1
fi

osascript -l JavaScript scripts/unlearn.jxa "$WORDS"
echo ""
read -r -p "Press Return to close."
