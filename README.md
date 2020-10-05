# Quantum Studio

Docker image with Jupyter Notebook and Quantum environments for development purposes.

## Contents
This image is based on Python 3.7.2 on Debian Linux.

Packages installed are:
* qiskit
* qsharp
* cirq
* tensorflow
* tensorflow-quantum

Jupyter Notebook includes themes available for dark mode and NBExtensions installed.

All the packages are available through a Jupyter Notebook in http://localhost:8080

Password is: 'quantum-studio-user'

## Shared Folders

Jupyter Notebook root folder is in the data folder provided within the same location than the image.

All notebooks created within the image will be available in the data folder.
 
## How to build the environment

Docker is a requirement to build and run the image.
To install Docker, follow instructions at: https://www.docker.com/ 

Once Docker is available in the computer, run the following script:

```
    ./build-docker.sh
```


## How to run it. 

To start up the image, run the following script:

```
    ./start-docker.sh
```
