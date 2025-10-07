#!/bin/bash
set -e

# Initialize and pull the core submodule
git submodule update --init --recursive --depth 1 core || true

echo "Submodule contents (core):"
ls -la core
ls -la core/hdi || true
