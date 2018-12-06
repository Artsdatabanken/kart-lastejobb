#!/bin/bash
#   $1 = Full path to geojson-file
#   $2 = Data-folder

export name=${1/\.4326\.geojson/}.3857.mbtiles
export code=`echo ${1/${2}\//}| sed -e 's/\/vector.4326.geojson//' |sed -e 's/\//-/g'`
echo Working on $name
# Remove old file
rm $name
tippecanoe --increase-gamma-as-needed -ab -b 0 -zg -pS -S 10 -l $code -o $name $1
