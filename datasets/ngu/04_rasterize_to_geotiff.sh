# Rasterize for use in index
METERS_PER_PIXEL=200 
gdal_rasterize -co alpha=no -ot Byte -a value -tr $METERS_PER_PIXEL $METERS_PER_PIXEL na-lkm-s3e_32633.geojson NN-NA-LKM-S3E.tif 
gdal_rasterize -co alpha=no -ot Byte -a value -tr $METERS_PER_PIXEL $METERS_PER_PIXEL na-lkm-s3f_32633.geojson NN-NA-LKM-S3F.tif 
