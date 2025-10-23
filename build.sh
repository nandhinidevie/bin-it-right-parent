#!/bin/bash
set -e

echo "=== Building Fastn (HDI/Amazon) ==="

cd core
fastn build --base=/
cd ..

rm -rf public
mkdir -p public
cp -R core/.build/* public/

# DO NOT promote any specific index.html to root
# Let each domain serve from its own folder via rewrites

# Optional: If you want bin-finder at root for ALL domains
# if [ -f core/.build/hdi/bin-finder/index.html ]; then
#   mkdir -p public/bin-finder
#   cp -f core/.build/hdi/bin-finder/index.html public/bin-finder/index.html
# fi

echo "=== Build complete ==="
ls -la public | head -20
