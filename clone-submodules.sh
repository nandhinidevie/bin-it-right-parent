#!/bin/bash
set -e

echo "=== Starting submodule setup ==="

# Check for required token
if [ -z "$ADMIN_GIT_PAT_TOKEN" ]; then
  echo "ERROR: ADMIN_GIT_PAT_TOKEN not set"
  exit 1
fi

echo "✓ ADMIN_GIT_PAT_TOKEN is set (${#ADMIN_GIT_PAT_TOKEN} chars)"

# Show .gitmodules
echo ""
echo "Contents of .gitmodules:"
cat .gitmodules

# Method 1: Try standard git submodule approach
echo ""
echo "=== Attempting standard submodule clone ==="
git submodule sync
git submodule init

# Configure admin URL with token (include username for better auth)
git config submodule.admin.url "https://nandhinidevie:${ADMIN_GIT_PAT_TOKEN}@github.com/nandhinidevie/bin-it-right.git"

echo "Configured URLs:"
echo "  core: $(git config submodule.core.url)"
echo "  admin: $(git config submodule.admin.url | sed "s/${ADMIN_GIT_PAT_TOKEN}/***TOKEN***/g")"

# Update submodules
git submodule update --init --recursive --depth=1 2>&1 || echo "Submodule update had issues"

# Verify contents
echo ""
echo "=== Verifying submodule contents ==="

# Check core
if [ -d "core" ] && [ -f "core/FASTN.ftd" ]; then
  echo "✓ core submodule cloned successfully"
else
  echo "✗ core submodule failed"
  exit 1
fi

# Check admin - verify it has actual files, not just empty directory
if [ -d "admin" ] && [ -f "admin/package.json" ]; then
  echo "✓ admin submodule cloned successfully"
  echo "  Found: $(ls -1 admin | head -5 | tr '\n' ' ')"
elif [ -d "admin" ]; then
  echo "✗ admin directory exists but is EMPTY (auth failed)"
  echo "  Contents: $(ls -la admin | wc -l) items"

  # Method 2: Direct clone as fallback
  echo ""
  echo "=== Fallback: Direct clone of admin repo ==="
  rm -rf admin

  git clone --depth=1 --branch=main \
    "https://nandhinidevie:${ADMIN_GIT_PAT_TOKEN}@github.com/nandhinidevie/bin-it-right.git" \
    admin 2>&1 | sed "s/${ADMIN_GIT_PAT_TOKEN}/***TOKEN***/g" || {
      echo "FATAL: Direct clone also failed"
      echo "Possible issues:"
      echo "  1. Check PAT has 'Contents: Read' for bin-it-right repo"
      echo "  2. Verify PAT hasn't expired"
      echo "  3. Confirm account 'nandhinidevie' has access"
      echo "  4. Test locally: git clone https://nandhinidevie:PAT@github.com/nandhinidevie/bin-it-right.git"
      exit 1
    }

  if [ -f "admin/package.json" ]; then
    echo "✓ Direct clone succeeded!"
  else
    echo "FATAL: admin still empty after direct clone"
    exit 1
  fi
else
  echo "✗ admin directory doesn't exist at all"
  exit 1
fi

# Update to latest commits
echo ""
echo "=== Updating to latest commits ==="
cd core
git fetch --depth=1 origin main
git checkout -B main origin/main
cd ..

cd admin
git fetch --depth=1 origin main 2>/dev/null || true
git checkout -B main origin/main 2>/dev/null || true
cd ..

echo ""
echo "=== Submodules ready ==="
echo "  core @ $(cd core && git rev-parse --short HEAD)"
echo "  admin @ $(cd admin && git rev-parse --short HEAD)"
