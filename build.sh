#!/bin/bash
set -e

# Build the fastn site from 'core' at base=/ to keep absolute URLs working at /
cd core
fastn build --base=/
cd ..

# Publish the entire compiled site as-is (keeps /prism-*.css and /-/bin-it-right.fifthtry.site/*)
rm -rf public
mkdir -p public
cp -R core/.build/* public/

# Promote HDI homepage to the root (so / serves HDI's index)
if [ -f core/.build/hdi/index.html ]; then
  cp -f core/.build/hdi/index.html public/index.html
fi

# Optional: list what will be served for verification
echo "Public dir (top-level):"
ls -la public
