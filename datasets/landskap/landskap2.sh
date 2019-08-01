prefix=LA
ts=10000
ogr2ogr -f GeoJSON -t_srs EPSG:3857 LA-3857.geojson LA.geojson  
rm $prefix.tif
gdal_rasterize -ot UInt32 -a r -ts $ts $ts -of GTiff $prefix-3857.geojson $prefix.tif
gdal_rasterize -a g -b 2 $prefix-3857.geojson $prefix.tif
gdal_rasterize -a b -b 3 $prefix-3857.geojson $prefix.tif
gdal_translate -ot Byte -r nearest -of MBTILES -co RESAMPLING=NEAREST $prefix.tif $prefix.mbtiles
sqlite3 $prefix.mbtiles "select zoom_level, count(*) from tiles GROUP BY zoom_level"
gdaladdo -r nearest $prefix.mbtiles 2 4 8 16 32 64 128 256 512 1024 2048 4096
sqlite3 $prefix.mbtiles "select zoom_level, count(*) from tiles GROUP BY zoom_level"
scp $prefix.mbtiles grunnkart@hydra:tilesdata/indexed/
#scp $prefix.colors.json grunnkart@hydra:tilesdata/raster/

