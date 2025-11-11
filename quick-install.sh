#!/bin/bash

# Quick install script for ComfyUI on H200 ARM64
# This script will clone the repo and run the installer automatically

set -e

echo "=================================================="
echo "ComfyUI Easy Install for H200 ARM64"
echo "=================================================="
echo ""

# Check if we're on ARM64
if [ "$(uname -m)" != "aarch64" ]; then
    echo "⚠️  Warning: This script is designed for ARM64 architecture"
    echo "   Detected: $(uname -m)"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check for NVIDIA GPU
if ! command -v nvidia-smi &> /dev/null; then
    echo "❌ Error: nvidia-smi not found. NVIDIA drivers may not be installed."
    exit 1
fi

echo "✅ NVIDIA GPU detected:"
nvidia-smi --query-gpu=name --format=csv,noheader
echo ""

# Check for git
if ! command -v git &> /dev/null; then
    echo "❌ Error: git is not installed"
    echo "   Install with: sudo apt-get install git"
    exit 1
fi

# Clone the repository if not already in it
if [ ! -f "ComfyUI-Easy-Install.sh" ]; then
    echo "📥 Cloning repository..."
    git clone https://github.com/tourniquetrules/ComfyUIH200ARM.git
    cd ComfyUIH200ARM
fi

# Make installer executable
chmod +x ComfyUI-Easy-Install.sh

echo ""
echo "=================================================="
echo "Starting ComfyUI installation..."
echo "=================================================="
echo ""

# Run the installer
./ComfyUI-Easy-Install.sh

echo ""
echo "=================================================="
echo "✨ Installation complete!"
echo "=================================================="
echo ""
echo "To launch ComfyUI:"
echo "  cd ComfyUI-Easy-Install"
echo "  ./run_nvidia_gpu.sh"
echo ""
echo "ComfyUI will be available at: http://127.0.0.1:8188"
echo ""
