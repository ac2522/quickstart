FROM jupyter/scipy-notebook:latest

WORKDIR /usr/src/app

USER root

RUN apt-get update; apt install -y libgl1 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy settings files
COPY themes.jupyterlab-settings /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/
COPY tracker.jupyterlab-settings /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/

# Change ownership of the copied files to jovyan
RUN chown -R $NB_UID /home/jovyan/.jupyter
RUN chmod -R 777 /home/jovyan/.jupyter


# Switch back to the Jupyter user
USER $NB_UID

# Install Python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --upgrade nbconvert

EXPOSE 8888

CMD ["jupyter", "notebook", "--ip='0.0.0.0'", "--port=8888", "--no-browser", "--allow-root"]

