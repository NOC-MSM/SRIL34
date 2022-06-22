#--------------SCRIPT FOR AUTOMATING THE CMEMS PYNEMO PROCESS-----------

# REMEMBER TO CHANGE THE DOWNLOAD DATE IN EACH OF THE SCRIPTS

# 1. Download the CMEMS T and S data: 

echo "downloading CMEMS T, S data"
. ./download_CMEMS.sh			> Download1.txt 2>&1		

echo "Done"

#  2. Download the CMEMS U and V data:
 
echo "downloading CMEMS U and V data"
. ./download_CMEMS_UV.sh		> Download2.txt 2>&1

echo "Done - now check the output txt files for any errors (omissions)"


#3. Create mask 

#. ./generate_CMEMS_coordinates.sh         	#this has already been done so can comment out

#echo "creating mask"




