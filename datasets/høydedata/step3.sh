set -e

PREFIX=NN-NA-BS-8

# DTM mbtiles from source VRT
#gdal_translate -ot Int16 -of MBTILES  build/dtm.vrt  build/DTM.mbtiles
#gdaladdo build/${PREFIX}.mbtiles 

gdal_translate -ot Int16 -of MBTILES build/DTM_avg.tif     build/DTM.mbtiles

gdal_translate -ot Int16 -of MBTILES build/${PREFIX}ER.tif build/${PREFIX}ER.mbtiles
gdal_translate -ot Int16 -of MBTILES build/${PREFIX}RR.tif build/${PREFIX}RR.mbtiles
gdal_translate -ot Int16 -of MBTILES build/${PREFIX}TH.tif build/${PREFIX}TH.mbtiles
gdal_translate -ot Int16 -of MBTILES build/${PREFIX}TP.tif build/${PREFIX}TP.mbtiles
gdal_translate -ot Int16 -of MBTILES build/${PREFIX}TU.tif build/${PREFIX}TU.mbtiles

gdaladdo build/${PREFIX}ER.mbtiles 
gdaladdo build/${PREFIX}RR.mbtiles 
gdaladdo build/${PREFIX}TH.mbtiles 
gdaladdo build/${PREFIX}TP.mbtiles 
gdaladdo build/${PREFIX}TU.mbtiles 





