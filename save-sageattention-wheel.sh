#!/bin/bash
# Save compiled SageAttention wheel for future installs
# Run this AFTER install-sageattention-h200-fix.sh completes

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMFYUI_BASE="${HOME}/ComfyUI-Easy-Install/ComfyUI-Easy-Install"
PYTHON="${COMFYUI_BASE}/python_embeded/bin/python"

echo "=========================================="
echo "Save SageAttention Wheel"
echo "=========================================="
echo ""

# Find the built wheel
WHEEL_DIR="/tmp/SageAttention-fix/dist"
if [ -d "$WHEEL_DIR" ]; then
    WHEEL_FILE=$(find "$WHEEL_DIR" -name "sageattention-*.whl" | head -1)
    
    if [ -n "$WHEEL_FILE" ]; then
        DEST="${SCRIPT_DIR}/sageattention-2.2.0+68de379-cp312-cp312-linux_aarch64.whl"
        
        echo "Found wheel: $(basename $WHEEL_FILE)"
        echo "Copying to: $(basename $DEST)"
        cp "$WHEEL_FILE" "$DEST"
        
        echo ""
        echo "✓ Wheel saved successfully!"
        echo ""
        echo "Wheel size: $(du -h $DEST | cut -f1)"
        echo ""
        echo "Next time you run install-sageattention-h200-fix.sh,"
        echo "it will use this pre-compiled wheel (saves 5-10 minutes)."
        echo ""
        echo "⚠ Note: This wheel is specific to:"
        echo "  - ARM64 architecture (aarch64)"
        echo "  - Python 3.12"
        echo "  - CUDA 12.x"
        echo "  - H200/Hopper (sm_120) with sm_80/90/100 support"
        echo ""
    else
        echo "✗ No wheel file found in $WHEEL_DIR"
        echo "  Make sure compilation completed successfully."
        exit 1
    fi
else
    echo "✗ Build directory not found: $WHEEL_DIR"
    echo ""
    echo "Alternative method - extract from installed package:"
    echo "  1. Check if SageAttention is installed:"
    $PYTHON -c "import sageattention; print(f'   Version: {sageattention.__version__}')" 2>/dev/null || echo "   Not installed!"
    echo ""
    echo "  If you need the wheel, you can rebuild it with:"
    echo "    cd /tmp/SageAttention-fix && $PYTHON setup.py bdist_wheel"
fi
