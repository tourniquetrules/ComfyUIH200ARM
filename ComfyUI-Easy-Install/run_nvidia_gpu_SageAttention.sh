#!/bin/bash
# ComfyUI Startup Script with SageAttention for H200/H100
# This uses the fixed SageAttention version (commit 68de379)

cd "$(dirname "$0")"

# Detect GPU
GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null || echo "Unknown GPU")

echo "=========================================="
echo "ComfyUI with SageAttention"
echo "=========================================="
echo ""
echo "GPU: ${GPU_NAME}"
echo "SageAttention: Enabled (commit 68de379 - H200 fix)"
echo "Precision: bf16 (required for H200 stability)"
echo ""
echo "ComfyUI will be available at:"
echo "  Local:   http://127.0.0.1:8188"
echo "  Network: http://0.0.0.0:8188"
echo ""
echo "Press Ctrl+C to stop"
echo "=========================================="
echo ""

./python_embeded/bin/python -W ignore::FutureWarning ComfyUI/main.py --use-sage-attention --listen 0.0.0.0 --port 8188 "$@"
