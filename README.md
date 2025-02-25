# QuickStart

A streamlined solution for quickly setting up familiar Python environments on new machines using Docker. This repository provides pre-configured Jupyter notebook environments for various use cases like data science, machine learning, computer vision, and web scraping.

## Contents

- [Prerequisites](#prerequisites)
  - [Windows](#windows-prerequisites)
  - [Linux](#linux-prerequisites)
- [Installation](#installation)
  - [Windows](#windows-installation)
  - [Linux](#linux-installation)
- [Available Environments](#available-environments)
- [Usage](#usage)
  - [Basic Usage](#basic-usage)
  - [GPU Support](#gpu-support)
  - [Using Your Custom Environment](#using-your-custom-environment)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Windows Prerequisites

1. **Install Docker Desktop**
   - Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Follow the installation wizard instructions
   - Start Docker Desktop after installation

2. **Install Git**
   - Download and install [Git for Windows](https://git-scm.com/download/win)
   - Follow the installation wizard (default settings are usually fine)

3. **For GPU Support (Optional)**
   - Install [NVIDIA Driver](https://www.nvidia.com/download/index.aspx) appropriate for your GPU
   - Install [NVIDIA CUDA Toolkit](https://developer.nvidia.com/cuda-downloads)
   - Install [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)

### Linux Prerequisites

1. **Install Docker**
   ```bash
   # Update package index
   sudo apt-get update
   
   # Install prerequisites
   sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

   # Add Docker's official GPG key
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   
   # Add Docker repository
   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
   
   # Install Docker
   sudo apt-get update
   sudo apt-get install -y docker-ce
   
   # Add your user to the docker group to run Docker without sudo
   sudo usermod -aG docker $USER
   
   # Apply the group changes (or logout and login again)
   newgrp docker
   ```

2. **Install Git**
   ```bash
   sudo apt-get install -y git
   ```

3. **For GPU Support (Optional)**
   ```bash
   # Install NVIDIA driver
   sudo apt-get install -y nvidia-driver-XXX  # Replace XXX with version compatible with your GPU
   
   # Install NVIDIA CUDA Toolkit
   sudo apt-get install -y nvidia-cuda-toolkit
   
   # Install NVIDIA Container Toolkit
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
   curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
   curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
   sudo apt-get update
   sudo apt-get install -y nvidia-container-toolkit
   sudo systemctl restart docker
   ```

## Installation

### Windows Installation

1. **Clone the repository**
   ```
   git clone https://github.com/ac2522/quickstart.git
   cd quickstart
   ```

2. **Set up environment (PowerShell)**
   ```powershell
   # Optional: If you need to run scripts in PowerShell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   
   # Make sure scripts are executable
   git update-index --chmod=+x scripts/script.sh
   ```

3. **Build and run using WSL or Git Bash**
   ```bash
   bash scripts/script.sh jupyter minimal
   ```

### Linux Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ac2522/quickstart.git
   cd quickstart
   ```

2. **Make the script executable**
   ```bash
   chmod +x scripts/script.sh
   ```

3. **Build your environment**
   ```bash
   ./scripts/script.sh jupyter minimal
   ```

## Available Environments

- **minimal**: Basic Python environment with numpy and OpenCV
- **kaggle**: Full data science stack (pandas, scikit-learn, TensorFlow, PyTorch, etc.)
- **yolo**: Computer vision environment with YOLO object detection
- **chess**: Environment for chess analysis with Python chess libraries and LLM APIs
- **scraping**: Web scraping tools including Selenium and BeautifulSoup
- **sd**: Stable Diffusion environment with ComfyUI

## Usage

### Basic Usage

After building your environment, run it using:

```bash
# Format: docker run -p [host-port]:[container-port] -v [host-directory]:[container-directory] [image-name]
docker run -p 8888:8888 -v $(pwd)/notebooks:/home/jovyan/work jupyter-minimal:latest
```

Windows users using PowerShell should use this format:

```powershell
docker run -p 8888:8888 -v ${PWD}/notebooks:/home/jovyan/work jupyter-minimal:latest
```

Then open your browser and navigate to: http://localhost:8888
(Check the docker logs for the token or URL with token)

### GPU Support

To use GPU in your container (after installing NVIDIA CUDA requirements):

```bash
docker run --gpus all -p 8888:8888 -v $(pwd)/notebooks:/home/jovyan/work jupyter-minimal:latest
```

### Using Your Custom Environment

1. Create a new directory in the `environments/` folder with your custom name
2. Add a `Dockerfile` and `requirements.txt` in this directory
3. Build using the script:
   ```bash
   ./scripts/script.sh jupyter your-custom-env
   ```

## Troubleshooting

- **Permission Issues**: If you encounter permission issues on Linux, ensure your user is in the docker group:
  ```bash
  sudo usermod -aG docker $USER
  newgrp docker  # Apply changes without logout
  ```

- **File Not Found Errors**: Make sure all paths in the script match your actual file structure

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
