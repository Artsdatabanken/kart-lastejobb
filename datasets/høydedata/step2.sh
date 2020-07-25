set -e
SRC=temp/dtm.vrt
METERPERPIXEL=100
PREFIX=NN-NA-BS-8
#gdalwarp -te -2500000 3500000 3045984 9045984 -tap -tr $METERPERPIXEL $METERPERPIXEL $SRC build/dtm.tif                                                        
gdalwarp -overwrite $SRC build/DTM.tif -tap -tr $METERPERPIXEL $METERPERPIXEL                                                        
gdalwarp -overwrite $SRC build/DTM_min.tif -tap -r min -tr $METERPERPIXEL $METERPERPIXEL
gdalwarp -overwrite $SRC build/DTM_max.tif -tap -r max -tr $METERPERPIXEL $METERPERPIXEL
gdalwarp -overwrite $SRC build/DTM_avg.tif -tap -r average -tr $METERPERPIXEL $METERPERPIXEL

gdaldem aspect build/DTM.tif build/${PREFIX}ER.tif 
gdaldem roughness build/DTM.tif build/${PREFIX}RR.tif 
gdaldem slope build/DTM.tif build/${PREFIX}TH.tif 
gdaldem TPI build/DTM.tif build/${PREFIX}TP.tif
gdaldem TRI build/DTM.tif build/${PREFIX}TU.tif  

#gdaldem slope temp/dtm.vrt build/slope.tif 
#gdaldem aspect temp/dtm.vrt build/aspect.tif 
#gdaldem TRI temp/dtm.vrt build/tri.tif  
#gdaldem TPI temp/dtm.vrt build/tpi.tif 
#gdaldem roughness temp/dtm.vrt build/roughness.tif 
