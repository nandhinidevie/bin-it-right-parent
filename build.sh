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

# Promote HDI homepage to the root
if [ -f core/.build/hdi/index.html ]; then
  cp -f core/.build/hdi/index.html public/index.html
fi

if [ -f core/.build/hdi/bin-finder/index.html ]; then
  mkdir -p public/bin-finder
  cp -f core/.build/hdi/bin-finder/index.html public/bin-finder/index.html
fi

# Note: If you want Amazon at root instead of HDI, uncomment below and comment out HDI copy above
# if [ -f core/.build/amazon/index.html ]; then
#   cp -f core/.build/amazon/index.html public/index.html
# fi

# Build Next.js admin app from private submodule
if [ -d "admin" ]; then
  echo "Building Next.js admin app..."
  cd admin

  # Install dependencies and build
  npm ci --production=false
  npm run build

  cd ..

  # Copy Next.js build output to public/admin for subdomain routing
  # Adjust based on your Next.js configuration:
  # - If using static export (output: 'export'), copy from 'out' folder
  # - If using server/SSR, copy '.next' folder

  mkdir -p public/admin

  # For static export (if admin/next.config.js has output: 'export'):
  if [ -d "admin/out" ]; then
    cp -R admin/out/* public/admin/
    echo "Admin static build copied to public/admin/"
  # For server-side/hybrid build:
  elif [ -d "admin/.next" ]; then
    cp -R admin/.next/* public/admin/
    cp admin/package.json public/admin/
    echo "Admin SSR build copied to public/admin/"
  else
    echo "Warning: No admin build output found (expected 'out' or '.next' folder)"
  fi
else
  echo "Warning: admin submodule not found; skipping Next.js build."
fi

# Optional: List outputs for verification in Vercel logs
echo "Build complete. Public directory contents:"
ls -la public
if [ -d "public/admin" ]; then
  echo "Admin directory contents:"
  ls -la public/admin | head -n 20
fi
