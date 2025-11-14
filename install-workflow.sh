#!/bin/bash

# ComfyUI Workflow Installation Script
# Installs the Infinite Talk Workflow to the correct ComfyUI directory

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Auto-detect ComfyUI installation path
if [ -n "$1" ]; then
    # Use provided path
    COMFYUI_PATH="$1"
elif [ -d "${SCRIPT_DIR}/ComfyUI-Easy-Install" ]; then
    # Same directory as script (ComfyUIH200ARM/ComfyUI-Easy-Install)
    COMFYUI_PATH="${SCRIPT_DIR}/ComfyUI-Easy-Install"
elif [ -d "${HOME}/ComfyUI-Easy-Install/ComfyUI-Easy-Install" ]; then
    # Standard path
    COMFYUI_PATH="${HOME}/ComfyUI-Easy-Install/ComfyUI-Easy-Install"
elif [ -d "${HOME}/ComfyUIH200ARM/ComfyUI-Easy-Install" ]; then
    # ComfyUIH200ARM path
    COMFYUI_PATH="${HOME}/ComfyUIH200ARM/ComfyUI-Easy-Install"
else
    echo -e "${RED}✗ Error: Could not find ComfyUI installation${NC}"
    echo -e "${YELLOW}Searched in:${NC}"
    echo -e "  ${SCRIPT_DIR}/ComfyUI-Easy-Install"
    echo -e "  ${HOME}/ComfyUI-Easy-Install/ComfyUI-Easy-Install"
    echo -e "  ${HOME}/ComfyUIH200ARM/ComfyUI-Easy-Install"
    echo
    echo "Usage: $0 [path_to_comfyui_installation]"
    exit 1
fi

# Workflow source and destination
WORKFLOW_FILE="Inifinte Talk Worfklow Wan 2.1 i2v 14B 480p.json"
WORKFLOW_SOURCE="${SCRIPT_DIR}/${WORKFLOW_FILE}"
WORKFLOW_DEST="${COMFYUI_PATH}/ComfyUI/user/default/workflows/${WORKFLOW_FILE}"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     ComfyUI Workflow Installation Script                  ║${NC}"
echo -e "${BLUE}║     Infinite Talk Workflow - Wan 2.1 i2v 14B 480p          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo

# Check if workflow file exists in the script directory
if [ ! -f "$WORKFLOW_SOURCE" ]; then
    echo -e "${RED}✗ Error: Workflow file not found: ${WORKFLOW_SOURCE}${NC}"
    exit 1
fi

# Check if ComfyUI installation exists
if [ ! -d "$COMFYUI_PATH" ]; then
    echo -e "${RED}✗ Error: ComfyUI installation not found at: ${COMFYUI_PATH}${NC}"
    echo
    echo "Usage: $0 [path_to_comfyui_installation]"
    echo "Example: $0 ${HOME}/ComfyUI-Easy-Install/ComfyUI-Easy-Install"
    exit 1
fi

echo -e "${YELLOW}ComfyUI Path:${NC} ${COMFYUI_PATH}"
echo -e "${YELLOW}Workflow File:${NC} ${WORKFLOW_FILE}"
echo

# Create the workflows directory if it doesn't exist
WORKFLOWS_DIR="$(dirname "$WORKFLOW_DEST")"
if [ ! -d "$WORKFLOWS_DIR" ]; then
    echo -e "${YELLOW}→ Creating workflows directory...${NC}"
    mkdir -p "$WORKFLOWS_DIR"
fi

# Copy the workflow file
echo -e "${YELLOW}→ Installing workflow...${NC}"
cp "$WORKFLOW_SOURCE" "$WORKFLOW_DEST"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Workflow installed successfully!${NC}"
    echo
    echo -e "${GREEN}Location:${NC} ${WORKFLOW_DEST}"
    echo
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Installation Complete!${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo
    echo "The workflow is now available in ComfyUI at:"
    echo "  user/default/workflows/${WORKFLOW_FILE}"
    echo
    echo "To use the workflow:"
    echo "  1. Start ComfyUI if not already running"
    echo "  2. Click 'Load' in the ComfyUI interface"
    echo "  3. Navigate to the workflows folder"
    echo "  4. Select '${WORKFLOW_FILE}'"
    echo
else
    echo -e "${RED}✗ Error: Failed to install workflow${NC}"
    exit 1
fi
