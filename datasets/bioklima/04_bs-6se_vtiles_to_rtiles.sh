KODE=na-bs-6se
node /home/b/src/adb/rasterize-vector-tiles/rasterize-vector-tiles.js \
  -i $KODE/polygon.3857.mbtiles \
  -o $KODE/raster.gradient.3857.mbtiles \
  --colorprop=value \
  --antialias=none

