KODE=na-bs-6se
~/temp/gdal/gdal-2.3.2/apps/ogr2ogr -f MVT $KODE/polygon.3857.mbtiles $KODE/polygon.geojson \
 -dsco MINZOOM=14 -dsco MAXZOOM=14

