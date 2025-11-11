# ComfyUI H200/H100 ARM64 Setup & SageAttention Fix

Complete setup guide and fixes for running ComfyUI on NVIDIA H200/H100 (Hopper) GPUs, including the critical SageAttention compatibility fix.

## 🎯 Quick Start

### Fresh H200/H100 Installation

```bash
# 1. Clone this repository
git clone https://github.com/tourniquetrules/ComfyUIH200ARM.git
cd ComfyUIH200ARM

# 2. Install SageAttention fix
./install-sageattention-h200-fix.sh
# Uses pre-compiled wheel (ARM64) or compiles from source (x86_64)
# Takes: 30 seconds (wheel) or 5-10 minutes (compile)

# 3. Download InfiniteTalk models
./download-wan-infinitetalk-models.sh
# Downloads ~25.5GB of models

# 4. Install workflow
./install-workflow.sh
# Places workflow in ComfyUI/user/default/workflows/
```

### Integration with ComfyUI-Easy-Install

If you're using [ComfyUI-Easy-Install](https://github.com/Tavris1/ComfyUI-Easy-Install):

```bash
# Option A: Use modified SageAttention installer
cp SageAttention-NEXT-H200.sh ~/ComfyUI-Easy-Install/ComfyUI-Easy-Install/Add-Ons/SageAttention-NEXT.sh
cd ~/ComfyUI-Easy-Install/ComfyUI-Easy-Install/Add-Ons
./SageAttention-NEXT.sh

# Option B: Use standalone installer (this repo)
./install-sageattention-h200-fix.sh
```

## 🐛 The Problem

**Issue:** SageAttention 2.2.0 produces blank/static video frames on H100/H200 (Hopper) GPUs.

**Symptoms:**
- Video output shows only static noise or blank frames
- Audio plays correctly
- No errors in console
- Works fine on RTX 4090/5080 (Ada) and L40S (Ampere)

**Root Cause:** Regression introduced in SageAttention between commit 68de379 (Sept 27, 2025) and version 2.2.0 affecting Hopper architecture GPUs when used with GGUF quantized models.

