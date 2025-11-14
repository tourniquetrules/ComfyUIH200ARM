# ComfyUI H200 Installation Complete! 🎉

## ✅ What's Installed

- **ComfyUI**: Latest version with all dependencies
- **PyTorch**: 2.9.1 with CUDA 12.8 support (ARM64)
- **SageAttention**: Commit 68de379 with H200/Hopper GPU fix
- **GPU**: NVIDIA GH200 480GB (Grace Hopper)
- **Architecture**: ARM64 (aarch64)

## 🚀 How to Start ComfyUI

### Option 1: With SageAttention (Recommended for H200)
```bash
cd /home/ubuntu/ComfyUIH200ARM/ComfyUI-Easy-Install
./run_nvidia_gpu_SageAttention.sh
```

### Option 2: Standard GPU Mode
```bash
cd /home/ubuntu/ComfyUIH200ARM/ComfyUI-Easy-Install
./run_nvidia_gpu.sh
```

## 🌐 Access ComfyUI

Once started, ComfyUI will be available at:
- **Local**: http://127.0.0.1:8188
- **Network**: http://<your-instance-ip>:8188

## ⚡ SageAttention Performance

The installed version provides:
- **1.46x faster** than standard SDPA attention
- **3.57s/iteration** vs 5.2s/iteration (45% speedup)
- **Fixes blank/static frames** on H200/H100 GPUs
- **Requires bf16 precision** for stability

## 🔧 Important: Workflow Configuration

When using workflows with WanVideo/InfiniteTalk, ensure these settings:

```json
{
  "attention_mode": "sageattn",
  "base_precision": "bf16"
}
```

⚠️ **Note**: fp16 will not work with this version - bf16 is required for H200 stability.

## 📁 Installation Location

```
/home/ubuntu/ComfyUIH200ARM/ComfyUI-Easy-Install/
├── ComfyUI/                    # Main ComfyUI directory
├── python_embeded/             # Python environment
├── run_nvidia_gpu.sh           # Standard startup
└── run_nvidia_gpu_SageAttention.sh  # SageAttention startup
```

## 🔍 Verification Commands

Check SageAttention:
```bash
cd /home/ubuntu/ComfyUIH200ARM/ComfyUI-Easy-Install
./python_embeded/bin/python -c "from sageattention.core import sageattn; print('✓ SageAttention working')"
```

Check GPU:
```bash
nvidia-smi
```

Check PyTorch:
```bash
./python_embeded/bin/python -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA: {torch.cuda.is_available()}')"
```

## 📚 Next Steps

1. **Download models** (if needed):
   ```bash
   cd /home/ubuntu/ComfyUIH200ARM
   ./download-wan-infinitetalk-models.sh
   ```

2. **Install workflow** (optional):
   ```bash
   cd /home/ubuntu/ComfyUIH200ARM
   ./install-workflow.sh
   ```

3. **Start ComfyUI**:
   ```bash
   cd ComfyUI-Easy-Install
   ./run_nvidia_gpu_SageAttention.sh
   ```

## 🐛 Troubleshooting

### Still getting blank frames?
1. Restart ComfyUI completely (don't just reload)
2. Verify `base_precision: "bf16"` in your workflow
3. Check you're using SageAttention startup script

### Performance issues?
- Ensure you're using bf16 (not fp16)
- Verify GPU utilization with `nvidia-smi`
- Check memory usage

## 📖 Documentation

- Main README: `/home/ubuntu/ComfyUIH200ARM/README.md`
- SageAttention Fix: `/home/ubuntu/ComfyUIH200ARM/SAGEATTENTION-H200-FIX.md`
- Performance Notes: `/home/ubuntu/ComfyUIH200ARM/H200-PERFORMANCE-NOTES.md`

---

**Installation Date**: November 14, 2025  
**GPU**: NVIDIA GH200 480GB (Grace Hopper)  
**Architecture**: ARM64 (aarch64)  
**CUDA**: 12.8  
**PyTorch**: 2.9.1+cu128  
**SageAttention**: Commit 68de379 (H200 fix)
