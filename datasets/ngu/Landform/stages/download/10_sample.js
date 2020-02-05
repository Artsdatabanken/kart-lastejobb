const { wfs } = require("lastejobb");

wfs.mirror("https://arcgis.ngu.no/arcgis/rest/services/NiN_leveranse/LandformerNGU_NiN_Artsdatabanken/MapServer/0/query?where=1=1&outfields=*&f=geojson", "temp/landform.geojsonl")
