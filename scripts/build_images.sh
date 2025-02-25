#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=============================${NC}"
echo -e "${BLUE}   Docker Build Script       ${NC}"
echo -e "${BLUE}=============================${NC}"

# Build base images first
echo -e "${YELLOW}Building base Jupyter image...${NC}"
docker build -t base_jupyter:latest -f base/Dockerfile.jupyter .

if [ $? -ne 0 ]; then
    echo -e "${RED}Error building base Jupyter image!${NC}"
    exit 1
fi
echo -e "${GREEN}Base Jupyter image built successfully!${NC}"

echo -e "${YELLOW}Building PyTorch base image with GPU support...${NC}"
docker build -t pytorch_base:latest -f base/Dockerfile.pytorch .

if [ $? -ne 0 ]; then
    echo -e "${RED}Error building PyTorch base image!${NC}"
    exit 1
fi
echo -e "${GREEN}PyTorch base image built successfully!${NC}"

# Build CPU-based environments
echo -e "${BLUE}Building CPU-based environments...${NC}"
CPU_ENVIRONMENTS=("chess" "minimal" "scraping")

for env in "${CPU_ENVIRONMENTS[@]}"; do
    echo -e "${YELLOW}Building ${env} environment...${NC}"
    docker build \
        --build-arg BASE_IMAGE=base_jupyter:latest \
        -t jupyter_${env}:latest \
        -f environments/${env}/Dockerfile .
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error building ${env} environment!${NC}"
    else
        echo -e "${GREEN}${env} environment built successfully!${NC}"
    fi
done

# Build GPU-based environments
echo -e "${BLUE}Building GPU-based environments...${NC}"
GPU_ENVIRONMENTS=("yolo" "sd" "kaggle")

for env in "${GPU_ENVIRONMENTS[@]}"; do
    echo -e "${YELLOW}Building ${env}-gpu environment...${NC}"
    docker build \
        --build-arg BASE_IMAGE=pytorch_base:latest \
        -t jupyter_${env}_gpu:latest \
        -f environments/${env}/Dockerfile.gpu .
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error building ${env}-gpu environment!${NC}"
    else
        echo -e "${GREEN}${env}-gpu environment built successfully!${NC}"
    fi
done

echo -e "${BLUE}=============================${NC}"
echo -e "${GREEN}All environments have been processed!${NC}"
echo -e "${BLUE}=============================${NC}"

# Print a run command example with GPU support
echo -e "${YELLOW}Example to run a GPU container:${NC}"
echo -e "docker run --gpus all -it -p 8888:8888 -v \$(pwd):/home/jovyan/work jupyter_kaggle_gpu:latest"
