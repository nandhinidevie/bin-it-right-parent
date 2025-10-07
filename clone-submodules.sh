#!/bin/bash
set -e

# Initialize and pull the core submodule only
git submodule update --init --recursive --depth 1 core || true

echo "Submodule contents (core):"
ls -la core || true
ls -la core/hdi || true
