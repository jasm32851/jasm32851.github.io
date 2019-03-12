---
layout: post
title:  "Setting up Miniconda with MPI and OpenMP on a Mac"
date:   2019-3-12
categories: jekyll update
---

Mac `clang` doesn't ship with support of `OpenMP` or `MPI` and these are vital for many HPC programs.
Although researchers may not be running full sized HPC jobs on a Mac OSX machine, many use them to compile, test, and debug these programs.
This guide is meant to be a simple tutorial to help set up a Mac OSX machine with most of the packages/compilers you will need to develop HPC programs.  

# Conda Setup
Download the [Miniconda bash script](https://conda.io/en/latest/miniconda.html) and run to install conda base.


```bash
bash Miniconda3-latest-MacOSX-x86_64.sh
```

Set up conda env so we can safely play with packages.

```bash
conda env create -f omp_mpi.yml
```

Where the environment file `omp_mpi.yml` is:

```yml
# omp_mpi.yml
name: omp_mpi

channels:
  - conda-forge

dependencies:
  # Python Basics
  - pip
  - setuptools
  # C/C++ Compilers and Related Packages
  - clang_osx-64
  - clangxx_osx-64
  - mpich
  - cmake
  - mpi4py
  - blas
  - mkl
  - lapack
  - boost
  - xeus-cling
  - xtensor
  # Common Python Modules
  - scipy
  - matplotlib
  - seaborn
  - pytest-cov
  - networkx
  - sympy
  - h5py
```

Right now our machine doesn't have `OpenMP`!
I strongly recommend building that 'by hand' so `libomp.dylib` is build with the conda mpi compiler.

# Building `libomp.dylib`
There are a lot of guides on how to build `libomp` from source, you can find the one I used [here]( https://www.uio.no/studier/emner/matnat/ifi/IN3200/v19/teaching-material/in3200_setup.pdf).

```bash
mkdir -p ~/dev
cd ~/dev
# check out the code with Subversion
svn co http://llvm.org/svn/llvm-project/openmp/trunk openmp
cd ~/dev/openmp
mkdir build
cd build
# configure build
cmake ~/dev/openmp
# build
make -j 2
# install the library to /usr/local
make install
# optionally we can clean up afterwards
cd ~/dev
rm -rf ~/dev/openmp
```

Test it out on some sample omp programs to make sure it works!
