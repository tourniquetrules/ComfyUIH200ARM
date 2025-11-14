#!/bin/bash

# Download Models for Infinite Talk Workflow - Wan 2.1 i2v 14B 480p
# This script downloads all required models for the ComfyUI InfiniteTalk workflow

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Auto-detect ComfyUI models directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -n "$1" ]; then
    # Use provided path
    BASE_DIR="$1"
elif [ -d "${SCRIPT_DIR}/ComfyUI-Easy-Install/ComfyUI/models" ]; then
    # Same directory as script (ComfyUIH200ARM/ComfyUI-Easy-Install/ComfyUI/models)
    BASE_DIR="${SCRIPT_DIR}/ComfyUI-Easy-Install/ComfyUI/models"
elif [ -d "${HOME}/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/models" ]; then
    # Standard path
    BASE_DIR="${HOME}/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/models"
elif [ -d "${HOME}/ComfyUIH200ARM/ComfyUI-Easy-Install/ComfyUI/models" ]; then
    # ComfyUIH200ARM path
    BASE_DIR="${HOME}/ComfyUIH200ARM/ComfyUI-Easy-Install/ComfyUI/models"
else
    echo -e "${RED}Error: Could not find ComfyUI models directory${NC}"
    echo -e "${YELLOW}Searched in:${NC}"
    echo -e "  ${SCRIPT_DIR}/ComfyUI-Easy-Install/ComfyUI/models"
    echo -e "  ${HOME}/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/models"
    echo -e "  ${HOME}/ComfyUIH200ARM/ComfyUI-Easy-Install/ComfyUI/models"
    echo -e ""
    echo -e "${YELLOW}Usage: $0 [path/to/ComfyUI/models]${NC}"
    exit 1
