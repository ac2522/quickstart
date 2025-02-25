# Docker Jupyter Environments

This repository contains a collection of Docker environments for various data science, machine learning, and AI tasks. The environments are designed with a layered approach to minimize duplication and provide efficient, specialized workspaces.

## Architecture

The repository uses a three-tier architecture:

1. **Base Jupyter Image**: A foundation layer with common tools and settings
2. **PyTorch Base Image**: An accelerated layer that adds GPU support via PyTorch
3. **Environment-Specific Images**: Specialized tools for specific tasks

## Available Environments

### CPU-Based Environments (based on base_jupyter)
- **minimal**: Lightweight environment with basic packages
- **chess**: Environment for chess analysis with engines and AI integration
- **scraping**: Web scraping tools including Chrome, Selenium, and BeautifulSoup

### GPU-Accelerated Environments (based on pytorch_base)
- **kaggle_gpu**: Complete environment for Kaggle competitions with ML libraries
- **yolo_gpu**: Object detection with YOLO and related computer vision tools
- **sd_gpu**: Stable Diffusion with ComfyUI for image generation

## Quick Start

### Building the Images

Use the build script to create all images:

```bash
chmod +x build_images.sh
./build_images.sh
```

Or build individual images:

```bash
# Build base image
docker build -t base_jupyter:latest -f base/Dockerfile.jupyter .

# Build PyTorch base image
docker build -t pytorch_base:latest -f base/Dockerfile.pytorch .

# Build an environment (example: Kaggle with GPU)
docker build --build-arg BASE_IMAGE=pytorch_base:latest -t jupyter_kaggle_gpu:latest -f environments/kaggle/Dockerfile.gpu .
```

### Running Containers

#### Running CPU-based containers:

```bash
docker run -it -p 8888:8888 -v $(pwd):/home/jovyan/work jupyter_minimal:latest
```

#### Running GPU-accelerated containers:

Use the provided script:

```bash
chmod +x run_gpu_container.sh
./run_gpu_container.sh --image jupyter_kaggle_gpu:latest --port 9999 --volume /path/to/project
```

Or run directly with Docker:

```bash
docker run --gpus all -it -p 8888:8888 -v $(pwd):/home/jovyan/work jupyter_kaggle_gpu:latest
```

## Customization

### Adding New Environments

1. Create a directory under `environments/`
2. Add a `Dockerfile` (CPU-based) or `Dockerfile.gpu` (GPU-based)
3. Add a `requirements.txt` for Python packages
4. Update the build script to include your new environment

### Customizing Existing Environments

Modify the corresponding Dockerfile and requirements.txt in the environment's directory.

## Troubleshooting

- **Permission Issues**: If you encounter permission issues on Linux, ensure your user is in the docker group:
  ```bash
  sudo usermod -aG docker $USER
  newgrp docker  # Apply changes without logout
  ```

- **File Not Found Errors**: Make sure all paths in the script match your actual file structure.

- **Cannot Connect to Docker Daemon**: Ensure Docker is running:
  ```bash
  # Linux
  sudo systemctl start docker
  
  # Windows
  # Start Docker Desktop from the Start menu
  ```

- **GPU Not Available**: Verify your NVIDIA drivers and CUDA installation:
  ```bash
  # Check NVIDIA drivers
  nvidia-smi
  
  # Check CUDA
  nvcc --version
  ```

- **NVIDIA Docker Issues**: If having problems with `--gpus all` flag, make sure nvidia-docker is installed:
  ```bash
  # Ubuntu/Debian
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
  sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
  sudo systemctl restart docker
  ```

## Directory Structure

```
.
├── base/
│   ├── Dockerfile.jupyter    # Base Jupyter image
│   └── Dockerfile.pytorch    # PyTorch base with GPU support
├── environments/
│   ├── chess/
│   ├── kaggle/
│   ├── minimal/
│   ├── scraping/
│   ├── sd/
│   └── yolo/
├── files/
│   ├── themes.jupyterlab-settings
│   └── tracker.jupyterlab-settings
├── scripts/
│   ├── build_images.sh
│   └── run_gpu_container.sh
└── README.md
```

## Settings

The base images are configured with:
- JupyterLab dark theme
- Line numbers in code cells
- Common data science packages pre-installed
- Data directory at `/home/jovyan/data`
- Work directory at `/home/jovyan/work`

## License

This project is open source and available under the MIT License.
