#!/bin/bash
set -e

echo "=== Starting submodule setup ==="

# Check for required token
if [ -z "$ADMIN_GIT_PAT_TOKEN" ]; then
  echo "Error: ADMIN_GIT_PAT_TOKEN environment variable is not set."
  echo "Please add it to Vercel Environment Variables."
  exit 1
fi

# Sync submodule URLs from .gitmodules
echo "Syncing submodule URLs..."
git submodule sync

# Initialize submodules (registers them in git config)
echo "Initializing submodules..."
git submodule init

# Update the private admin submodule URL with PAT BEFORE attempting to clone
echo "Configuring authentication for private admin submodule..."
git config submodule.admin.url "https://nandhinidevie:${ADMIN_GIT_PAT_TOKEN}@github.com/nandhinidevie/bin-it-right.git"

# Now update/clone all submodules
echo "Cloning submodules..."
git submodule update --init --recursive --depth=1

# Verify both submodules exist before proceeding
if [ ! -d "core" ]; then
  echo "Error: core submodule directory not found after clone"
  exit 1
fi

if [ ! -d "admin" ]; then
  echo "Error: admin submodule directory not found after clone"
  echo "This usually means authentication failed. Check your ADMIN_GIT_PAT_TOKEN."
  exit 1
fi

# Update public core to latest main
echo "Updating core submodule to latest main..."
cd core
git fetch --depth=1 origin main
git checkout -B main origin/main
cd ..

# Update private admin to latest main
echo "Updating admin submodule to latest main..."
cd admin
git fetch --depth=1 origin main
git checkout -B main origin/main
cd ..

# Log success with commit SHAs
echo "=== Submodules cloned successfully ==="
echo "  core/main @ $(cd core && git rev-parse --short HEAD)"
echo "  admin/main @ $(cd admin && git rev-parse --short HEAD)"
