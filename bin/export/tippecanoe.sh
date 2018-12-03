#!/bin/bash
export name=${1/\.4326\.geojson/}.3857.mbtiles
echo Working on $name
# Remove old file
rm $name
# Remove wrongly named file from last run
rm ${1/\.geojson/}.mbtiles
tippecanoe --increase-gamma-as-needed -ab -b 0 -zg -pS -S 10 -o $name $1
