# SageAttention H200/Hopper Compatibility Fix

## Issue Summary

**Problem:** When using SageAttention 2.2.0 with H100/H200 (Hopper) GPUs, video generation produces blank/static frames or pure noise. Audio works correctly, but video frames are corrupted.

**Affected Hardware:**
- ❌ NVIDIA H100 (sm_90)
- ❌ NVIDIA H200 (sm_120)
- ✅ RTX 4090/5080/4080 Super (Ada - sm_89) - Works fine
- ✅ L40S (Ampere - sm_86) - Works fine

**Symptoms:**
- Video output shows only static/noise
- Audio plays correctly
- No errors in console
- Works perfectly with `attention_mode="sdpa"` but 2x slower

**Root Cause:** Regression introduced in SageAttention between commit 68de379 (Sept 27, 2025) and version 2.2.0 affecting Hopper architecture GPUs when used with GGUF quantized models.

**Upstream Issue:** https://github.com/kijai/ComfyUI-WanVideoWrapper/issues/1554

## Solution

Use SageAttention commit **68de379** (SageAttention3 update) which works correctly on H100/H200.

### Quick Install

```bash
cd ~/ComfyUIH200ARM
./install-sageattention-h200-fix.sh
```

This script will:
1. Check for pre-compiled wheel (if available, installs in <30 seconds)
2. Otherwise, compile from source commit 68de379 (~5-10 minutes)
3. Verify installation

### First Time Setup (Save Wheel for Future)

After the fix is installed and working, save the compiled wheel:

```bash
cd ~/ComfyUIH200ARM
./save-sageattention-wheel.sh
```

This creates `sageattention-2.2.0+68de379-cp312-cp312-linux_aarch64.whl` in your repo, so future installs take <30 seconds instead of 5-10 minutes.

## Verification

Test that video generation works:

1. **Start ComfyUI** (restart if already running)
   ```bash
   cd ~/ComfyUI-Easy-Install/ComfyUI-Easy-Install
   ./run_nvidia_gpu.sh
   ```

2. **Load InfiniteTalk workflow**
   - Open workflow: `Inifinte Talk Worfklow Wan 2.1 i2v 14B 480p.json`
   - Verify `WanVideoModelLoader` has:
     - `attention_mode="sageattn"` (NOT sdpa)
     - `base_precision="bf16"` (slightly faster than fp16)

3. **Generate test video**
   - Use 6 steps (confirmed working on 4090)
   - Check output video has actual motion (not static)
   - Compare speed vs sdpa (should be ~2x faster)

## Technical Details

### What Changed Between Working and Broken Versions

**Commit 68de379 (Sept 27, 2025)** - "SageAttention3" - **WORKS**
- Introduces SageAttention3 implementation
- Proper Hopper kernel selection

**Later commits (Oct-Nov 2025)** - **BROKEN**
- Added torch.compile support
- B200/sm100 architecture additions
- Introduced regression in Hopper (sm_90/sm_120) code path

### Architecture Support in Fixed Version

The working commit (68de379) compiles kernels for:
- `sm_80` - Ampere (A100, A6000)
- `sm_90` - Hopper (H100)
- `sm_100` - (Reserved)
- `sm_120` - Hopper (H200) ← **Your GPU**

### Performance Comparison

| Attention Backend | H200 Status | Speed (it/s) | Quality |
|------------------|-------------|--------------|---------|
| `sdpa` | ✅ Works | ~0.5 it/s | Perfect |
| `sageattn` (v2.2.0) | ❌ Broken | N/A | Static frames |
| `sageattn` (68de379) | ✅ Works | ~1.0 it/s | Perfect |
| `flash_attn_2` | ❓ Untested | Unknown | Unknown |

Expected speedup: **~2x faster** than sdpa

## Files in This Repo

- `install-sageattention-h200-fix.sh` - Main installation script
- `save-sageattention-wheel.sh` - Save compiled wheel after installation
- `SAGEATTENTION-H200-FIX.md` - This document
- `sageattention-2.2.0+68de379-*.whl` - Pre-compiled wheel (if saved)

## Troubleshooting

### Still getting blank frames after fix?

1. Verify correct version is installed:
   ```bash
   cd ~/ComfyUI-Easy-Install/ComfyUI-Easy-Install
   ./python_embeded/bin/python -c "import sageattention; print(sageattention.__version__)"
   ```

2. Clear ComfyUI cache and restart:
   ```bash
   # Stop ComfyUI first
   rm -rf ~/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/temp/*
   ./run_nvidia_gpu.sh
   ```

3. Try alternative attention backends:
   - `sageattn_3` - SageAttention3 explicit variant
   - `flash_attn_2` - Native Hopper Flash Attention
   - `sdpa` - Fallback (always works but slower)

### Compilation fails?

Check CUDA environment:
```bash
nvcc --version  # Should show CUDA 12.8
nvidia-smi      # Should show driver 570+
```

### Wheel won't install on different machine?

The compiled wheel is specific to:
- **Architecture:** ARM64 (aarch64) - won't work on x86_64
- **Python:** 3.12 - won't work on 3.11 or 3.13
- **CUDA:** 12.x - might work on 12.4-12.8
- **GPU:** Hopper preferred but includes sm_80/90

For different systems, compile from source using the install script.

## Future Updates

Monitor these sources for permanent fix:

- SageAttention repo: https://github.com/thu-ml/SageAttention
- WanVideoWrapper issue: https://github.com/kijai/ComfyUI-WanVideoWrapper/issues/1554

When SageAttention officially fixes Hopper support (likely version 2.3.0+), update to official release:

```bash
cd ~/ComfyUI-Easy-Install/ComfyUI-Easy-Install
./python_embeded/bin/python -m pip install sageattention --upgrade
```

## Credits

- **Issue reported by:** klinter007, NikolaySohryakov
- **Fix discovered by:** NikolaySohryakov (commit 68de379)
- **SageAttention authors:** thu-ml team
- **ComfyUI-WanVideoWrapper:** kijai
