#!/bin/bash

# Build FABM with cray compiler

#module -s restore /work/n01/shared/acc/n01_modules/ucx_env
module load cmake

#module swap craype-network-ofi craype-network-ucx
#module swap cray-mpich cray-mpich-ucx
#module load cray-hdf5-parallel/1.12.0.7
#module load cray-netcdf-hdf5parallel/4.7.4.7

ERSEM_DIR=$CODE_DIR/ersem
FABM_DIR=$CODE_DIR/fabm
FABM_INSTALL=$CODE_DIR/fabm-cray

mkdir $FABM_INSTALL
cd $FABM_INSTALL
cmake $FABM_DIR/src -DFABM_HOST=nemo -DFABM_ERSEM_BASE=$ERSEM_DIR -DFABM_EMBED_VERSION=ON -DCMAKE_INSTALL_PREFIX=$FABM_INSTALL -DCMAKE_Fortran_COMPILER=ftn #-DCMAKE_BUILD_TYPE=debug
make
make install -j4

cd $WORK


