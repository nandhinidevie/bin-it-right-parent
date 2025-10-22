#!/bin/bash
set -e

echo "=== Cloning ADMIN submodule only (Next.js) ==="

# Check for required token
if [ -z "$ADMIN_GIT_PAT_TOKEN" ]; then
  echo "ERROR: ADMIN_GIT_PAT_TOKEN environment variable is not set"
  echo "Add it in Vercel Project → Settings → Environment Variables"
  exit 1
fi

echo "✓ ADMIN_GIT_PAT_TOKEN is set (${#ADMIN_GIT_PAT_TOKEN} chars)"

# Sync and init admin submodule
echo "Initializing admin submodule..."
git submodule sync
git submodule init admin

# Configure authentication for private repo
git config submodule.admin.url "https://nandhinidevie:${ADMIN_GIT_PAT_TOKEN}@github.com/nandhinidevie/bin-it-right.git"

echo "Configured admin URL (token hidden)"

# Clone admin submodule
echo "Cloning admin submodule..."
git submodule update --init --depth=1 admin 2>&1 | sed "s/${ADMIN_GIT_PAT_TOKEN}/***TOKEN***/g" || {
  echo "Submodule update failed, trying direct clone..."
  rm -rf admin
  git clone --depth=1 --branch=main \
    "https://nandhinidevie:${ADMIN_GIT_PAT_TOKEN}@github.com/nandhinidevie/bin-it-right.git" \
    admin 2>&1 | sed "s/${ADMIN_GIT_PAT_TOKEN}/***TOKEN***/g"
}

# Verify admin has files
if [ ! -f "admin/package.json" ]; then
  echo "FATAL: admin/package.json not found after clone"
  echo "Contents of admin:"
  ls -la admin 2>/dev/null || echo "admin directory doesn't exist"
  echo ""
  echo "Troubleshooting:"
  echo "  1. Check PAT has 'Contents: Read' permission for bin-it-right repo"
  echo "  2. Verify PAT hasn't expired"
  echo "  3. Confirm 'nandhinidevie' account has access to bin-it-right"
  exit 1
fi

# Update to latest
cd admin
git fetch --depth=1 origin main 2>/dev/null || echo "Already at latest"
git checkout -B main origin/main 2>/dev/null || echo "Already on main"
cd ..

echo ""
echo "=== Admin submodule ready ==="
echo "  admin @ $(cd admin && git rev-parse --short HEAD)"
echo "  Found: $(ls -1 admin | head -5 | tr '\n' ' ')"
