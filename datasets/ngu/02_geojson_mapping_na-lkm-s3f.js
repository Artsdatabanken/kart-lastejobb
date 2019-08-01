const fs = require("fs")

/*
  ogr2ogr -f geojson korn.geojson Sediment_NiN.gdb/
 ~/temp/gdal/gdal-2.3.2/apps/ogr2ogr -f MVT na-lkm-s3e.mbtiles na-lkm-s3e.geojson -dsco MINZOOM=7 -dsco MAXZOOM=7
*/

const NO_DATA = -1
const kodeTilNivå = {
  "0": 0,
  a: 64,
  b: 128,
  c: 191,
  Ø: 255,
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
    const value = kodeTilNivå[props.S3F]
    if (value === undefined)
      throw new Error("Ingen mapping for S3F=" + props.S3F)
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
  name: "na-lkm-s3f.geojson",
  crs: { type: "name", properties: { name: "urn:ogc:def:crs:OGC:1.3:CRS84" } },
  features: newFeatures
}
fs.writeFileSync("na-lkm-s3f.geojson", JSON.stringify(json))
