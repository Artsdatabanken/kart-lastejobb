# Reproject from geodetic to UTM zone 33 
ogr2ogr -t_srs EPSG:32633 -f GeoJSON na-lkm-s3e_32633.geojson na-lkm-s3e.geojson 
ogr2ogr -t_srs EPSG:32633 -f GeoJSON na-lkm-s3f_32633.geojson na-lkm-s3f.geojson 
 