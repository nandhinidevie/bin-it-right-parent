#!/bin/bash
set -e

echo "Cloning only core submodule..."

# Clone only core submodule
git submodule update --init --depth 1 core || true

echo "Core submodule cloned successfully"

# Install fastn
echo "Installing fastn..."
curl -fsSL https://fastn.com/install.sh | sh

# Build the HDI fastn project
echo "Building HDI project..."
cd core/hdi
~/.fastn/bin/fastn build --base=/
cd ../..

# Copy built HTML files to public directory
echo "Preparing output files..."
mkdir -p public
cp -r core/hdi/.build/* public/

echo "Files prepared for deployment"
ls -la public/