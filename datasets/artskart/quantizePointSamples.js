const fs = require("fs");

function quantizePointSamples(geojson, resolution) {
  let r = {};
  geojson.features.forEach(feature => {
    if (feature.geometry.type !== "Point") return;
    addLocation(feature.geometry.coordinates, resolution, r);
  });
  return toGeoJson(r, resolution);
}

let count = 0;

function addLocation(co, resolution, r) {
  const utme = (parseInt(co[0]) / resolution).toFixed(0) * resolution;
  const utmn = (parseInt(co[1]) / resolution).toFixed(0) * resolution;
  if (!r[utme]) r[utme] = {};
  if (r[utme][utmn]) return;

  r[utme][utmn] = 1;
  count++;
}

function toGeoJson(r, resolution) {
  const geojson = {
    type: "FeatureCollection",
    crs: {
      type: "name",
      properties: {
        name: "EPSG:25833"
      }
    },
    features: []
  };

  Object.keys(r).forEach(se => {
    Object.keys(r[se]).forEach(sn => {
      const e = parseInt(se);
      const n = parseInt(sn);
      const coordinates = [
        [
          [e, n],
          [e + resolution, n],
          [e + resolution, n + resolution],
          [e, n + resolution],
          [e, n]
        ]
      ];
      const feature = {
        type: "Feature",
        geometry: { type: "Polygon", coordinates: coordinates }
      };
      geojson.features.push(feature);
    });
  });
  return geojson;
}

module.exports = quantizePointSamples;