fi

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Wan 2.1 InfiniteTalk Model Download Script${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo -e "${YELLOW}Base directory: ${BASE_DIR}${NC}"
echo ""

# Function to download with progress
download_model() {
    local url=$1
    local output_dir=$2
    local filename=$3
    local description=$4
    
    echo -e "${GREEN}Downloading: ${description}${NC}"
    echo -e "${YELLOW}File: ${filename}${NC}"
    
    mkdir -p "${BASE_DIR}/${output_dir}"
    
    if [ -f "${BASE_DIR}/${output_dir}/${filename}" ]; then
        echo -e "${YELLOW}File already exists, resuming download if incomplete...${NC}"
    fi
    
    wget -c "${url}" -O "${BASE_DIR}/${output_dir}/${filename}"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Successfully downloaded ${filename}${NC}"
        echo ""
    else
        echo -e "${RED}✗ Failed to download ${filename}${NC}"
        return 1
    fi
}

# Verify base directory
if [ ! -d "${BASE_DIR}" ]; then
    echo -e "${YELLOW}Creating models directory: ${BASE_DIR}${NC}"
    mkdir -p "${BASE_DIR}"
fi

echo -e "${GREEN}✓ Found ComfyUI models directory: ${BASE_DIR}${NC}"
echo ""
echo -e "${BLUE}Starting model downloads...${NC}"
echo ""

# 1. Main WanVideo Model (9.6 GB)
download_model \
    "https://huggingface.co/city96/Wan2.1-I2V-14B-480P-gguf/resolve/main/wan2.1-i2v-14b-480p-Q4_0.gguf?download=true" \
    "diffusion_models" \
    "wan2.1-i2v-14b-480p-Q4_0.gguf" \
    "Main WanVideo i2v Model (9.6 GB)"

# 2. InfiniteTalk Model (2.5 GB)
download_model \
    "https://huggingface.co/Kijai/WanVideo_comfy_GGUF/resolve/main/InfiniteTalk/Wan2_1-InfiniteTalk_Single_Q8.gguf?download=true" \
    "diffusion_models" \
    "Wan2_1-InfiniteTalk_Single_Q8.gguf" \
    "InfiniteTalk Model (2.5 GB)"

# 3. Lora Model (704 MB)
download_model \
    "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors?download=true" \
    "loras" \
    "lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors" \
    "Lora Model (704 MB)"

# 4. VAE Model (243 MB)
download_model \
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors?download=true" \
    "vae" \
    "wan_2.1_vae.safetensors" \
    "VAE Model (243 MB)"

# 5. CLIP Vision Model (1.2 GB)
download_model \
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors?download=true" \
    "clip_vision" \
    "clip_vision_h.safetensors" \
    "CLIP Vision Model (1.2 GB)"

# 6. Wav2Vec2 Model (182 MB)
download_model \
    "https://huggingface.co/Kijai/wav2vec2_safetensors/resolve/main/wav2vec2-chinese-base_fp16.safetensors?download=true" \
    "wav2vec2" \
    "wav2vec2-chinese-base_fp16.safetensors" \
    "Wav2Vec2 Model (182 MB)"

# 7. Text Encoder Model (11 GB)
download_model \
    "https://huggingface.co/ALGOTECH/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors?download=true" \
    "clip" \
    "umt5-xxl-enc-bf16.safetensors" \
    "Text Encoder Model (11 GB)"

# 8. FLUX CLIP_L Text Encoder (246 MB)
download_model \
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors" \
    "text_encoders" \
    "clip_l.safetensors" \
    "FLUX CLIP_L Text Encoder (246 MB)"

# 9. FLUX T5XXL FP16 Text Encoder (9.8 GB)
download_model \
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors" \
    "text_encoders" \
    "t5xxl_fp16.safetensors" \
    "FLUX T5XXL FP16 Text Encoder (9.8 GB)"

# 10. Lumina Image 2.0 VAE (336 MB)
download_model \
    "https://huggingface.co/Comfy-Org/Lumina_Image_2.0_Repackaged/resolve/main/split_files/vae/ae.safetensors" \
    "vae" \
    "ae.safetensors" \
    "Lumina Image 2.0 VAE (336 MB)"

# 11. FLUX.1-Krea-dev FP8 Model (11.9 GB)
download_model \
    "https://huggingface.co/Comfy-Org/FLUX.1-Krea-dev_ComfyUI/resolve/main/split_files/diffusion_models/flux1-krea-dev_fp8_scaled.safetensors" \
    "diffusion_models" \
    "flux1-krea-dev_fp8_scaled.safetensors" \
    "FLUX.1-Krea-dev FP8 Model (11.9 GB)"

# 12. VibeVoice-Large Model Files (18.7 GB total)
echo -e "${GREEN}Downloading VibeVoice-Large model files...${NC}"

# Download config files first
download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/config.json" \
    "vibevoice" \
    "config.json" \
    "VibeVoice Config"

download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/configuration.json" \
    "vibevoice" \
    "configuration.json" \
    "VibeVoice Configuration"

download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/model.safetensors.index.json" \
    "vibevoice" \
    "model.safetensors.index.json" \
    "VibeVoice Model Index"

download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/preprocessor_config.json" \
    "vibevoice" \
    "preprocessor_config.json" \
    "VibeVoice Preprocessor Config"

# Download all 10 model safetensors files
download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/model-00001-of-00010.safetensors" \
    "vibevoice" \
    "model-00001-of-00010.safetensors" \
    "VibeVoice Model Part 1/10 (1.76 GB)"

download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/model-00002-of-00010.safetensors" \
    "vibevoice" \
    "model-00002-of-00010.safetensors" \
    "VibeVoice Model Part 2/10 (1.74 GB)"

download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/model-00003-of-00010.safetensors" \
    "vibevoice" \
    "model-00003-of-00010.safetensors" \
    "VibeVoice Model Part 3/10 (1.74 GB)"

download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/model-00004-of-00010.safetensors" \
    "vibevoice" \
    "model-00004-of-00010.safetensors" \
    "VibeVoice Model Part 4/10 (1.74 GB)"

download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/model-00005-of-00010.safetensors" \
    "vibevoice" \
    "model-00005-of-00010.safetensors" \
    "VibeVoice Model Part 5/10 (1.74 GB)"

download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/model-00006-of-00010.safetensors" \
    "vibevoice" \
    "model-00006-of-00010.safetensors" \
    "VibeVoice Model Part 6/10 (1.74 GB)"

download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/model-00007-of-00010.safetensors" \
    "vibevoice" \
    "model-00007-of-00010.safetensors" \
    "VibeVoice Model Part 7/10 (1.74 GB)"

download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/model-00008-of-00010.safetensors" \
    "vibevoice" \
    "model-00008-of-00010.safetensors" \
    "VibeVoice Model Part 8/10 (1.84 GB)"

download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/model-00009-of-00010.safetensors" \
    "vibevoice" \
    "model-00009-of-00010.safetensors" \
    "VibeVoice Model Part 9/10 (1.83 GB)"

download_model \
    "https://huggingface.co/aoi-ot/VibeVoice-Large/resolve/main/model-00010-of-00010.safetensors" \
    "vibevoice" \
    "model-00010-of-00010.safetensors" \
    "VibeVoice Model Part 10/10 (1.57 GB)"

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${GREEN}✓ All models downloaded successfully!${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo -e "${YELLOW}Model locations:${NC}"
echo -e "  • Diffusion Models: ${BASE_DIR}/diffusion_models/"
echo -e "  • Loras: ${BASE_DIR}/loras/"
echo -e "  • VAE: ${BASE_DIR}/vae/"
echo -e "  • CLIP Vision: ${BASE_DIR}/clip_vision/"
echo -e "  • Wav2Vec2: ${BASE_DIR}/wav2vec2/"
echo -e "  • Text Encoder: ${BASE_DIR}/clip/"
echo -e "  • FLUX Text Encoders: ${BASE_DIR}/text_encoders/"
echo -e "  • VibeVoice: ${BASE_DIR}/vibevoice/"
echo ""
echo -e "${GREEN}Total downloaded: ~66.2 GB${NC}"
echo -e "${YELLOW}You can now use the Infinite Talk, FLUX, and VibeVoice Workflows in ComfyUI!${NC}"
echo ""
