# The base image for our Docker image it will be Python
# From the Python base we'll include the tools needed (we'll use for this image Python 3.7)
FROM continuumio/conda-ci-linux-64-python3.9

# Labels
LABEL "maintainer"="Vicente Ruben Del Pino Ruiz (https://www.linkedin.com/in/vrdelpino/)"

# Get privileges to install all packages needed
USER root

####################################################################################################
####################################################################################################
##                           Copy Scripts to initialize system                                    ##
####################################################################################################
####################################################################################################
# Create directories for notebooks
RUN mkdir -p /code/quantum_studio/data

# Copy the start-services script
COPY scripts/start-environment.sh /start-environment.sh
COPY requirements/conda-requirements.txt /conda-requirements.txt
COPY requirements/pip-requirements.txt /pip-requirements.txt
COPY configuration/jupyter_notebook_config.json /jupyter_notebook_config.json

# Modify access to the files for the rest of the process
RUN chmod 777 /start-environment.sh && \
    chmod 777 /pip-requirements.txt && \
    chmod 777 /conda-requirements.txt && \
    chmod 777 /jupyter_notebook_config.json


####################################################################################################
####################################################################################################
##                                INSTALL Python Dependencies                                     ##
####################################################################################################
####################################################################################################
# Get all the libraries needed for Python from our requirements file.
# Conda Packages + # PIP Packages

RUN conda update conda && \
    conda config --add channels conda-forge && \
    conda install --file conda-requirements.txt && \
    conda install pip && \
    conda clean -a && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -q -r pip-requirements.txt && \
    ipcluster nbextension enable


####################################################################################################
####################################################################################################
##                                    Install NBExtensions                                        ##
##                            Enable Dark Mode in Jupyter Notebook                                ##
####################################################################################################
####################################################################################################
# Extensions for our Jupyter Notebook
RUN jupyter contrib nbextension install --system

# Improving Jupyter Notebook with dark theme for easier visualization
RUN jt -t monokai -f fira -fs 10 -nf ptsans -nfs 11 -N -kl -cursw 2 -cursc r -cellw 95% -T

#################################################################################################
#################################################################################################
##                    Copy the configuration with the password preset                          ##
#################################################################################################
#################################################################################################
RUN mv /jupyter_notebook_config.json /root/.jupyter/jupyter_notebook_config.json


#################################################################################################
#################################################################################################
##                               EXPOSE Jupyter Notebook Port                                  ##
#################################################################################################
#################################################################################################
# Expose the Jupyter Notebook port
EXPOSE 8080

##############################################################################################################
##############################################################################################################
##                                         START THE SYSTEM                                                 ##
##############################################################################################################
##############################################################################################################
# Execute the commands needed
CMD ["/start-environment.sh"]