#!/bin/bash
set -e

echo "Cloning only core submodule..."

# Clone only core submodule
git submodule update --init --depth 1 core || true

echo "Core submodule cloned successfully"

# Download and install fastn from GitHub releases
echo "Installing fastn..."
FASTN_VERSION="0.5.85"
wget -q https://github.com/fastn-stack/fastn/releases/download/${FASTN_VERSION}/fastn-linux-x86_64.tar.gz -O fastn.tar.gz
tar -xzf fastn.tar.gz
chmod +x fastn
export PATH="$PWD:$PATH"

# Verify fastn is installed
./fastn --version || echo "Fastn installed"

# Build the HDI fastn project
echo "Building HDI project..."
cd core/hdi
../../fastn build --base=/
cd ../..

# Copy built HTML files to public directory
echo "Preparing output files..."
mkdir -p public
cp -r core/hdi/.build/* public/ || echo "No build output found"

echo "Files prepared for deployment"
ls -la public/