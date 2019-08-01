const fs = require("fs")

/*
  ogr2ogr -f geojson korn.geojson Sediment_NiN.gdb/
 ~/temp/gdal/gdal-2.3.2/apps/ogr2ogr -f MVT na-lkm-s3e.mbtiles na-lkm-s3e.geojson -dsco MINZOOM=7 -dsco MAXZOOM=7
*/

const NO_DATA = 255
const kodeTilNivå = {
  "0": 0,
  "1": 36,
  "2": 73,
  "3": 109,
  "4": 146,
  "5": 182,
  "6": 219,
  "7": 255,
  x: NO_DATA
}

const newFeatures = []

const sourceFiles = [
  "Kornstorrelse_S3E_S3F_Reg.geojson",
  "Kornstorrelse_S3E_S3F_Det.geojson"
]

sourceFiles.forEach(file => convert(file, newFeatures))

function convert(sourceFile, r) {
  console.log("Reading ", sourceFile)
  const json = JSON.parse(fs.readFileSync(sourceFile))
  const features = json.features
  features.forEach(f => {
    const props = f.properties
    if (!props.S3E in kodeTilNivå)
      throw new Error("Ingen mapping for S3E=" + props.S3E)
    const value = kodeTilNivå[props.S3E]
    if (value !== NO_DATA) {
      f.properties = {
        //      SEDKORNSTR: props.SEDKORNSTR,
        value: value
      }
      newFeatures.push(f)
    }
  })
}

const json = {
  type: "FeatureCollection",
  name: "na-lkm-s3e.geojson",
  crs: { type: "name", properties: { name: "urn:ogc:def:crs:OGC:1.3:CRS84" } },
  features: newFeatures
}
fs.writeFileSync("na-lkm-s3e.geojson", JSON.stringify(json))
