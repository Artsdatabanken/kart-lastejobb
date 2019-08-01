var shapefile = require("shapefile")
const fs = require("fs")

// Konverter artsobservasjoner i .shp til .json
const shpfilePath = process.argv[2]
const outputfile = process.argv[3]

let count = 0
let r = {}

function addObservation(o) {
  const props = o.properties
  if (props.YearCollec < 2008) return
  const utme = (parseInt(props.UTM33ost) / 1000).toFixed(0) * 1000
  const utmn = (parseInt(props.UTM33nord) / 1000).toFixed(0) * 1000
  if (!r[utme]) r[utme] = {}
  if (r[utme][utmn]) return

  r[utme][utmn] = 1
  count++
}

function lagre() {
  const feats = {
    type: "FeatureCollection",
    crs: {
      type: "name",
      properties: {
        name: "EPSG:25833"
      }
    },
    features: []
  }

  Object.keys(r).forEach(se => {
    Object.keys(r[se]).forEach(sn => {
      const e = parseInt(se)
      const n = parseInt(sn)
      const coordinates = [
        [[e, n], [e + 1000, n], [e + 1000, n + 1000], [e, n + 1000], [e, n]]
      ]
      const feature = {
        type: "Feature",
        geometry: { type: "Polygon", coordinates: coordinates }
      }
      feats.features.push(feature)
    })
  })
  fs.writeFileSync(outputfile, JSON.stringify(feats))
}

shapefile
  .open(shpfilePath)
  .then(source =>
    source.read().then(function importerOmråde(result) {
      if (result.done) {
        lagre()
        return
      }
      addObservation(result.value)
      return source.read().then(importerOmråde)
    })
  )
  .catch(error => {
    console.error(error.stack)
    process.exit(1)
  })
