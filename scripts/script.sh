#!/bin/bash

set -e  # Exit immediately if a command exits with non-zero status

# Print usage info
function print_usage() {
    echo "QuickStart Environment Builder"
    echo "-----------------------------"
    echo "Usage: $0 <base_name> <environment_name>"
    echo ""
    echo "Available bases:"
    echo "  - jupyter (minimal Jupyter notebook)"
    echo ""
    echo "Available environments:"
    echo "  - minimal:  Basic Python with numpy and OpenCV"
    echo "  - kaggle:   Full data science stack with ML libraries"
    echo "  - yolo:     Computer vision with YOLO object detection"
    echo "  - chess:    Chess analysis environment"
    echo "  - scraping: Web scraping tools"
    echo "  - sd:       Stable Diffusion with ComfyUI"
    echo ""
    echo "Example: $0 jupyter minimal"
}

# Check if correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    print_usage
    exit 1
fi

BASE_NAME=$1
ENV_NAME=$2
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🚀 Building environment: $BASE_NAME-$ENV_NAME"
echo "Repository root: $REPO_ROOT"

# Check if the environment exists
if [ ! -d "$REPO_ROOT/environments/$ENV_NAME" ]; then
    echo "❌ Error: Environment '$ENV_NAME' not found in environments directory"
    echo "Available environments:"
    ls -1 "$REPO_ROOT/environments"
    exit 1
fi

# Check if the base exists
if [ ! -f "$REPO_ROOT/base/Dockerfile.$BASE_NAME" ]; then
    echo "❌ Error: Base '$BASE_NAME' not found"
    echo "Available bases:"
    ls -1 "$REPO_ROOT/base" | grep Dockerfile | sed 's/Dockerfile.//'
    exit 1
fi

# Create build directory
BUILD_DIR=$(mktemp -d)
echo "📁 Creating temporary build directory: $BUILD_DIR"

# Create necessary directory structure
mkdir -p "$BUILD_DIR/base"
mkdir -p "$BUILD_DIR/environments/$ENV_NAME"
mkdir -p "$BUILD_DIR/files"

# Copy base Dockerfile
cp "$REPO_ROOT/base/Dockerfile.$BASE_NAME" "$BUILD_DIR/base/"

# Copy settings files
cp "$REPO_ROOT/files/"* "$BUILD_DIR/files/"

# Build base image
echo "🏗️ Building base image: $BASE_NAME:latest"
docker build -t "$BASE_NAME:latest" -f "$BUILD_DIR/base/Dockerfile.$BASE_NAME" "$BUILD_DIR"

# Copy environment-specific files
cp "$REPO_ROOT/environments/$ENV_NAME/Dockerfile" "$BUILD_DIR/environments/$ENV_NAME/"
cp "$REPO_ROOT/environments/$ENV_NAME/requirements.txt" "$BUILD_DIR/environments/$ENV_NAME/"

# Copy files directory to environment directory for Dockerfile access
cp -r "$BUILD_DIR/files" "$BUILD_DIR/environments/$ENV_NAME/"

# Build environment-specific image
echo "🏗️ Building environment image: $BASE_NAME-$ENV_NAME:latest"
docker build -t "$BASE_NAME-$ENV_NAME:latest" --build-arg BASE_IMAGE="$BASE_NAME:latest" -f "$BUILD_DIR/environments/$ENV_NAME/Dockerfile" "$BUILD_DIR/environments/$ENV_NAME"

# Clean up
echo "🧹 Cleaning up temporary files"
rm -rf "$BUILD_DIR"

echo "✅ Docker image $BASE_NAME-$ENV_NAME:latest has been built successfully!"
echo ""
echo "To run the environment:"
echo "docker run -p 8888:8888 -v \$(pwd)/notebooks:/home/jovyan/work $BASE_NAME-$ENV_NAME:latest"
echo ""
echo "For GPU support (if available):"
echo "docker run --gpus all -p 8888:8888 -v \$(pwd)/notebooks:/home/jovyan/work $BASE_NAME-$ENV_NAME:latest"
