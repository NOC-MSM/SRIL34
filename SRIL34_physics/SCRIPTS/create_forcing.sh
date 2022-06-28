#SCRIPT TO DOWNLOAD ERA5 FORCING DATA

# set up python environment 

module load anaconda
source activate nrct_env_py3

#export LD_LIBRARY_PATH=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64/lib/amd64/server:$LD_LIBRARY_PATH #not sure if needed

# load modules
#module load nco/gcc/4.4.2.ncwa
module load nco/gcc/4.4.2 #loading this module seemed to fix the ncks library issues 

#run python script
python OFFICIAL_Generate_NEMO_Forcing_NEWERA.py
