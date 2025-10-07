#!/bin/bash
set -e

# Build the fastn site from 'core' at base=/ to keep original, absolute URLs
cd core
fastn build --base=/
cd ..

# Publish the entire compiled site as-is (keeps /prism-*.css and /-/bin-it-right.fifthtry.site/*)
mkdir -p public
cp -R core/.build/* public/

# Optional: list what will be served for verification
echo "Public dir (top-level):"
ls -la public
