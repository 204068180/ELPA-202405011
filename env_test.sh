#!/bin/bash

module purge

module load anaconda3/5.2.0
module load compiler/gcc/9.3.0
module load compiler/dtk/24.04.1
module load mpi/intelmpi/2021.3.0
module load compiler/intel/2021.3.0


export MKLROOT=/public/software/compiler/intel-compiler/2021.3.0/mkl
export ROCM_PATH=/public/software/compiler/rocm/dtk-24.04.1

BUILD_DIR=$(dirname $(readlink -f "$BASH_SOURCE[0]"))

../configure --prefix=${BUILD_DIR}/../my_libs CC=mpiicc CXX=hipcc FC=mpiifort \
					  CFLAGS="-O3 -g" \
					  FCFLAGS="-O3 -g" \
					  CXXFLAGS="-O3 -g -std=c++17 -DHAVE_OLD_HIP_TYPESTRUCTURE -D__INTEL_COMPILER -DROCBLAS_V3 -D__HIP_PLATFORM_AMD__ --offload-arch=gfx906" \
					  LIBS="-L${ROCM_PATH}/lib -lgalaxyhip -lamdhip64 -lrocblas -lhipblas" \
					  SCALAPACK_FCFLAGS="-I${MKLROOT}/include/intel64/lp64" \
					  SCALAPACK_LDFLAGS="-L${MKLROOT}/lib/intel64 -lmkl_scalapack_lp64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lmkl_blacs_intelmpi_lp64 -lpthread -lm -Wl,-rpath,${MKLROOT}/lib/intel64" \
					  --enable-option-checking=fatal --with-mpi=yes --enable-amd-gpu --enable-single-precision --enable-gpu-streams=amd --enable-hipcub --disable-cpp-tests --with-rocsolver \
					  --disable-sse --disable-sse-assembly --disable-avx --disable-avx2 --disable-avx512 --enable-gpu-ccl=rccl

make -j30

make install -j20
