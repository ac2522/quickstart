#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <base_name> <environment_name>"
    echo "Available bases: jupyter, jupyter-pytorch, jupyter-tensorflow"
    echo "Available environments: Check the 'environments' folder in the repository"
    exit 1
fi

BASE_NAME=$1
ENV_NAME=$2
GITHUB_RAW_URL="https://raw.githubusercontent.com/ac2522/quickstart"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR

# Download base Dockerfile
mkdir -p base
curl -o base/Dockerfile.$BASE_NAME $GITHUB_RAW_URL/base/Dockerfile.$BASE_NAME

# Download Jupyter settings files
mkdir -p files
curl -o files/themes.jupyterlab-settings $GITHUB_RAW_URL/files/themes.jupyterlab-settings
curl -o files/tracker.jupyterlab-settings $GITHUB_RAW_URL/files/tracker.jupyterlab-settings

# Build base image
docker build -t $BASE_NAME:latest -f base/Dockerfile.$BASE_NAME .

# Download environment-specific Dockerfile and requirements
mkdir -p environments/$ENV_NAME
curl -o environments/$ENV_NAME/Dockerfile $GITHUB_RAW_URL/environments/$ENV_NAME/Dockerfile
curl -o environments/$ENV_NAME/requirements.txt $GITHUB_RAW_URL/environments/$ENV_NAME/requirements.txt

# Build environment-specific image
docker build -t $BASE_NAME-$ENV_NAME:latest --build-arg BASE_IMAGE=$BASE_NAME:latest -f environments/$ENV_NAME/Dockerfile environments/$ENV_NAME

# Clean up
cd -
rm -rf $TEMP_DIR

echo "Docker image $BASE_NAME-$ENV_NAME:latest has been built successfully!"
