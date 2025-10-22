#!/bin/bash
set -e

# Check for required token for private admin submodule
if [ -z "$ADMIN_GIT_PAT_TOKEN" ]; then
  echo "Error: ADMIN_GIT_PAT_TOKEN environment variable is not set."
  echo "Please add it to Vercel Environment Variables."
  exit 1
fi

# First, sync all submodule configurations from .gitmodules
git submodule sync

# Initialize and register submodules (this reads .gitmodules and registers them in git config)
git submodule init

# Update the private admin submodule URL with PAT authentication
# This must happen AFTER init so git knows about the submodule
git config submodule.admin.url "https://${ADMIN_GIT_PAT_TOKEN}@github.com/nandhinidevie/bin-it-right.git"

# Now update/clone all submodules
git submodule update --init --recursive --depth=1

# Update public core to latest main
cd core
git fetch --depth=1 origin main
git checkout -B main origin/main
cd ..

# Update private admin to latest main
cd admin
git fetch --depth=1 origin main
git checkout -B main origin/main
cd ..

# Log commits for verification
echo "Submodules cloned successfully:"
echo "  core/main @ $(cd core && git rev-parse --short HEAD)"
echo "  admin/main @ $(cd admin && git rev-parse --short HEAD)"
