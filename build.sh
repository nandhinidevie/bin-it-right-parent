#!/bin/bash
set -e

# Build the fastn site from core, promote HDI to root
cd core
fastn build --base=/
cd ..

# Ensure output directory
mkdir -p public

# Copy entire compiled site (hashed CSS/JS at root)
cp -R core/.build/* public/

# Replace root index with HDI homepage if it exists
if [ -f core/.build/hdi/index.html ]; then
  cp -f core/.build/hdi/index.html public/index.html
fi

# Optional: list what we publish for debugging
echo "Public dir:"
ls -la public
