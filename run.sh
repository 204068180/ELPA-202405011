#!/bin/bash

module purge

module load anaconda3/5.2.0
module load compiler/gcc/9.3.0
module load compiler/dtk/24.04.1

module load mpi/intelmpi/2021.3.0
module load compiler/intel/2021.3.0

BUILD_DIR=$(dirname $(readlink -f "$BASH_SIURCE[0]"))

export MKLROOT=/public/software/compiler/intel-compiler/2021.3.0/mkl
export ROCM_PATH=/public/software/compiler/rocm/dtk-24.04.1

export LD_LIBRARY_PATH=/public/home/lixs3/My_Project/elpa/elpa-release_2024_05_001/my_build/lib:$LD_LIBRARY_PATH

rm -rf $1_log

mkdir $1_log
cd $1_log

hipprof --hip-trace mpirun -n 1 ../$1 | tee $1_log
