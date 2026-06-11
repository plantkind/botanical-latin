#!/bin/bash
cd "$(dirname "$0")"
clear
echo "botanical-latin"
echo "==============="
echo ""
echo "Adding California native plant names to your Mac spell-check."
echo ""

WORDS="$(pwd)/dist/words.txt"

if [[ ! -f "$WORDS" ]]; then
  echo "ERROR: dist/words.txt not found."
  echo "Download the full repo from GitHub, not just this file."
  read -r -p "Press Return to close."
  exit 1
fi

echo "Teaching plant names (~10 seconds)..."
echo ""
osascript -l JavaScript scripts/learn.jxa "$WORDS"
echo ""
read -r -p "Press Return to close."
