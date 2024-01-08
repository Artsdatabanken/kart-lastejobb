#!/bin/bash
export name=${1/\.png/}
echo Working on $name.mbtiles
echo Creating raster mbtile
gdal_translate -ot Byte -r bilinear -of MBTILES -co RESAMPLING=bilinear $name.png $name.mbtiles
echo Creating overviews
gdaladdo -r average $name.mbtiles 2 4 8 16 32 64 128 256 512 1024 2048 4096
