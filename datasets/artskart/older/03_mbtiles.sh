export GDAL_DATA=~/temp/gdal/gdal-2.3.2/data
~/temp/gdal/gdal-2.3.2/apps/ogr2ogr -f MVT RE.vector.mbtiles artskartredRE.shp.geojson -dsco MINZOOM=14 -dsco MAXZOOM=14
node rasterize-vector-tiles.js -i ../nin-maps-conversion/data/artskart/RE.vector.mbtiles -o RL-DD.mbtiles --color="#0000ff"
~/temp/gdal/gdal-2.3.2/apps/gdaladdo -r average RL-DD.mbtiles
