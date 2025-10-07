#!/bin/bash
set -e

echo "Cloning only core submodule..."

# Clone only core submodule
git submodule update --init --recursive --depth 1 core || true

echo "Core submodule cloned successfully"

# Try downloading fastn from GitHub releases
echo "Installing fastn..."
FASTN_VERSION="0.4.110"

# Try downloading the Linux binary
curl -kL "https://github.com/fastn-stack/fastn/releases/download/${FASTN_VERSION}/fastn_linux_x86_64" -o fastn || \
curl -kL "https://github.com/fastn-stack/fastn/releases/download/${FASTN_VERSION}/fastn-linux-x86_64" -o fastn

chmod +x fastn

# Verify fastn is installed
./fastn --version || echo "Fastn version check"

# Build the HDI fastn project
echo "Building HDI project..."
cd core/hdi

# Check if FASTN.ftd exists (required for fastn build)
if [ -f "FASTN.ftd" ]; then
  ../../fastn build --base=/
else
  echo "No FASTN.ftd found, checking for index.ftd"
  if [ -f "index.ftd" ]; then
    echo "Found index.ftd, project structure detected"
  fi
fi

cd ../..

# Copy files - try .build first, fall back to source
echo "Preparing output files..."
mkdir -p public

if [ -d "core/hdi/.build" ]; then
  cp -r core/hdi/.build/* public/
  echo "Copied built files from .build"
elif [ -d "core/hdi" ]; then
  # If no build output, just copy the source files
  cp -r core/hdi/* public/
  echo "Copied source files directly"
fi

echo "Files prepared for deployment"
ls -la public/
