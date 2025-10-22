#!/bin/bash
set -e

echo "=== Starting submodule setup ==="

if [ -z "$ADMIN_GIT_PAT_TOKEN" ]; then
  echo "Error: ADMIN_GIT_PAT_TOKEN not set"
  exit 1
fi

# Clone public core submodule normally
echo "Cloning public core submodule..."
git submodule sync
git submodule init core
git submodule update --init --depth=1 core

# Clone private admin submodule directly (bypasses submodule auth issues)
echo "Cloning private admin submodule..."
if [ -d "admin" ]; then
  rm -rf admin
fi
git clone --depth=1 --branch=main "https://${ADMIN_GIT_PAT_TOKEN}@github.com/nandhinidevie/bin-it-right.git" admin

# Update core to latest
cd core
git fetch --depth=1 origin main
git checkout -B main origin/main
cd ..

# Admin is already on latest from clone
cd admin
echo "Admin already at latest: $(git rev-parse --short HEAD)"
cd ..

echo "=== Submodules ready ==="
echo "  core/main @ $(cd core && git rev-parse --short HEAD)"
echo "  admin/main @ $(cd admin && git rev-parse --short HEAD)"
