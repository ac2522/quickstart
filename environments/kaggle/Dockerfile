ARG BASE_IMAGE=pytorch_base:latest
FROM ${BASE_IMAGE}

USER root

# Install system dependencies specific to ML/Kaggle
RUN apt-get update && apt-get install -y \
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
USER $NB_USER

# Install Python dependencies for Kaggle competitions
# This will skip reinstalling packages already in the base
COPY environments/kaggle/requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt
