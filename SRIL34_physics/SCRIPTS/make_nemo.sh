cd $WDIR 
#################################################################
#first get/download NEMO 
#################################################################
#get nemo (only use firts time you install. Comment out before compiling once nemo is installed)
svn co http://forge.ipsl.jussieu.fr/nemo/svn/NEMO/branches/UKMO/NEMO_4.0.4_mirror NEMO_4.0.4 
#svn co http://forge.ipsl.jussieu.fr/nemo/svn/NEMO/releases/r4.0/r4.0.4
#svn co http://forge.ipsl.jussieu.fr/nemo/svn/NEMO/releases/r4.0/r4.0.6

#######################################################################
#load modules
#module -s restore /work/n01/shared/acc/n01_modules/ucx_env
#module load cray-hdf5-parallel/1.12.0.7
#module load cray-netcdf-hdf5parallel/4.7.4.7
#module load cmake
module swap craype-network-ofi craype-network-ucx
module swap cray-mpich cray-mpich-ucx
module load cray-hdf5-parallel/1.12.0.7
module load cray-netcdf-hdf5parallel/4.7.4.7

#compile nemo
#################################################################
# get arch 
#ATTENTION modify the following file to have the correct path for xios
#cp /work/n01/shared/acc/arch-X86_ARCHER2-Cray.fcm  $NEMO/arch/arch-X86_ARCHER2-Cray.fcm
#sed -i "s,/work/n01/shared/acc/xios-2.5,/work/n01/n01/jrule/SANH/xios-2.5,g" $NEMO/arch/arch-X86_ARCHER2-Cray.fcm
cp /work/n01/shared/nemo/ARCH/arch-X86_ARCHER2-Cray.fcm $NEMO/arch/arch-X86_ARCHER2-Cray.fcm
#sed -i "s,/work/n01/shared/nemo/xios-2.5,/work/n01/n01/jrule/SANH/xios-2.5,g" $NEMO/arch/arch-X86_ARCHER2-Cray.fcm


cd $NEMO
# go to ext/FCM/lib/Fcm/Config.pm and change
# FC_MODSEARCH => '',             # FC flag, specify "module" path
#to
#FC_MODSEARCH => '-J',           # FC flag, specify "module" path
sed -i "s/FC_MODSEARCH => ''/FC_MODSEARCH => '-J'/g" ext/FCM/lib/Fcm/Config.pm

cd $NEMO
#make configuration first
./makenemo -n $CONFIG -r AMM12  -m X86_ARCHER2-Cray -j 16

#changes the keys and copy MY_SRC to your configurations
#cd $CDIR/$CONFIG
#cp $GITCLONE/cpp_SEAsia.fcm cpp_$CONFIG.fcm
#cp -r -f $GITCLONE/MY_SRC ./

#make configuration with updates included 
cd $NEMO
./makenemo -r $CONFIG -m X86_ARCHER2-Cray -j 16 clean
./makenemo -r $CONFIG -m X86_ARCHER2-Cray -j 16
#################################################################
cd $WDIR
