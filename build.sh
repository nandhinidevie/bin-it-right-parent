#!/bin/bash
set -e

echo "=== Building Fastn (HDI/Amazon) ==="

cd core
fastn build --base=/
cd ..

rm -rf public
mkdir -p public
cp -R core/.build/* public/

# Promote HDI to root
if [ -f core/.build/hdi/index.html ]; then
  cp -f core/.build/hdi/index.html public/index.html
fi

if [ -f core/.build/hdi/bin-finder/index.html ]; then
  mkdir -p public/bin-finder
  cp -f core/.build/hdi/bin-finder/index.html public/bin-finder/index.html
fi

#if [ -f core/.build/amazon/index.html ]; then
#  cp -f core/.build/amazon/index.html public/amazon/index.html
#fi

echo "=== Build complete ==="
ls -la public | head -20