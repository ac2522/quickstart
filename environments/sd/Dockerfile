ARG BASE_IMAGE=base_jupyter:latest
FROM ${BASE_IMAGE}

USER root

# Install system dependencies for SD
RUN apt-get update && apt-get install -y \
    git \
    python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch back to the default user
USER ${NB_UID}

# Set up the working directory
WORKDIR /home/jovyan/work

# Clone ComfyUI repository
RUN git clone https://github.com/comfyanonymous/ComfyUI

WORKDIR /home/jovyan/work/ComfyUI

# Create and activate virtual environment
RUN python -m venv venv
ENV PATH="/home/jovyan/work/ComfyUI/venv/bin:$PATH"

# Install PyTorch with CUDA support
RUN pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121

# Install requirements
COPY environments/sd/requirements.txt ./
RUN pip install -r requirements.txt

# Clone ComfyUI-Manager
RUN mkdir -p custom_nodes && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager

# Set the entry point to run main.py
CMD ["python", "main.py"]
