const { processes } = require("lastejobb");


processes.exec("ogr2ogr -f MVT build/polygon.3857.mbtiles build/polygon.4326.geojsonl -dsco MAXZOOM=12")