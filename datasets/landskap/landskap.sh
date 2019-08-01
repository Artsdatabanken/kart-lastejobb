prefix=LA
ts=120000
#ts=200000
ogr2ogr -f GeoJSON -t_srs EPSG:3857 LA-3857.geojson LA.geojson  
gdal_rasterize -ot Byte -a r -ts $ts $ts -of GTiff $prefix-3857.geojson $prefix-r.tif
gdal_rasterize -ot Byte -a g -ts $ts $ts -of GTiff $prefix-3857.geojson $prefix-g.tif
gdal_rasterize -ot Byte -a b -ts $ts $ts -of GTiff $prefix-3857.geojson $prefix-b.tif
rm $prefix.tif
gdal_merge.py -separate -o $prefix.tif $prefix-r.tif $prefix-g.tif $prefix-b.tif
gdal_translate -ot Byte -r nearest -of MBTILES -co RESAMPLING=NEAREST $prefix.tif $prefix.mbtiles
sqlite3 $prefix.mbtiles "select zoom_level, count(*) from tiles GROUP BY zoom_level"
gdaladdo -r nearest $prefix.mbtiles 2 4 8 16 32 64 128 256 512 1024 2048 4096
sqlite3 $prefix.mbtiles "select zoom_level, count(*) from tiles GROUP BY zoom_level"
scp $prefix.mbtiles grunnkart@hydra:tilesdata/Natur_i_Norge/Landskap/raster.indexed.3857.mbtiles 

