#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
IMAGE="jupyter_kaggle_gpu:latest"
PORT=8888
VOLUME_SOURCE="$(pwd)"
VOLUME_TARGET="/home/jovyan/work"

# Help function
function show_help {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Run a GPU-enabled Jupyter container"
    echo ""
    echo "Options:"
    echo "  -i, --image IMAGE    Docker image to use (default: jupyter_kaggle_gpu:latest)"
    echo "  -p, --port PORT      Port to expose Jupyter on (default: 8888)"
    echo "  -v, --volume PATH    Local path to mount (default: current directory)"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "Available GPU images:"
    echo "  - jupyter_kaggle_gpu:latest (ML workloads)"
    echo "  - jupyter_yolo_gpu:latest (Object detection)"
    echo "  - jupyter_sd_gpu:latest (Stable Diffusion)"
    echo ""
    echo "Example:"
    echo "  $0 --image jupyter_yolo_gpu:latest --port 9999 --volume /path/to/my/project"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--image)
            IMAGE="$2"
            shift 2
            ;;
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -v|--volume)
            VOLUME_SOURCE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Check for nvidia-smi
if ! command -v nvidia-smi &> /dev/null; then
    echo -e "${RED}Error: nvidia-smi not found. Is the NVIDIA driver installed?${NC}"
    exit 1
fi

# Check for docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: docker not found. Please install Docker.${NC}"
    exit 1
fi

# Check if the image exists
if ! docker image inspect "$IMAGE" &> /dev/null; then
    echo -e "${RED}Error: Image $IMAGE not found. Build it first using the build script.${NC}"
    exit 1
fi

# Run container with GPU support
echo -e "${YELLOW}Starting container with GPU support...${NC}"
echo -e "${YELLOW}Image: ${IMAGE}${NC}"
echo -e "${YELLOW}Port: ${PORT}${NC}"
echo -e "${YELLOW}Volume: ${VOLUME_SOURCE} -> ${VOLUME_TARGET}${NC}"

docker run --gpus all -it \
    -p "${PORT}:8888" \
    -v "${VOLUME_SOURCE}:${VOLUME_TARGET}" \
    "${IMAGE}"

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to start container.${NC}"
    echo "If you received an error about the --gpus flag, make sure nvidia-docker is installed:"
    echo "https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html"
    exit 1
fi
