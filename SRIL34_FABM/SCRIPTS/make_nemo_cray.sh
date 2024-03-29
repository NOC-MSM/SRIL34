#!/bin/bash

# Build NEMO with Cray compiler
# Updated after Archer2 upgrade
#module -s restore /work/n01/shared/acc/n01_modules/ucx_env
module load cmake

module swap craype-network-ofi craype-network-ucx
module swap cray-mpich cray-mpich-ucx
module load cray-hdf5-parallel/1.12.2.1
module load cray-netcdf-hdf5parallel/4.9.0.1

export FABM_HOME=$CODE_DIR/fabm-cray
export XIOS_HOME=$CODE_DIR/xios-cray
NEMO_DIR=$CODE_DIR/nemo
cd $NEMO_DIR

cp $CODE_DIR/extra-files/nemo/Config_cray.pm $NEMO_DIR/ext/FCM/lib/Fcm/Config.pm
#if first compile, also cp the refernce config in nemo's cfgs dir (make sure you've got the MY_SRC)

## AMM7 FABM
CFG=SRIL_FABM
ARCH=X86_ARCHER2-Cray_FABM
REF=SANH_FABM
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

# added key_vectopt_loop to the cpp keys.
# RECOMPILE
#
#./makenemo -m $ARCH -r $CFG -j 4
cd $WORK
