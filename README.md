# ComfyUI Easy Install for H200 ARM64 (NVIDIA Grace Hopper)

This repository contains a fixed version of ComfyUI-Easy-Install that properly installs PyTorch with CUDA support for NVIDIA H200 ARM64 systems (Grace Hopper architecture).

## What's Fixed

The original installer script installed PyTorch without CUDA support, causing this error:
```
AssertionError: Torch not compiled with CUDA enabled
```

This version automatically detects your NVIDIA GPU and installs PyTorch with the correct CUDA version.

## System Requirements

- **OS**: Linux (Ubuntu 22.04+ recommended)
- **GPU**: NVIDIA GPU with CUDA support (tested on NVIDIA GH200 480GB)
- **Architecture**: ARM64 (aarch64)
- **Python**: 3.11 or 3.12
- **CUDA**: 11.x or 12.x

## Quick Start

### 1. Clone this repository

```bash
cd ~
git clone https://github.com/tourniquetrules/ComfyUIH200ARM.git
cd ComfyUIH200ARM
```

### 2. Run the installer

```bash
chmod +x ComfyUI-Easy-Install.sh
./ComfyUI-Easy-Install.sh
```

The script will:
- Detect your NVIDIA GPU
- Install PyTorch with CUDA 12.8 support (for CUDA 12.x) or CUDA 11.8 (for CUDA 11.x)
- Install ComfyUI and all custom nodes
- Set up the Python virtual environment
- Configure everything automatically

### 3. Launch ComfyUI

After installation completes:

```bash
cd ComfyUI-Easy-Install
./run_nvidia_gpu.sh
```

ComfyUI will be available at: `http://127.0.0.1:8188`

## Features Included

### ComfyUI Core
- ComfyUI latest version
- Python 3.12 embedded environment (or 3.11 if you change the script)
- Full GPU acceleration with CUDA

### Custom Nodes (from Pixaroma tutorials)
- ComfyUI-Manager
- was-node-suite
- Easy-Use
- controlnet_aux
- Comfyroll Studio
- Crystools
- rgthree
- GGUF support
- Florence2
- Searge_LLM
- ControlAltAI-Nodes
- Ollama integration
- iTools
- seamless-tiling
- Inpaint-CropAndStitch
- canvas_tab
- OmniGen
- Inspyrenet-Rembg
- AdvancedReduxControl
- VideoHelperSuite
- AdvancedLivePortrait
- ToSVG
- Kokoro
- Janus-Pro
- Sonic
- TeaCache
- KayTool
- Tiled Diffusion & VAE
- LTXVideo
- KJNodes
- WanVideoWrapper
- VibeVoice

## Troubleshooting

### If you get the CUDA error after installation

If for some reason the auto-detection fails, you can manually fix PyTorch:

```bash
cd ~/ComfyUIH200ARM/ComfyUI-Easy-Install
./python_embeded/bin/pip uninstall -y torch torchvision torchaudio
./python_embeded/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
```

### Verify CUDA is working

```bash
cd ~/ComfyUIH200ARM/ComfyUI-Easy-Install
./python_embeded/bin/python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}'); print(f'GPU: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"N/A\"}')"
```

Expected output:
```
CUDA available: True
GPU: NVIDIA GH200 480GB
```

## Technical Details

### What Changed in the Installer

The script now includes automatic hardware detection:

**Lines 120-144 in ComfyUI-Easy-Install.sh:**
```bash
# Detect platform and install appropriate PyTorch version
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS - use default (includes MPS support)
    python -m pip install torch torchvision torchaudio
elif command -v nvidia-smi &> /dev/null; then
    # Linux with NVIDIA GPU - install CUDA version
    CUDA_VERSION=$(nvidia-smi | grep "CUDA Version" | awk '{print $9}' | cut -d'.' -f1,2)
    # Install appropriate CUDA wheels based on detected version
    if [[ "${CUDA_VERSION%%.*}" == "12" ]]; then
        python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
    elif [[ "${CUDA_VERSION%%.*}" == "11" ]]; then
        python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
    fi
else
    # CPU version
    python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
fi
```

### Installation Path

The installer creates a `ComfyUI-Easy-Install` directory with:
- `python_embeded/` - Python virtual environment
- `ComfyUI/` - ComfyUI application
- `update/` - Update scripts
- `Add-Ons/` - Additional installation scripts
- `run_nvidia_gpu.sh` - Launch script for NVIDIA GPUs

## Performance

On NVIDIA GH200 480GB:
- **Total VRAM**: 96,768 MB
- **PyTorch version**: 2.9.0+cu128
- **VRAM mode**: NORMAL_VRAM (full GPU memory available)
- **Attention**: pytorch attention (optimized)

## Credits

- Original ComfyUI-Easy-Install by [VenimK/Tavris1](https://github.com/Tavris1/ComfyUI-Easy-Install)
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI) by comfyanonymous
- Custom nodes by [Pixaroma community](https://discord.com/invite/gggpkVgBf3)

## License

Same as the original ComfyUI-Easy-Install repository.

## Support

For issues specific to H200 ARM64 / Grace Hopper:
- Open an issue on this repository

For general ComfyUI questions:
- [ComfyUI GitHub](https://github.com/comfyanonymous/ComfyUI)
- [Pixaroma Discord](https://discord.com/invite/gggpkVgBf3)
