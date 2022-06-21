#Script to download hindacst of CMEMS data
#This script is set to download salinity, temperature, and ssh.
#The date before and after the start and end of the year are also needed by pynemo, they are download separatly at the end of the file.
#Note that if you are downloading a leap year, you will need to download the 29th February separately as well.

# change <userID>, and <pwd> to your personal Copernicus credentials. 
# set year = "yyyy" to the date you want to download.

#set up environment:
#module load anaconda
#source activate motu_env

#CMEMS files per year


year="2019"
for mon in $(seq -f "%02g" 1 12)
do
if [ "$mon" = "01" -o "$mon" = "03" -o "$mon" = "05" -o "$mon" = "07" -o "$mon" = "08" -o "$mon" = "10" -o "$mon" = "12" ]
then
echo $mon
 for day in $(seq -f "%02g" 1 31)
  do
  echo $day
python -m motuclient --motu http://nrt.cmems-du.eu/motu-web/Motu --service-id GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS --product-id global-analysis-forecast-phy-001-024 --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "${year}-${mon}-${day} 12:00:00" --date-max "${year}-$mon-$day 12:00:00" --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --variable zos --out-name "CMEMS_${year}_${mon}_${day}_download.nc" --user <userID> --pwd "<pwd>"
done
fi
if [ "$mon" = "04" -o "$mon" = "06" -o "$mon" = "09" -o "$mon" = "11" ]
then
echo $mon
 for day in $(seq -f "%02g" 1 30)
  do
  echo $day
python -m motuclient --motu http://nrt.cmems-du.eu/motu-web/Motu --service-id GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS --product-id global-analysis-forecast-phy-001-024 --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "${year}-${mon}-${day} 12:00:00" --date-max "${year}-$mon-$day 12:00:00" --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --variable zos --out-name "CMEMS_${year}_${mon}_${day}_download.nc" --user <userID> --pwd "<pwd>"
done
fi
if [ "$mon" = "02" ]
then
echo $mon
 for day in $(seq -f "%02g" 1 28)
  do
  echo $day
python -m motuclient --motu http://nrt.cmems-du.eu/motu-web/Motu --service-id GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS --product-id global-analysis-forecast-phy-001-024 --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "${year}-${mon}-${day} 12:00:00" --date-max "${year}-$mon-$day 12:00:00" --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --variable zos --out-name "CMEMS_${year}_${mon}_${day}_download.nc" --user <userID> --pwd "<pwd>"
done
fi
done

#still need to download last of previous year and first of subsequent year

python -m motuclient --motu http://nrt.cmems-du.eu/motu-web/Motu --service-id GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS --product-id global-analysis-forecast-phy-001-024 --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "2018-12-31 12:00:00" --date-max "2018-12-31 12:00:00" --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --variable zos --out-name "CMEMS_2018_12_31_download.nc" --user <userID> --pwd "<pwd>"

python -m motuclient --motu http://nrt.cmems-du.eu/motu-web/Motu --service-id GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS --product-id global-analysis-forecast-phy-001-024 --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "2020-01-01 12:00:00" --date-max "2020-01-01 12:00:00" --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --variable zos --out-name "CMEMS_2020_01_01_download.nc" --user <usrID> --pwd "<pwd>"

cd ..


