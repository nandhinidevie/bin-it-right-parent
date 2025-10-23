#!/bin/bash
set -e

echo "=== Cloning CORE submodule only (HDI/Amazon) ==="

# Sync and init only core
git submodule sync
git submodule init core

# Clone core (public repo, no auth needed)
echo "Cloning core submodule..."
git submodule update --init --depth=1 core

# Verify
if [ ! -f "core/FASTN.ftd" ]; then
  echo "ERROR: core/FASTN.ftd not found"
  exit 1
fi

# Update to latest
cd core
git fetch --depth=1 origin main
git checkout -B main origin/main
cd ..

echo "✓ Core ready @ $(cd core && git rev-parse --short HEAD)"
