#!/bin/bash
set -e

# Build fastn with base=/hdi so all runtime and asset URLs resolve under /hdi
cd core
fastn build --base=/hdi
cd ..

# Publish the entire compiled site as-is
mkdir -p public
cp -R core/.build/* public/

# Log what will be served for quick verification
echo "Public at deploy time:"
find public -maxdepth 2 -type d -print | sort
ls -la public | sed -n '1,200p'
