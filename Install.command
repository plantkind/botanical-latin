#!/bin/bash
cd "$(dirname "$0")"
clear
echo "botanical-latin installer"
echo "======================="
echo ""
./scripts/install.sh
status=$?
echo ""
if [[ $status -eq 0 ]]; then
  ./scripts/verify.sh 2>/dev/null || true
fi
echo ""
read -r -p "Press Return to close."