**Upstream Issue:** [ComfyUI-WanVideoWrapper #1554](https://github.com/kijai/ComfyUI-WanVideoWrapper/issues/1554)

## ✅ The Solution

Install SageAttention commit **68de379** (SageAttention3) which works correctly on H100/H200.

### Affected Hardware

| GPU | Architecture | Status | Notes |
|-----|-------------|---------|-------|
| **H100** | Hopper (sm_90) | ❌ Broken in 2.2.0 | ✅ Fixed with 68de379 |
| **H200** | Hopper (sm_120) | ❌ Broken in 2.2.0 | ✅ Fixed with 68de379 |
| RTX 4090/5080/4080S | Ada (sm_89) | ✅ Works | No fix needed |
| L40S | Ampere (sm_86) | ✅ Works | No fix needed |

## 📊 Performance Results

Tested on **NVIDIA H200 480GB** (Grace Hopper, ARM64):

| Configuration | Speed (s/it) | Status | Video Quality |
|--------------|--------------|---------|---------------|
| **sageattn (68de379) + bf16** | **3.57s** | ✅ **WORKS** | Perfect ✓ |
| sdpa + bf16 | 5.2s | ✅ Works | Perfect ✓ |
| sageattn (2.2.0) + fp16 | 2.3s | ❌ Broken | Static frames |

**Speedup: 1.46x faster than sdpa** (45% improvement)

### Important: bf16 Requirement

⚠️ **The fixed version REQUIRES bf16 precision:**
- ✅ `base_precision: "bf16"` - **REQUIRED**
- ❌ `base_precision: "fp16"` or `"fp16_fast"` - **Will error**

This is expected behavior for Hopper GPU stability with GGUF quantized models.

**Why bf16 only?**
- H200 Hopper tensor cores use FP22 accumulators (1 sign, 8 exp, 13 mantissa)
- bf16 (8 exp bits) aligns better than fp16 (5 exp bits)
- GGUF quantization + fp16 + SageAttention = numerical instability on Hopper
- Commit 68de379 enforces bf16 for stability

**Trade-off:** Slightly slower than 4090 fp16 mode (2.3s → 3.57s), but **actually produces valid video!**

## 📁 Files in This Repository

### Installation Scripts
- **`SageAttention-NEXT-H200.sh`** - Modified ComfyUI-Easy-Install script with H200/H100 auto-detection
- **`install-sageattention-h200-fix.sh`** - Standalone installer (checks for wheel, falls back to compile)
- **`download-wan-infinitetalk-models.sh`** - Downloads all required models (~25.5GB)
- **`install-workflow.sh`** - Installs workflow JSON to ComfyUI directory

### Pre-compiled Wheel
- **`sageattention-2.2.0+68de379-cp312-cp312-linux_aarch64.whl`** (11MB)
  - Pre-compiled for ARM64 (H200 Grace Hopper)
  - Python 3.12, CUDA 12.x
  - Saves 5-10 minutes on installation
  - **Note:** Won't work on x86_64 (Lambda H100) - will auto-compile instead

### Workflow
- **`Inifinte Talk Worfklow Wan 2.1 i2v 14B 480p.json`** - InfiniteTalk workflow configured for H200

### Documentation
- **`SAGEATTENTION-H200-FIX.md`** - Technical details and troubleshooting
- **`INSTALL-GUIDE.md`** - Complete step-by-step usage instructions
- **`H200-PERFORMANCE-NOTES.md`** - Detailed performance benchmarks and bf16 explanation
- **`MODEL-DOWNLOAD-README.md`** - Model download information
- **`README.md`** - This file

### Helper Scripts
- **`save-sageattention-wheel.sh`** - Save compiled wheel after building

## 🔧 Workflow Configuration

For H200/H100, ensure these settings in your workflow:

```json
{
  "WanVideoModelLoader": {
    "model": "wan2.1-i2v-14b-480p-Q4_0.gguf",
    "attention_mode": "sageattn",
    "base_precision": "bf16"  // ← MUST be bf16, not fp16
  },
  "WanVideoSampler": {
    "steps": 6,
    "cfg": 1.0,
    "shift": 11.0,
    "scheduler": "dpm++_sde"
  }
}
```

## 🚀 Usage Instructions

### For H200 Grace Hopper (ARM64)

Uses pre-compiled wheel - **fast installation (~30 seconds):**

```bash
cd ComfyUIH200ARM
./install-sageattention-h200-fix.sh
```

### For Lambda.ai H100 (x86_64)

Auto-compiles for x86_64 architecture (~5-10 minutes):

```bash
# Clone repo
git clone https://github.com/tourniquetrules/ComfyUIH200ARM.git
cd ComfyUIH200ARM

# Run installer (will compile for x86_64)
./install-sageattention-h200-fix.sh

# Or use modified ComfyUI-Easy-Install script
cp SageAttention-NEXT-H200.sh ~/ComfyUI-Easy-Install/ComfyUI-Easy-Install/Add-Ons/SageAttention-NEXT.sh
cd ~/ComfyUI-Easy-Install/ComfyUI-Easy-Install/Add-Ons
./SageAttention-NEXT.sh
```

### Verification

After installation, verify it works:

```bash
cd ~/ComfyUI-Easy-Install/ComfyUI-Easy-Install

# Check SageAttention imports
./python_embeded/bin/python -c "from sageattention.core import sageattn; print('✓ SageAttention working')"

# Check GPU
./python_embeded/bin/python -c "import torch; print(f'CUDA: {torch.cuda.is_available()}, GPU: {torch.cuda.get_device_name(0)}')"
```

## 📋 Models Required

Download these models for InfiniteTalk workflow:

| Model | Size | Location |
|-------|------|----------|
| wan2.1-i2v-14b-480p-Q4_0.gguf | 9.6GB | `models/diffusion_models/` |
| Wan2_1-InfiniteTalk_Single_Q8.gguf | 2.5GB | `models/diffusion_models/` |
| lightx2v rank256 LoRA | 2.8GB | `models/loras/` |
| wan_2.1_vae.safetensors | 243MB | `models/vae/` |
| clip_vision_h.safetensors | 1.2GB | `models/clip_vision/` |
| wav2vec2-chinese-base_fp16 | 182MB | `models/wav2vec2/` |
| umt5-xxl-enc-bf16.safetensors | 11GB | `models/clip/` |

**Total:** ~25.5GB

Use the provided script: `./download-wan-infinitetalk-models.sh`

## 🔍 Troubleshooting

### Still getting blank frames?

1. **Restart ComfyUI completely** (stop and start, don't just reload)
2. **Clear cache:** `rm -rf ~/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/temp/*`
3. **Verify bf16 precision** in WanVideoModelLoader node
4. **Check SageAttention version:**
   ```bash
   ./python_embeded/bin/python -c "import sageattention; print(sageattention.__file__)"
   ```

### Compilation errors?

Check CUDA environment:
```bash
nvcc --version  # Should be CUDA 12.x
nvidia-smi      # Should show driver 550+
```

### fp16 errors?

This is expected! Switch to `base_precision: "bf16"` in your workflow.

## 🏗️ System Requirements

**Hardware:**
- NVIDIA H100 or H200 GPU (Hopper architecture)
- 80GB+ VRAM recommended
- CUDA 12.4+ capable

**Software:**
- CUDA Toolkit 12.4-12.8
- Python 3.11 or 3.12
- PyTorch 2.7+ with CUDA support
- Driver 550+ (570+ recommended)

## 🔗 References

- **This Repository:** https://github.com/tourniquetrules/ComfyUIH200ARM
- **Issue Report:** https://github.com/kijai/ComfyUI-WanVideoWrapper/issues/1554
- **SageAttention:** https://github.com/thu-ml/SageAttention
- **Working Commit:** https://github.com/thu-ml/SageAttention/commit/68de379
- **ComfyUI-Easy-Install:** https://github.com/Tavris1/ComfyUI-Easy-Install
- **ComfyUI-WanVideoWrapper:** https://github.com/kijai/ComfyUI-WanVideoWrapper

## 📝 Credits

- **Issue discovered by:** klinter007, NikolaySohryakov
- **Fix identified by:** NikolaySohryakov (commit 68de379)
- **SageAttention authors:** thu-ml team
- **ComfyUI-WanVideoWrapper:** kijai
- **ComfyUI-Easy-Install:** Tavris1 (ivo)

## 📄 License

Scripts and documentation in this repository are provided as-is for community use. Please respect the licenses of the underlying projects (ComfyUI, SageAttention, WanVideo, etc.).

## 🤝 Contributing

Found an issue or improvement? Please open an issue or PR!

---

**Last Updated:** November 11, 2025  
**Tested On:** NVIDIA H200 480GB (Grace Hopper, ARM64), CUDA 12.8, PyTorch 2.9.0+cu128
