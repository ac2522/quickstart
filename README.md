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

- **"No such file or directory" when copying settings files**: If you encounter this error, it's because the destination directories don't exist in the container. The Dockerfiles in this repository have been updated to create these directories automatically, but if you're using a custom Dockerfile, make sure to include the following commands:
  ```dockerfile
  # Create necessary directories for Jupyter settings
  RUN mkdir -p /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/ \
      && mkdir -p /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/
  ```
