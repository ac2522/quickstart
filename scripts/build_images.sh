#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Build base image first
echo -e "${YELLOW}Building base Jupyter image...${NC}"
docker build -t base_jupyter:latest -f base/Dockerfile.jupyter .

# Check if base build was successful
if [ $? -ne 0 ]; then
    echo -e "${RED}Error building base image!${NC}"
    exit 1
fi
echo -e "${GREEN}Base image built successfully!${NC}"

# Build all environment images
ENVIRONMENTS=("chess" "minimal" "scraping" "kaggle" "yolo" "sd")

for env in "${ENVIRONMENTS[@]}"; do
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

echo -e "${GREEN}All environments have been processed!${NC}"
