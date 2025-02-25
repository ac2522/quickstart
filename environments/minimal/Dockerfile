ARG BASE_IMAGE=base_jupyter:latest
FROM ${BASE_IMAGE}

USER ${NB_UID}

# Just install the minimal requirements - everything else comes from base
COPY environments/minimal/requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# The CMD is inherited from the base image
