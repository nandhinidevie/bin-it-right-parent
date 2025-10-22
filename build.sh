#!/bin/bash

set -e

# Build the Fastn site from 'core' submodule
cd core
fastn build --base=/
cd ..

# Prepare public directory for Fastn output
rm -rf public
mkdir -p public
cp -R core/.build/* public/

# --- REMOVED PROMOTION LOGIC ---
# DO NOT copy any index.html to the root of public/
# This was the cause of the issue

# Build Next.js admin app from private submodule
if [ -d "admin" ]; then
  echo "Building Next.js admin app..."
  cd admin

  if [ -f "package-lock.json" ]; then
    npm ci
  else
    npm install
  fi

  npm run build

  cd ..

  # Copy Next.js build output to public/admin
  mkdir -p public/admin

  if [ -d "admin/out" ]; then
    cp -R admin/out/* public/admin/
    echo "Admin static build copied to public/admin/"
  elif [ -d "admin/.next" ]; then
    cp -R admin/.next/* public/admin/
    cp admin/package.json public/admin/
    echo "Admin SSR build copied to public/admin/"
  fi
else
  echo "Warning: admin submodule not found; skipping Next.js build."
fi

echo "Build complete. Public directory contents:"
ls -la public
