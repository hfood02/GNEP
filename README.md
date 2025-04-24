<!-- <div align="left">
<img src="./logo/logo-main-arctic.png" width = "25%" />
</div> -->

# `GMLP`

Copyright (2025) Hongfu Huang.
This is the GPUMD potential extension package GMLP (Gradient-based Machine Learning Potentials).
This software is distributed under the GNU General Public License (GPL) version 3.

## Prerequisites

* You need to have a GPU card with compute capability no less than 3.5, a `CUDA` toolkit no older than `CUDA` 9.0 and A compiler that supports `C++17`.
* Works for both Linux (with GCC) and Windows (with MSVC) operating systems. 

## Compile
* Go to the `src` directory and type `make`.
* When the compilation finishes, two executables, `gmlp`, `nep` and `gpumd`, will be generated in the `src` directory. 

## Run
* Go to the directory of an example and type one of the following commands:
  * `path/to/gmlp`
  * `path/to/nep`
  * `path/to/gpumd`

## How to use?
### input file `gmlp.in`
```bash
prediction          0
type                2 Ge Se
cutoff              7 5
n_max               10 8
l_max               4 
basis_size          8 8
neuron              70
#start_pref_e       0.2
#stop_pref_e        10
#start_pref_f       100
#stop_pref_f        10
#start_pref_v       0.1
#stop_pref_v        1
#energy_shift   1
batch               1
epoch               400
```
## GPUMD & NEP Manual
Some similar parameter settings and explanations can be found in the GPUMD manual:
* Latest released version: https://gpumd.org/