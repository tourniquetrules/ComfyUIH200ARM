# Wan 2.1 InfiniteTalk Models Download Script

This script automatically downloads all required models for the **Infinite Talk Workflow - Wan 2.1 i2v 14B 480p** in ComfyUI.

## Models Included

The script downloads ~25.5 GB of models:

1. **wan2.1-i2v-14b-480p-Q4_0.gguf** (9.6 GB) - Main WanVideo i2v model
2. **Wan2_1-InfiniteTalk_Single_Q8.gguf** (2.5 GB) - InfiniteTalk model
3. **lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors** (704 MB) - Lora model
4. **wan_2.1_vae.safetensors** (243 MB) - VAE model
5. **clip_vision_h.safetensors** (1.2 GB) - CLIP Vision model
6. **wav2vec2-chinese-base_fp16.safetensors** (182 MB) - Wav2Vec2 model
7. **umt5-xxl-enc-bf16.safetensors** (11 GB) - Text Encoder model

## Usage

### Default Installation

If you followed the standard installation, run from the ComfyUI-Easy-Install directory:

```bash
cd ~/ComfyUI-Easy-Install
./download-wan-infinitetalk-models.sh
```

The script will automatically download models to `ComfyUI-Easy-Install/ComfyUI/models/`

### Custom Installation Path

If your ComfyUI models are in a different location:

```bash
./download-wan-infinitetalk-models.sh /path/to/your/ComfyUI/models
```

## Features

- ✅ **Resume support**: Can resume interrupted downloads
- ✅ **Progress display**: Shows download progress for each model
- ✅ **Error handling**: Stops on errors with clear messages
- ✅ **Color output**: Easy to read colored terminal output
- ✅ **Directory creation**: Automatically creates needed directories

## Requirements

- `wget` installed (usually pre-installed on Linux)
- ~26 GB free disk space
- Internet connection with good bandwidth

## Model Locations

After download, models will be in:

```
ComfyUI/models/
├── diffusion_models/
│   ├── wan2.1-i2v-14b-480p-Q4_0.gguf
│   └── Wan2_1-InfiniteTalk_Single_Q8.gguf
├── loras/
│   └── lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors
├── vae/
│   └── wan_2.1_vae.safetensors
├── clip_vision/
│   └── clip_vision_h.safetensors
├── wav2vec2/
│   └── wav2vec2-chinese-base_fp16.safetensors
└── clip/
    └── umt5-xxl-enc-bf16.safetensors
```

## Troubleshooting

### Download Fails

If a download fails, simply run the script again. It will resume from where it stopped.

### Permission Denied

Make sure the script is executable:

```bash
chmod +x download-wan-infinitetalk-models.sh
```

### Directory Not Found

Ensure you're running the script from the correct directory or provide the full path to your ComfyUI models folder.

## Related Resources

- [Original Workflow](https://github.com/tourniquetrules/ComfyUIH200ARM) - The workflow this downloads models for
- [Pixaroma YouTube](https://www.youtube.com/@pixaroma) - Tutorials and guides
- [Pixaroma Discord](https://discord.com/invite/gggpkVgBf3) - Community support

## Credits

Models sourced from:
- [city96/Wan2.1-I2V-14B-480P-gguf](https://huggingface.co/city96/Wan2.1-I2V-14B-480P-gguf)
- [Kijai/WanVideo_comfy_GGUF](https://huggingface.co/Kijai/WanVideo_comfy_GGUF)
- [Kijai/WanVideo_comfy](https://huggingface.co/Kijai/WanVideo_comfy)
- [Comfy-Org/Wan_2.1_ComfyUI_repackaged](https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged)
- [Kijai/wav2vec2_safetensors](https://huggingface.co/Kijai/wav2vec2_safetensors)
- [ALGOTECH/WanVideo_comfy](https://huggingface.co/ALGOTECH/WanVideo_comfy)
