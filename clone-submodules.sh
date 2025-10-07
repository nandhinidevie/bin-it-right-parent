#!/bin/bash
set -e

# Initialize and pull only the core submodule
git submodule update --init --recursive --depth 1 core || true

# Print tree for verification
echo "Submodule contents:"
ls -la core || true
ls -la core/hdi || true
