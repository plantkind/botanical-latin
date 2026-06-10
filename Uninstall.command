#!/bin/bash
cd "$(dirname "$0")"
clear
echo "botanical-latin — uninstall"
echo "==========================="
echo ""

if [[ ! -f "dist/words.txt" ]]; then
  echo "ERROR: dist/words.txt not found."
  read -r -p "Press Return to close."
  exit 1
fi

swift scripts/unlearn.swift "dist/words.txt"
echo ""
read -r -p "Press Return to close."
