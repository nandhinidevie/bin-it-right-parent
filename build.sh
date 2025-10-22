#!/bin/bash
set -e

echo "=== Building Fastn core ==="
cd core
fastn build --base=/
cd ..

rm -rf public
mkdir -p public
cp -R core/.build/* public/

# Promote HDI
if [ -f core/.build/hdi/index.html ]; then
  cp -f core/.build/hdi/index.html public/index.html
fi

if [ -f core/.build/hdi/bin-finder/index.html ]; then
  mkdir -p public/bin-finder
  cp -f core/.build/hdi/bin-finder/index.html public/bin-finder/index.html
fi

# Build Next.js admin (static export)
if [ -d "admin" ]; then
  echo "=== Building Next.js admin ==="
  cd admin

  # Use npm install instead of ci (more forgiving)
  npm install --legacy-peer-deps
  npm run build

  cd ..

  # Copy static export
  if [ -d "admin/out" ]; then
    mkdir -p public/admin
    cp -R admin/out/* public/admin/
    echo "✓ Admin built and copied to public/admin"
  fi
fi

echo "=== Build complete ==="
ls -la public
