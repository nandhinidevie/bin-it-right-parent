#!/bin/bash
set -e

# Check for required token for private submodule
if [ -z "$ADMIN_GIT_PAT_TOKEN" ]; then
  echo "Error: ADMIN_GIT_PAT_TOKEN environment variable is not set for private admin submodule."
  exit 1
fi

# Initialize all submodules
git submodule update --init core admin

# Update public core to latest main
cd core
git fetch --depth=1 origin main
git checkout -B main origin/main
cd ..

# Update private admin: Inject token into URL and fetch latest main
git submodule set-url admin "https://${ADMIN_GIT_PAT_TOKEN}@github.com/nandhinidevie/bin-it-right.git"
git submodule sync admin
cd admin
git fetch --depth=1 origin main
git checkout -B main origin/main
cd ..

# Optional: Log commits for verification
echo "core/main @ $(cd core && git rev-parse --short HEAD)"
echo "admin/main @ $(cd admin && git rev-parse --short HEAD)"
