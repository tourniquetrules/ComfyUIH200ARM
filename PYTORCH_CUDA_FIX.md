# PyTorch CUDA Installation Fix

## The Problem

The original `ComfyUI-Easy-Install.sh` script (line 120) installs PyTorch without specifying CUDA:
```bash
python -m pip install torch torchvision torchaudio
```

This causes pip to install the **CPU-only version** by default, even on systems with NVIDIA GPUs, resulting in the error:
```
AssertionError: Torch not compiled with CUDA enabled
```

## Quick Fix (If Already Installed)

If you've already run the installer and got the CUDA error, run these commands:

```bash
cd /home/ubuntu/ComfyUI-Easy-Install/ComfyUI-Easy-Install
./python_embeded/bin/pip uninstall -y torch torchvision torchaudio
./python_embeded/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
```

Then run ComfyUI:
```bash
./run_nvidia_gpu.sh
```

## Permanent Fix Applied

The installer script has been updated to automatically detect your hardware:

### Detection Logic:
1. **macOS** → Installs PyTorch with MPS (Metal) support
2. **Linux with NVIDIA GPU** → Installs PyTorch with CUDA support (auto-detects CUDA version)
3. **Linux without GPU** → Installs CPU-only PyTorch

### CUDA Version Support:
- **CUDA 12.x** → Uses `cu128` wheels
- **CUDA 11.x** → Uses `cu118` wheels
- **Unsupported versions** → Defaults to `cu128`

## Verify Installation

After installation, verify PyTorch can see your GPU:

```bash
./python_embeded/bin/python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}'); print(f'GPU: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"N/A\"}')"
```

Expected output:
```
CUDA available: True
GPU: NVIDIA GH200 480GB
```

## For Future Installations

The updated script will now automatically install the correct PyTorch version based on your system. Simply run:

```bash
./ComfyUI-Easy-Install.sh
```

No manual intervention needed!
