#################################################
# Script to compile XIOS2.5
# Tested on revision 2022, following instructions provided https://docs.archer2.ac.uk/research-software/nemo/nemo/#compiling-xios-and-nemo
#
# Note that a precompiled version of XIOS2.5 is available for use here:
# /work/n01/shared/acc/xios-2.5
#
# Updated after Archer2 upgrade
#################################################

# Build XIOS with Cray compiler
#module -s restore /work/n01/shared/acc/n01_modules/ucx_env
#module load cmake
module swap craype-network-ofi craype-network-ucx
module swap cray-mpich cray-mpich-ucx
module load cray-hdf5-parallel/1.12.2.1
module load cray-netcdf-hdf5parallel/4.9.0.1

XIOS_DIR=$CODE_DIR/xios
XIOS_INSTALL=$CODE_DIR/xios-cray
cd $XIOS_DIR

# Copy arch files
cp $CODE_DIR/extra-files/xios/arch-X86_ARCHER2-Cray* $XIOS_DIR/arch/
cp $CODE_DIR/extra-files/xios/Config_cray.pm $XIOS_DIR/tools/FCM/lib/Fcm/Config.pm

export CC=cc export CXX=CC export FC=ftn export F77=ftn export F90=ftn
cd $XIOS_DIR && ./make_xios --prod --arch X86_ARCHER2-Cray --netcdf_lib netcdf4_par --job 16 --full
rsync -a $XIOS_DIR/bin $XIOS_DIR/inc $XIOS_DIR/lib $XIOS_INSTALL

cd $WORK
