<div align="left">
<img src="./logo/logo-main-arctic.png" width = "25%" />
</div>

# `GPUMD`

Copyright (2017) Zheyong Fan.
This is the GPUMD software package.
This software is distributed under the GNU General Public License (GPL) version 3.

## Prerequisites

* You need to have a GPU card with compute capability no less than 3.5 and a `CUDA` toolkit no older than `CUDA` 9.0.
* Works for both Linux (with GCC) and Windows (with MSVC) operating systems. 

## Compile GPUMD
* Go to the `src` directory and type `make`.
* When the compilation finishes, two executables, `gpumd` and `nep`, will be generated in the `src` directory. 

## Run GPUMD
* Go to the directory of an example and type one of the following commands:
  * `path/to/gpumd`
  * `path/to/nep`

## Colab tutorial
* We provide a [Colab Tutorial](https://colab.research.google.com/drive/1QnXAveZgzwut4Mvldsw-r2I0EWIsj1KA?usp=sharing) to show the workflow of the construction of a NEP model and its application in large-scale atomistic simulations for PbTe system. This will run entirely on Google's cloud virtual machine.
* You can also check other offline tutorials in the examples.

## Manual
* Latest released version: https://gpumd.org/
* Development version: https://gpumd.org/dev/

## Python packages related to GPUMD and/or NEP:

| Package               | link                           | comment |
| --------------------- | --------------------------------- | ---------------------------------- |
| `calorine`            | https://gitlab.com/materials-modeling/calorine  | `calorine` is a Python package for running and analyzing molecular dynamics (MD) simulations via GPUMD. It also provides functionality for constructing and sampling neuroevolution potential (NEP) models via GPUMD. |
| `GPUMD-Wizard`        | https://github.com/Jonsnow-willow/GPUMD-Wizard  | `GPUMD-Wizard` is a material structure processing software based on ASE (Atomic Simulation Environment) providing automation capabilities for calculating various properties of metals. Additionally, it aims to run and analyze molecular dynamics (MD) simulations using GPUMD.  |
| `gpyumd`              |https://github.com/AlexGabourie/gpyumd   | `gpyumd` is a Python3 interface for GPUMD. It helps users generate input and process output files based on the details provided by the GPUMD documentation. It currently supports up to GPUMD-v3.3.1 and only the gpumd executable. |
| `mdapy`               | https://github.com/mushroomfire/mdapy | The `mdapy` python library provides an array of powerful, flexible, and straightforward tools to analyze atomic trajectories generated from Molecular Dynamics (MD) simulations. |
| `pynep`               | https://github.com/bigd4/PyNEP   | `PyNEP` is a python interface of the machine learning potential NEP used in GPUMD. |
| `somd`                | https://github.com/initqp/somd  | `SOMD` is an ab-initio molecular dynamics (AIMD) package designed for the SIESTA DFT code. The SOMD code provides some common functionalities to perform standard Born-Oppenheimer molecular dynamics (BOMD) simulations, and contains a simple wrapper to the Neuroevolution Potential (NEP) package. The SOMD code may be used to automatically build NEPs by the mean of the active-learning methodology. |

