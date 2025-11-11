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

# Base directory (adjust if needed)
BASE_DIR="${1:-ComfyUI-Easy-Install/ComfyUI/models}"

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

# Check if base directory exists
if [ ! -d "$(dirname "${BASE_DIR}")" ]; then
    echo -e "${RED}Error: Base directory path does not exist: $(dirname "${BASE_DIR}")${NC}"
    echo -e "${YELLOW}Please run this script from your ComfyUI installation directory, or provide the correct path.${NC}"
    echo -e "${YELLOW}Usage: $0 [path/to/ComfyUI/models]${NC}"
    exit 1
fi

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
    "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors?download=true" \
    "loras" \
    "lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors" \
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
echo ""
echo -e "${GREEN}Total downloaded: ~25.5 GB${NC}"
echo -e "${YELLOW}You can now use the Infinite Talk Workflow in ComfyUI!${NC}"
echo ""
