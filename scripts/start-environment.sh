#!/usr/bin/env bash

##############################################################################################################
##############################################################################################################
##                                        Start Jupyter Notebook                                            ##
##############################################################################################################
##############################################################################################################
# Initialize Jupyter Notebook
echo "###########################################################"
echo "                  Starting Jupyter Notebook                "
echo "############################################################"
echo "Starting Jupyter Notebook"
# Copy the configuration with the password preset
mv /jupyter_notebook_config.json /root/.jupyter/jupyter_notebook_config.json

# Start the services
jupyter notebook --ip=0.0.0.0 --port=8080 --allow-root --no-browser --notebook-dir=/root/quantum_studio/data/