#!/bin/bash
cd "$(dirname "$0")"
clear
echo "botanical-latin"
echo "==============="
echo ""
echo "California native plant names for macOS spell-check."
echo ""

if [[ ! -f "dist/words.txt" ]]; then
  echo "ERROR: dist/words.txt not found."
  echo "Download the full repo from GitHub, not just this file."
  read -r -p "Press Return to close."
  exit 1
fi

swift scripts/learn.swift "dist/words.txt"
echo ""
read -r -p "Press Return to close."
