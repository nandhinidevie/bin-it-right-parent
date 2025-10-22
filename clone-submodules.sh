#!/bin/bash
set -e

# Initialize submodule if needed
git submodule update --init core

# Move submodule to the latest commit on main
cd core
git fetch --depth=1 origin main
git checkout -B main origin/main
cd ..

# (Optional) Show the commit used for the build
echo "core/main @ $(cd core && git rev-parse --short HEAD)"