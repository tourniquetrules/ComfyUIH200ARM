#!/bin/bash
cd "$(dirname "$0")"

node_name="SageAttention"
echo -e "\033]0;'$node_name' for 'ComfyUI Easy Install' by ivo\007"

# Pixaroma Community Edition

# Set colors
warning='\033[33m'
red='\033[91m'
green='\033[92m'
yellow='\033[93m'
bold='\033[1m'
reset='\033[0m'

# Set arguments
PIPargs="--no-cache-dir --no-warn-script-location --timeout=1000 --retries 200 --use-pep517"

# Check Add-ons folder
PYTHON_PATH="../python_embeded/bin/python"
if [ ! -f "$PYTHON_PATH" ]; then
    # Fallback to python3 if not in the expected embedded path
    if command -v python3 &> /dev/null; then
        PYTHON_PATH=$(command -v python3)
    else
        clear
        echo -e "${green}::::::::::::::: Run this file from the ${red}'ComfyUI-Easy-Install/Add-ons'${green} folder, or ensure python3 is in your PATH.${reset}"
        echo -e "${green}::::::::::::::: Press any key to exit...${reset}"
        read -n 1 -s
        exit
    fi
fi


# Clear Pip Cache
if [ -d "$HOME/.cache/pip" ]; then
    rm -rf "$HOME/.cache/pip"
    mkdir -p "$HOME/.cache/pip"
fi
echo -e "${green}::::::::::::::: Clearing Pip Cache ${yellow}Done${green}${reset}"
echo

# Get versions
get_versions() {
    echo -e "${green}::::::::::::::: Checking ${yellow}Python, Torch, CUDA ${green}versions${reset}"
    echo

    PYTHON_VERSION=$("$PYTHON_PATH" --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
    TORCH_VERSION=$("$PYTHON_PATH" -c "import torch; print(torch.__version__)" 2>/dev/null | cut -d'.' -f1,2)
    CUDA_VERSION=$("$PYTHON_PATH" -c "import torch; print(torch.version.cuda if torch.cuda.is_available() else 'Not available')" 2>/dev/null | cut -d'.' -f1,2)

    echo -e "${green}::::::::::::::: Python Version:${yellow} $PYTHON_VERSION${reset}"
    echo -e "${green}::::::::::::::: Torch Version:${yellow} $TORCH_VERSION${reset}"
    echo -e "${green}::::::::::::::: CUDA Version:${yellow} $CUDA_VERSION${reset}"
    echo

    WARNINGS=0

    if [[ "$PYTHON_VERSION" != "3.11" && "$PYTHON_VERSION" != "3.12" ]]; then
        echo -e "${warning}WARNING: ${red}Python $PYTHON_VERSION is not supported. ${green}Supported versions: 3.11, 3.12${reset}"
        WARNINGS=1
    fi
    # Torch might not be installed yet, so check if TORCH_VERSION is empty
    if [ -z "$TORCH_VERSION" ]; then
        echo -e "${warning}WARNING: ${red}Torch is not installed. Please install PyTorch before running this script.${reset}"
        WARNINGS=1
    elif [[ "$TORCH_VERSION" != "2.7" && "$TORCH_VERSION" != "2.8" && "$TORCH_VERSION" != "2.9" ]]; then
        echo -e "${warning}WARNING: ${red}Torch $TORCH_VERSION is not supported. ${green}Supported versions: 2.7, 2.8, 2.9${reset}"
        WARNINGS=1
    fi
    if [[ "$CUDA_VERSION" != "12.8" ]]; then
        echo -e "${warning}WARNING: ${red}CUDA $CUDA_VERSION is not supported. ${green}Supported version: 12.8${reset}"
        WARNINGS=1
    fi

    if [ $WARNINGS -eq 0 ]; then
        echo -e "${green}::::::::::::::: ${reset}${bold}All versions are supported! ${reset}"
        echo
    else
        echo
        echo -e "${red}::::::::::::::: Press any key to exit${reset}"
        read -n 1 -s
        exit
    fi
}

get_versions

# Check for Python development headers
echo -e "${green}::::::::::::::: Checking ${yellow}Python development headers${reset}"
echo

if ! "$PYTHON_PATH" -c "import sysconfig; import os; print(os.path.exists(os.path.join(sysconfig.get_path('include'), 'Python.h')))" 2>/dev/null | grep -q "True"; then
    echo -e "${warning}WARNING: ${red}Python development headers (Python.h) not found.${reset}"
    echo
    echo -e "${yellow}SageAttention requires Python development headers to compile C++ extensions.${reset}"
    echo -e "${yellow}Please install them using one of these methods:${reset}"
    echo
    echo -e "${green}Ubuntu/Debian:${reset}"
    echo -e "  ${bold}sudo apt-get update && sudo apt-get install -y python3.11-dev${reset}"
    echo
    echo -e "${green}RHEL/CentOS/Fedora:${reset}"
    echo -e "  ${bold}sudo yum install -y python3.11-devel${reset}"
    echo
    echo -e "${green}Arch Linux:${reset}"
    echo -e "  ${bold}sudo pacman -S python${reset}"
    echo
    echo -e "${red}::::::::::::::: Press any key to exit${reset}"
    read -n 1 -s
    exit 1
fi

echo -e "${green}::::::::::::::: Python development headers ${yellow}found!${reset}"
echo

# Erasing ~* folders
find "../python_embeded/lib/" -type d -name "~*" -exec rm -rf {} + 2>/dev/null

# Installing build dependencies
echo -e "${green}::::::::::::::: Installing${yellow} build dependencies${reset}"
echo
"$PYTHON_PATH" -m pip install --upgrade wheel setuptools $PIPargs
echo

# Installing Triton
echo -e "${green}::::::::::::::: Installing${yellow} Triton${reset}"
echo
"$PYTHON_PATH" -I -m pip install --upgrade --force-reinstall triton==3.5.0 $PIPargs
echo

# Detect GPU architecture
echo -e "${green}::::::::::::::: Detecting${yellow} GPU architecture${reset}"
GPU_ARCH=$("$PYTHON_PATH" -c "import torch; print(torch.cuda.get_device_capability(0) if torch.cuda.is_available() else (0,0))" 2>/dev/null)
GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)
echo -e "${green}::::::::::::::: GPU:${yellow} $GPU_NAME${reset}"
echo -e "${green}::::::::::::::: Compute Capability:${yellow} $GPU_ARCH${reset}"
echo

