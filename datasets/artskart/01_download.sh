#!/bin/bash
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
DATAPATH=$SCRIPTPATH/../data/
ARTSKARTPATH=$DATAPATH/artskart/
mkdir $DATAPATH
mkdir $ARTSKARTPATH/
cd $ARTSKARTPATH

wget http://kart.artsdatabanken.no/WMS/kartdata/artskart/artskart.zip
unzip artskart.zip
rm artskart.zip


for f in kartdata/*.shp; do
  target = ${f%.shp}.geojson
  echo Convert $f to $target
  node shp_to_utm_grid.js $f $target
done


~/temp/gdal/gdal-2.3.2/apps/ogr2ogr -f MVT DD.mbtiles artskartredDD.shp.geojson -dsco MINZOOM=5 -dsco MAXZOOM=5
node rasterize-vector-tiles.js -i ../nin-maps-conversion/data/artskart/DD.mbtiles -o test --png --colorvalue=255
