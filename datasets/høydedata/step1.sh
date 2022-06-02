#!/bin/bash -e

rm -rf temp
mkdir temp
rm -rf build
mkdir build
cd temp

# DTM 50
wget https://hoydedata.no/LaserInnsyn/Home/DownloadFile/56
mv 56 DTM.zip

# DTM 10
#wget https://hoydedata.no/LaserInnsyn/Home/DownloadFile/54
#mv 54 DTM50.zip

unzip DTM.zip && rm DTM.zip
echo Build Virtual data set "VRT"
cd temp
gdalbuildvrt dtm.vrt *.tif 
cd ..
