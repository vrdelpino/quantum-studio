# The base image for our Docker image it will be Python
# From the Python base we'll include the tools needed (we'll use for this image Python 3.7)
FROM python:3.7-stretch

# Labels
LABEL "maintainer"="Vicente Ruben Del Pino Ruiz (https://www.linkedin.com/in/vrdelpino/)"

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
RUN pip install --upgrade pip
RUN pip install -q -r requirements.txt

# Automatically review all packages installed and upgrade them.
# This is done to enforce Jupyter-Client versions are aligned.
RUN pip-upgrade

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
##                                    Install NBExtensions                                        ##
##                            Enable Dark Mode in Jupyter Notebook                                ##
####################################################################################################
####################################################################################################
RUN jupyter contrib nbextension install --system

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