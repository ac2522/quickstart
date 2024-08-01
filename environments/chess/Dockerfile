ARG BASE_IMAGE=jupyter/minimal-notebook:latest
FROM ${BASE_IMAGE}

USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libgl1-mesa-glx \
    libglib2.0-0 \
    stockfish \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch back to the default user
USER ${NB_UID}

# Install Python dependencies
COPY requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Set up the working directory
WORKDIR /home/jovyan/work

# Copy your chess application files
COPY . /home/jovyan/work/

# Ensure the correct permissions
USER root
RUN chown -R ${NB_UID} /home/jovyan/work
USER ${NB_UID}

# The CMD will be inherited from the base image
