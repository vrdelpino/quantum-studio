# The base image for our Docker image it will be Python
# From the Python base we'll include the tools needed (we'll use for this image Python 3.7)
FROM continuumio/conda-ci-linux-64-python3.7

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
RUN mkdir -p quantum_studio/examples

# Copy the start-services script
COPY scripts/start-environment.sh /start-environment.sh
COPY requirements/conda-requirements.txt /conda-requirements.txt
COPY requirements/pip-requirements.txt /pip-requirements.txt
COPY configuration/jupyter_notebook_config.json /jupyter_notebook_config.json

# Modify access to the files for the rest of the process
RUN chmod 777 /start-environment.sh
RUN chmod 777 /pip-requirements.txt
RUN chmod 777 /conda-requirements.txt
RUN chmod 777 /jupyter_notebook_config.json

####################################################################################################
####################################################################################################
##                                     INSTALL .NET SDK 3.1                                       ##
####################################################################################################
####################################################################################################

# APT-Transport-HTTPS is necessary before installing packages-microsoft-prod.deb
RUN apt-get update && \
  apt-get install -y apt-transport-https

# Download packages needed
RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

# .NET will be necessary to run IQ#
RUN apt-get update && \
  apt-get install -y dotnet-sdk-3.1

####################################################################################################
####################################################################################################
##                                INSTALL Python Dependencies                                     ##
####################################################################################################
####################################################################################################
# Get all the libraries needed for Python from our requirements file.
# Conda Packages
RUN conda update conda
RUN conda config --add channels conda-forge
RUN conda install --file conda-requirements.txt

# PIP Packages
RUN conda install pip
RUN pip install --upgrade pip
RUN pip install -r pip-requirements.txt
RUN ipcluster nbextension enable

####################################################################################################
####################################################################################################
##                                INSTALL .NET IQSharp Engine                                     ##
####################################################################################################
####################################################################################################
# Install all the dotnet utilities needed for IQSharp Engine (for Jupyter Notebook)

RUN dotnet tool install -g Microsoft.Quantum.IQSharp
RUN export PATH="/home/root/.dotnet/tools:$PATH"
RUN ~/.dotnet/tools/dotnet-iqsharp install --path-to-tool="$(which dotnet-iqsharp)"

####################################################################################################
####################################################################################################
##                                 CONDA Environment for Q#                                       ##
####################################################################################################
####################################################################################################
# Make conda environments available in bash
RUN conda init bash
# Create qsharp-env needed for running Q# experiments
RUN conda create -n qsharp-env -c quantum-engineering qsharp notebook

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