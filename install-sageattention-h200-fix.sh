#!/bin/bash
# Install SageAttention H200/Hopper Fix
# This script installs the working SageAttention commit (68de379) that fixes
# blank/static frame issues on H100/H200 Hopper GPUs
#
# Issue: https://github.com/kijai/ComfyUI-WanVideoWrapper/issues/1554
# Working commit: 68de379 (Sept 27, 2025 - SageAttention3)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMFYUI_BASE="${HOME}/ComfyUI-Easy-Install/ComfyUI-Easy-Install"
PYTHON="${COMFYUI_BASE}/python_embeded/bin/python"

echo "=========================================="
echo "SageAttention H200/Hopper Fix Installer"
echo "=========================================="
echo ""
echo "This installs commit 68de379 which fixes:"
echo "  - Blank/static video frames on H100/H200"
echo "  - Noise artifacts with GGUF models"
echo "  - Hopper architecture compatibility issues"
echo ""

# Check if wheel exists in repo (saved for fast installs)
WHEEL_FILE="${SCRIPT_DIR}/sageattention-2.2.0+68de379-cp312-cp312-linux_aarch64.whl"

# Also check in ComfyUIH200ARM repo if running from elsewhere
if [ ! -f "$WHEEL_FILE" ] && [ -f "${HOME}/ComfyUIH200ARM/sageattention-2.2.0+68de379-cp312-cp312-linux_aarch64.whl" ]; then
    WHEEL_FILE="${HOME}/ComfyUIH200ARM/sageattention-2.2.0+68de379-cp312-cp312-linux_aarch64.whl"
fi

if [ -f "$WHEEL_FILE" ]; then
    echo "✓ Found pre-compiled wheel (saves 5-10 minutes!)"
    echo "  Installing from: $(basename $WHEEL_FILE)"
    echo ""
    
    # Uninstall current version
    echo "Uninstalling current SageAttention..."
    $PYTHON -m pip uninstall -y sageattention || true
    
    # Install from wheel
    echo "Installing fixed version from wheel..."
    $PYTHON -m pip install "$WHEEL_FILE" --force-reinstall
    
else
    echo "⚠ Pre-compiled wheel not found"
    echo "  Will compile from source (takes 5-10 minutes)..."
    echo ""
    
    # Clone and checkout working commit
    TMP_DIR="/tmp/sageattention-h200-fix-$$"
    echo "Cloning SageAttention repository..."
    git clone https://github.com/thu-ml/SageAttention.git "$TMP_DIR"
    cd "$TMP_DIR"
    git checkout 68de379
    
    # Uninstall current version
    echo ""
    echo "Uninstalling current SageAttention..."
    $PYTHON -m pip uninstall -y sageattention || true
    
    # Build and install
    echo ""
    echo "Compiling SageAttention (this takes 5-10 minutes)..."
    echo "  Compiling CUDA kernels for sm_80, sm_90, sm_100, sm_120..."
    $PYTHON -m pip install . --no-build-isolation
    
    # Clean up
    cd /
    rm -rf "$TMP_DIR"
fi

echo ""
echo "=========================================="
echo "Installation complete!"
echo "=========================================="
echo ""
echo "Verifying installation..."
$PYTHON -c "import sageattention; print(f'SageAttention version: {sageattention.__version__}')"
echo ""
echo "✓ SageAttention H200 fix installed successfully"
echo ""
echo "Next steps:"
echo "  1. Restart ComfyUI if it's running"
echo "  2. Test workflow with attention_mode='sageattn'"
echo "  3. If it works, save the wheel for future installs:"
echo "     cp ${COMFYUI_BASE}/python_embeded/lib/python3.12/site-packages/sageattention-*.dist-info ../wheel-name.whl"
echo ""
