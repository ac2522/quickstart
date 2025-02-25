ARG BASE_IMAGE=base_jupyter:latest
FROM ${BASE_IMAGE}

USER root

# Install system dependencies specific to chess
RUN apt-get update && apt-get install -y \
    stockfish \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch back to the default user
USER ${NB_UID}

# Install Python dependencies specific to chess
COPY environments/chess/requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Set up the working directory
WORKDIR /home/jovyan/work

# The CMD is inherited from the base image
