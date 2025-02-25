#!/bin/bash

# Find all Dockerfiles in the environments directory
find ./environments -name "Dockerfile*" -type f | while read -r dockerfile; do
  echo "Updating $dockerfile"
  
  # Check if the file already has the mkdir commands
  if grep -q "mkdir -p /home/jovyan/.jupyter/lab/user-settings" "$dockerfile"; then
    echo "  Already contains directory creation commands, skipping"
    continue
  fi
  
  # Add mkdir commands after the apt-get line
  sed -i '/apt-get.*clean/a\
\
# Create necessary directories for Jupyter settings\
RUN mkdir -p /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/ \\\
    \&\& mkdir -p /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/' "$dockerfile"
  
  echo "  Updated successfully"
done

# Also update base Dockerfiles
find ./base -name "Dockerfile*" -type f | while read -r dockerfile; do
  echo "Updating $dockerfile"
  
  # Check if the file already has the mkdir commands
  if grep -q "mkdir -p /home/jovyan/.jupyter/lab/user-settings" "$dockerfile"; then
    echo "  Already contains directory creation commands, skipping"
    continue
  fi
  
  # Add mkdir commands after the apt-get line
  sed -i '/apt-get.*clean/a\
\
# Create necessary directories for Jupyter settings\
RUN mkdir -p /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/ \\\
    \&\& mkdir -p /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/' "$dockerfile"
  
  echo "  Updated successfully"
done

echo "All Dockerfiles updated!"
