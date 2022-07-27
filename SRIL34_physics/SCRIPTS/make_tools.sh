#make_tools.sh
#***********************
#

  # Ensure the correct modules are loaded for ARCHER2
  # Load modules listed in /work/n01/shared/nemo/setup
  # Tested 27Jun22
  module swap craype-network-ofi craype-network-ucx
  module swap cray-mpich cray-mpich-ucx
  module load cray-hdf5-parallel/1.12.0.7
  module load cray-netcdf-hdf5parallel/4.7.4.7

  # Make an adjustment to the DOMAINcfg source code to accomodate more varied vertical coords
  cp $EXTRA/DOMAIN/domzgr.f90.melange $TDIR/DOMAINcfg/src/domzgr.f90

  # Apply patches for the weight file code
  cd $NEMO/tools/WEIGHTS/src
  patch -b < $EXTRA/patch_files/scripinterp_mod.patch
  patch -b < $EXTRA/patch_files/scripinterp.patch
  patch -b < $EXTRA/patch_files/scrip.patch
  patch -b < $EXTRA/patch_files/scripshape.patch
  patch -b < $EXTRA/patch_files/scripgrid.patch


  # compile tools
  cd $NEMO/tools
  ./maketools -m X86_ARCHER2-Cray -n NESTING
  ./maketools -m X86_ARCHER2-Cray -n REBUILD_NEMO
  ./maketools -m X86_ARCHER2-Cray -n WEIGHTS
  ./maketools -m X86_ARCHER2-Cray -n DOMAINcfg

  cd $WORK
