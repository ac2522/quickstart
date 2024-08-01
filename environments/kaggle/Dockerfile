ARG BASE_IMAGE=jupyter/minimal-notebook:latest
FROM ${BASE_IMAGE}

USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg-dev \
    libpng-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch back to the default user
USER ${NB_UID}

# Install Python dependencies
COPY requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Set up the working directory
WORKDIR /home/jovyan/work

# Copy any additional files (if needed)
# COPY . /home/jovyan/work/

# Ensure the correct permissions
USER root
RUN chown -R ${NB_UID} /home/jovyan/work
USER ${NB_UID}

# The CMD will be inherited from the base image
