#!/bin/bash
set -e

echo "=== Cloning admin submodule into binitright-admin/ ==="

if [ -z "$ADMIN_GIT_PAT_TOKEN" ]; then
  echo "ERROR: ADMIN_GIT_PAT_TOKEN not set"
  exit 1
fi

echo "✓ ADMIN_GIT_PAT_TOKEN present (${#ADMIN_GIT_PAT_TOKEN} chars)"

# Navigate to repo root to access .gitmodules
cd ..

# Initialize admin submodule
git submodule sync
git submodule init admin

# Configure with PAT
git config submodule.admin.url "https://nandhinidevie:${ADMIN_GIT_PAT_TOKEN}@github.com/nandhinidevie/bin-it-right.git"

# Clone into temporary location
echo "Cloning admin submodule..."
git submodule update --init --depth=1 admin 2>&1 | sed "s/${ADMIN_GIT_PAT_TOKEN}/***TOKEN***/g" || {
  echo "Fallback: direct clone..."
  rm -rf admin
  git clone --depth=1 --branch=main \
    "https://nandhinidevie:${ADMIN_GIT_PAT_TOKEN}@github.com/nandhinidevie/bin-it-right.git" \
    admin
}

# Move to binitright-admin folder
if [ -d "admin" ]; then
  echo "Moving admin to binitright-admin/admin..."
  rm -rf binitright-admin/admin
  mv admin binitright-admin/admin
else
  echo "FATAL: admin not cloned"
  exit 1
fi

if [ ! -f "binitright-admin/admin/package.json" ]; then
  echo "FATAL: admin/package.json not found"
  exit 1
fi

echo "✓ Admin ready @ $(cd binitright-admin/admin && git rev-parse --short HEAD)"
