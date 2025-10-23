#!/bin/bash
set -e

echo "=== Building Fastn (HDI/Amazon) ==="

cd core
fastn build --base=/
cd ..

rm -rf public
mkdir -p public

# Copy entire build structure (hdi/, amazon/, etc.) without root promotion
cp -R core/.build/* public/

# CRITICAL: Remove any root index.html to force domain-specific serving
rm -f public/index.html

# Optional: Copy shared assets like bin-finder to root (if needed for both domains)
if [ -f "public/hdi/bin-finder/index.html" ]; then
  mkdir -p public/bin-finder
  cp -f core/.build/hdi/bin-finder/index.html public/bin-finder/index.html
fi

echo "=== Build complete ==="
echo "Root public contents:"
ls -la public/
echo "HDI contents:"
ls -la public/hdi/ 2>/dev/null || echo "No hdi folder found"
echo "Amazon contents:"
ls -la public/amazon/ 2>/dev/null || echo "No amazon folder found"
