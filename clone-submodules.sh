#!/bin/bash
set -e

echo "=== Starting submodule setup with detailed debugging ==="

# Check for required token
if [ -z "$ADMIN_GIT_PAT_TOKEN" ]; then
  echo "ERROR: ADMIN_GIT_PAT_TOKEN environment variable is not set."
  echo "Please add it in Vercel → Project Settings → Environment Variables"
  exit 1
else
  echo "✓ ADMIN_GIT_PAT_TOKEN is set (length: ${#ADMIN_GIT_PAT_TOKEN} characters)"
  # Show first 4 chars for verification (not the full token)
  echo "  Token starts with: ${ADMIN_GIT_PAT_TOKEN:0:4}..."
fi

# Show current directory and .gitmodules content
echo ""
echo "Current directory: $(pwd)"
echo "Contents of .gitmodules:"
cat .gitmodules

# Sync and init
echo ""
echo "Step 1: Syncing submodule URLs..."
git submodule sync

echo ""
echo "Step 2: Initializing submodules..."
git submodule init

# Show what git knows about submodules
echo ""
echo "Git submodule status before update:"
git submodule status || echo "  (no submodules initialized yet)"

# Configure admin URL with token
echo ""
echo "Step 3: Configuring admin submodule with authentication..."
git config submodule.admin.url "https://nandhinidevie:${ADMIN_GIT_PAT_TOKEN}@github.com/nandhinidevie/bin-it-right.git"

# Verify the URL was set
echo "Configured admin URL (with token hidden):"
git config submodule.admin.url | sed "s/${ADMIN_GIT_PAT_TOKEN}/***TOKEN***/g"

# Try updating with verbose output
echo ""
echo "Step 4: Updating submodules (this will show git errors if any)..."
set +e  # Don't exit immediately on error, we want to see the output
git submodule update --init --recursive --depth=1 2>&1
UPDATE_EXIT_CODE=$?
set -e

echo ""
echo "Submodule update exit code: $UPDATE_EXIT_CODE"

# List what directories were created
echo ""
echo "Directories created:"
ls -la | grep "^d"

# Check if directories exist
echo ""
echo "Checking submodule directories..."
if [ -d "core" ]; then
  echo "✓ core directory exists"
  ls -la core | head -5
else
  echo "✗ core directory NOT found"
fi

if [ -d "admin" ]; then
  echo "✓ admin directory exists"
  ls -la admin | head -5
else
  echo "✗ admin directory NOT found"
  echo ""
  echo "=== DEBUGGING: Trying direct clone of admin ==="
  echo "Attempting: git clone with PAT..."

  # Try direct clone as fallback
  git clone --depth=1 --branch=main \
    "https://nandhinidevie:${ADMIN_GIT_PAT_TOKEN}@github.com/nandhinidevie/bin-it-right.git" \
    admin 2>&1 || {
      echo "DIRECT CLONE ALSO FAILED"
      echo "Possible issues:"
      echo "  1. PAT doesn't have 'Contents: Read' permission for bin-it-right repo"
      echo "  2. PAT has expired"
      echo "  3. GitHub username 'nandhinidevie' doesn't have access to bin-it-right"
      echo "  4. Repository 'nandhinidevie/bin-it-right' doesn't exist or is misspelled"
      exit 1
    }

  if [ -d "admin" ]; then
    echo "✓ Direct clone succeeded!"
  fi
fi

# Final verification
if [ ! -d "core" ]; then
  echo "FATAL: core submodule failed to clone"
  exit 1
fi

if [ ! -d "admin" ]; then
  echo "FATAL: admin submodule failed to clone even with direct method"
  exit 1
fi

# Update to latest commits
echo ""
echo "Step 5: Updating to latest commits..."
cd core
git fetch --depth=1 origin main
git checkout -B main origin/main
cd ..

cd admin
git fetch --depth=1 origin main 2>/dev/null || echo "Admin already at latest from clone"
git checkout -B main origin/main 2>/dev/null || echo "Admin already on main"
cd ..

# Success!
echo ""
echo "=== Submodules ready ==="
echo "  core/main @ $(cd core && git rev-parse --short HEAD)"
echo "  admin/main @ $(cd admin && git rev-parse --short HEAD)"
