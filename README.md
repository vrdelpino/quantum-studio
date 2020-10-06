# Quantum Studio

Docker image with Jupyter Notebook and Quantum environments for development purposes.

Docker image available as well on Docker Hub on: rubendelpino/quantum-studio

# Table of Contents

###  1. [Introduction](#T1)
###  2. [Shared Folders](#T2)
###  3. [How to build the environment](#T3) 
###  4. [How to start the environment](#T4)
###  5. [Kernels included](#T5)
###  6. [Examples included in the environment](#T6)



## <a name="T1"></a> 1. Introduction
This image is based on Python 3.7.2 on Debian Linux (Conda Distribution).

Packages installed are:
* qiskit
* qsharp
* cirq
* tensorflow
* tensorflow-quantum

Jupyter Notebook includes themes available for dark mode and NBExtensions installed.

All the packages are available through a Jupyter Notebook in http://localhost:8080

Password is: 'quantum-studio-user'

## <a name="T2"></a>  2. Shared Folders

Jupyter Notebook root folder is mapped to the data folder provided within the same location of the image.

All notebooks created within the image will be available in the examples folder. All examples shipped with the image will 
be provided within this folder.
 
## <a name="T3"></a>  3. How to build the environment

Docker is a requirement to build and run the image.

To install Docker, follow instructions at: https://www.docker.com/ 

Once Docker is available in the computer, run the following script:

```
    ./build-docker.sh
```


## <a name="T4"></a> 4. How to start the environment. 

To start up the image, run the following script:

```
    ./start-docker.sh
```

To stop the image, run the following script:

```
   ./stop-docker-all.sh
```

**Important!** stop-docker-all.sh will stop, and destroy all docker images running in your laptop.
Use it only **WHEN** you are running **ONLY** this image and want to clean the full environment.

## <a name="T5"></a> 5. Kernels included

The environment includes 3 environments, two Python and one for Q#:

![Kernels](snapshots/Kernels.png)


### 4.1. Python 3

Within Python3, there are two options: 
* Python [conda env: root]. Main kernel, here are all the quantum packages needed to run the Quantum experiments in Python.
* Python [conda env: qsharp-env]. This kernel has the ability of running Q# code within Python.


### 4.2. Q#

For Q#, only kernel included is:
* Q# [conda env:qsharp-env]. Here will execute Q# code in Jupyter Notebook.


## <a name="T6"></a> 6. Examples included in the environment

### 5.1. Q# - Random Number Generator

A Jupyter notebook and a Q# file to perform a random number generator:
* Operation.qs: File with the Q# code to run random number generation.

![Q# Code](snapshots/Q Code.png)


* IQ#-Test.ipynb: Python Jupyter Notebook to execute Q#. 

![Q# Notebook](snapshots/Q Notebook.png)


### 5.2. Qiskit - Bell TEst

A Jupyter notebook to run Bell test using Qiskit.
* Qiskit-Test.ipynb

![Qiskit Notebook](snapshots/Qiskit Code 1.png)
![Qiskit Notebook](snapshots/Qiskit Code 2.png)
![Qiskit Notebook](snapshots/Qiskit Code 3.png)


