# The base image for our Docker image it will be Python
# From the Python base we'll include the tools needed (we'll use for this image Python 3.7)
FROM continuumio/conda-ci-linux-64-python3.7

# Labels
LABEL "maintainer"="Vicente Ruben Del Pino Ruiz (https://www.linkedin.com/in/vrdelpino/)"

USER root

####################################################################################################
####################################################################################################
##                           Copy Scripts to initialize system                                    ##
####################################################################################################
####################################################################################################
# Create directories for notebooks
RUN mkdir -p quantum_studio/data

# Copy the start-services script
COPY scripts/start-environment.sh /start-environment.sh
COPY requirements/requirements.txt /requirements.txt
COPY configuration/jupyter_notebook_config.json /jupyter_notebook_config.json

RUN chmod 777 /start-environment.sh
RUN chmod 777 /requirements.txt
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
RUN conda update conda
RUN conda config --add channels conda-forge
RUN conda install --file requirements.txt
RUN conda install pip

RUN pip install --upgrade pip
RUN pip install qiskit
RUN pip install qiskit[visualization]
RUN pip install qsharp
RUN pip install cirq
RUN pip install jupyterthemes
RUN pip install jupyter_contrib_nbextensions
RUN pip install qrng
RUN pip install ipyparallel
RUN ipcluster nbextension enable

####################################################################################################
####################################################################################################
##                                INSTALL .NET IQSharp Engine                                     ##
####################################################################################################
####################################################################################################

RUN dotnet tool install -g Microsoft.Quantum.IQSharp
RUN export PATH="/home/root/.dotnet/tools:$PATH"
RUN ~/.dotnet/tools/dotnet-iqsharp install --path-to-tool="$(which dotnet-iqsharp)"

####################################################################################################
####################################################################################################
##                                 CONDA Environment for Q#                                       ##
####################################################################################################
####################################################################################################

RUN conda init bash
RUN conda create -n qsharp-env -c quantum-engineering qsharp notebook

####################################################################################################
####################################################################################################
##                                    Install NBExtensions                                        ##
##                            Enable Dark Mode in Jupyter Notebook                                ##
####################################################################################################
####################################################################################################
RUN jupyter contrib nbextension install --system
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