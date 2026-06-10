#!/bin/bash
cd "$(dirname "$0")"
clear
echo "botanical-latin — manual install"
echo "================================"
echo ""
./scripts/install.sh || true
echo ""
read -r -p "Press Return to close."
