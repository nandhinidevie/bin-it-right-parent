#!/bin/bash
set -e

echo "Cloning only core submodule..."

# Clone only core submodule
git submodule update --init --depth 1 core || true

echo "Core submodule cloned successfully"

# Copy HDI files to public directory for Vercel to serve
echo "Preparing output files..."
mkdir -p public
cp -r core/hdi/* public/ || echo "HDI files not found"

echo "Files prepared for deployment"
ls -la public/
