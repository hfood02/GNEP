<div align="left">
<img src="./logo/logo-main-arctic.png" width = "25%" />
</div>

# `GNEP`

Copyright (2025) Hongfu Huang.
This is the GPUMD potential extension package GNEP (Gradient-optimized Neuroevolution Potential).
This software is distributed under the GNU General Public License (GPL) version 3.

## Prerequisites

* You need to have a GPU card with compute capability no less than 3.5, a `CUDA` toolkit no older than `CUDA` 9.0 and A compiler that supports `C++14`.
* Works for both Linux (with GCC) and Windows (with MSVC) operating systems. 

## Compile
* Go to the `src` directory and type `make`.
* When the compilation finishes, two executables, `gnep`, `nep` and `gpumd`, will be generated in the `src` directory. 

## Run
* Go to the directory of an example and type one of the following commands:
  * `path/to/gnep`
* Only 1 GPU is supported for now.

## How to use?
### input file `gnep.in`
```bash
prediction          0
type                2 Ge Se
cutoff              7 5
n_max               10 8
l_max               4 
basis_size          8 8
neuron              70
#energy_shift       1
#lambda_e           1.0          
#lambda_f           2.0        
#lambda_v           0.1
#weight_decay       0.0001
#start_lr           0.001
#stop_lr            0.0000001
batch               1
epoch               400
```
## GPUMD & NEP Manual
Some similar parameter settings and explanations can be found in the GPUMD manual:
* Latest released version: https://gpumd.org/

## References

[1] Hongfu Huang, Junhao Peng, Kaiqi Li, Jian Zhou, Zhimei Sun, [Efficient GPU-Accelerated Training of a Neuroevolution Potential with Analytical Gradients](http://arxiv.org/abs/2507.00528),
arXiv:2507.00528 [cond-mat.dis-nn; cond-mat.mtrl-sci; physics.comp-ph].