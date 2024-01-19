#!/bin/bash

# Build NEMO with Cray compiler
#module -s restore /work/n01/shared/acc/n01_modules/ucx_env
module load cmake

module swap craype-network-ofi craype-network-ucx
module swap cray-mpich cray-mpich-ucx
module load cray-hdf5-parallel/1.12.0.7
module load cray-netcdf-hdf5parallel/4.7.4.7


export FABM_HOME=$CODE_DIR/fabm-cray
export XIOS_HOME=$CODE_DIR/xios-cray
NEMO_DIR=$CODE_DIR/nemo
cd $NEMO_DIR

cp $CODE_DIR/extra-files/nemo/Config_cray.pm $NEMO_DIR/ext/FCM/lib/Fcm/Config.pm

## AMM7 FABM
CFG=SANH_FABM
ARCH=X86_ARCHER2-Cray_FABM
REF=AMM7_FABM
printf 'y\nn\nn\ny\nn\nn\nn\nn\n' |./makenemo -n $CFG -r $REF -m $ARCH -j 0
./makenemo -n $CFG -r $REF -m $ARCH -j 4 clean
./makenemo -n $CFG -r $REF -m $ARCH -j 4 

'''
# AMM7 FABM DEBUG
CFG=AMM7_FABM_DEBUG
ARCH=X86_ARCHER2-Cray_FABM_DEBUG
REF=AMM7_FABM
printf 'y\nn\nn\ny\nn\nn\nn\nn\n' |./makenemo -n $CFG -r $REF -m $ARCH -j 0
./makenemo -n $CFG -r $REF -m $ARCH -j 4 clean
./makenemo -n $CFG -r $REF -m $ARCH -j 4 
'''

cd $WORK
