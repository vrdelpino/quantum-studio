#!/usr/bin/env bash

##############################################################################################################
##############################################################################################################
##                                   Configure Conda Environment                                            ##
##############################################################################################################
##############################################################################################################
echo "###########################################################"
echo "               Activating Conda Environment                "
echo "###########################################################"
echo "Activating Conda Environment"

# Activating Quantum Environment
source activate qsharp-env
python -c "import qsharp"

# DeActivating Quantum Environment
source deactivate qsharp-env

##############################################################################################################
##############################################################################################################
##                                        Start Jupyter Notebook                                            ##
##############################################################################################################
##############################################################################################################

echo "###########################################################"
echo "               Configuring Jupyter Notebook                "
echo "###########################################################"
echo "Configuring Jupyter Notebook"

# Copy the configuration with the password preset
mv /jupyter_notebook_config.json /root/.jupyter/jupyter_notebook_config.json


echo "###########################################################"
echo "                  Starting Jupyter Notebook                "
echo "############################################################"
echo "Starting Jupyter Notebook"

# Start the services
jupyter notebook --ip=0.0.0.0 --port=8080 --allow-root --no-browser --notebook-dir=/root/quantum_studio/data/