# Check if Hopper architecture (H100/H200)
IS_HOPPER=0
if echo "$GPU_ARCH" | grep -qE "\(9, 0\)|\(12, 0\)"; then
    IS_HOPPER=1
    echo -e "${warning}WARNING: ${yellow}H100/H200 (Hopper) GPU detected!${reset}"
    echo -e "${yellow}SageAttention 2.2.0 has a known bug on Hopper GPUs that causes blank video frames.${reset}"
    echo -e "${yellow}Installing fixed version (commit 68de379) instead...${reset}"
    echo -e "${yellow}Issue: https://github.com/kijai/ComfyUI-WanVideoWrapper/issues/1554${reset}"
    echo
fi

# Installing SageAttention
echo -e "${green}::::::::::::::: Installing${yellow} $node_name${reset}"
echo

if [ $IS_HOPPER -eq 1 ]; then
    # Install H200/Hopper fix (commit 68de379 - Sept 27, 2025)
    echo -e "${green}::::::::::::::: Using${yellow} H200/Hopper compatible version (68de379)${reset}"
    "$PYTHON_PATH" -m pip install --upgrade --no-build-isolation git+https://github.com/thu-ml/SageAttention@68de379 $PIPargs
else
    # Install latest for non-Hopper GPUs
    echo -e "${green}::::::::::::::: Using${yellow} latest SageAttention${reset}"
    "$PYTHON_PATH" -m pip install --upgrade --no-build-isolation git+https://github.com/thu-ml/SageAttention $PIPargs
fi

# Creating run_nvidia_gpu_SageAttention.sh file
echo
echo -e "${green}::::::::::::::: Creating${yellow} run_nvidia_gpu_SageAttention.sh${reset}"
echo
echo "#!/bin/bash" > ../run_nvidia_gpu_SageAttention.sh
echo "cd \"\$(dirname \"\$0\")\"" >> ../run_nvidia_gpu_SageAttention.sh
echo "echo \"Title ComfyUI-Easy-Install\"" >> ../run_nvidia_gpu_SageAttention.sh
echo "./python_embeded/bin/python -W ignore::FutureWarning ComfyUI/main.py --use-sage-attention" >> ../run_nvidia_gpu_SageAttention.sh
chmod +x ../run_nvidia_gpu_SageAttention.sh


# Final Messages
echo
echo -e "${green}:::::::::::::::${yellow} $node_name ${green}Installation Complete${reset}"
echo

# Show installed version
SAGE_VERSION=$("$PYTHON_PATH" -c "import sageattention; print(sageattention.__version__)" 2>/dev/null || echo "Unknown")
echo -e "${green}::::::::::::::: Installed Version:${yellow} $SAGE_VERSION${reset}"

if [ $IS_HOPPER -eq 1 ]; then
    echo
    echo -e "${yellow}:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::${reset}"
    echo -e "${yellow}::: H200/Hopper GPU detected - Using compatible version     :::${reset}"
    echo -e "${yellow}::: This version fixes blank/static frame issues with GGUF  :::${reset}"
    echo -e "${yellow}::: Use 'attention_mode=sageattn' in WanVideoModelLoader    :::${reset}"
    echo -e "${yellow}:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::${reset}"
fi

echo
if [ -z "$1" ]; then
    echo -e "${green}::::::::::::::: ${yellow}Press any key to exit${reset}"
    read -n 1 -s
    exit
fi
