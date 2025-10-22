#!/bin/bash
set -e

# Check for required token for private admin submodule
if [ -z "$ADMIN_GIT_PAT_TOKEN" ]; then
  echo "Error: ADMIN_GIT_PAT_TOKEN not set; cannot access private admin repo."
  exit 1
fi

# Deinitialize submodules if partially initialized (cleans failed states)
git submodule deinit -f core admin || true
git submodule sync

# Set URL for private admin with token (use your GitHub username if required, e.g., nandhinidevie:${ADMIN_GIT_PAT_TOKEN})
git submodule set-url admin "https://${ADMIN_GIT_PAT_TOKEN}@github.com/nandhinidevie/bin-it-right.git"

# Initialize and update all submodules
git submodule update --init --recursive core admin

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
echo "core/main @ $(cd core && git rev-parse --short HEAD)"
echo "admin/main @ $(cd admin && git rev-parse --short HEAD)"
