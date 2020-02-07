const { processes } = require("lastejobb");

processes.exec("ogr2ogr -f MVT build/polygon.3857.mbtiles build/polygon.4326.geojsonl -lco NAME=polygons -dsco MAXZOOM=12")