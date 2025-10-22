#!/bin/bash

set -e

# Build the Fastn site from 'core' (existing logic unchanged)
cd core
fastn build --base=/
cd ..

rm -rf public
mkdir -p public
cp -R core/.build/* public/

# Promote HDI/Amazon (existing logic unchanged)
if [ -f core/.build/hdi/index.html ]; then
  cp -f core/.build/hdi/index.html public/index.html
fi
if [ -f core/.build/hdi/bin-finder/index.html ]; then
  mkdir -p public/bin-finder
  cp -f core/.build/hdi/bin-finder/index.html public/bin-finder/index.html
fi
if [ -f core/.build/amazon/index.html ]; then
  cp -f core/.build/amazon/index.html public/index.html  # Note: This overwrites HDI; adjust if needed
fi

# Build Next.js admin app
if [ -d "admin" ]; then
  cd admin
  npm ci  # Or yarn install if using Yarn
  npm run build
  cd ..

  # Copy Next.js output to a dedicated dist folder (for subdomain routing)
  rm -rf admin-dist
  mkdir -p admin-dist
  cp -R .next/* admin-dist/  # Assumes standard Next.js output; adjust if using custom outDir
  cp package.json admin-dist/  # For Vercel serverless if needed
else
  echo "Warning: admin submodule not found; skipping Next.js build."
fi

# Optional: List outputs for verification
echo "Public dir (top-level):"
ls -la public
echo "Admin dist dir:"
ls -la admin-dist
