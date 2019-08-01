const fs = require("fs")

const kode = "na-bs-6se"
const sourceFile = "bs-6.geojson"
const inputVariable = "PCA1"
const pcamin = -4.7302
const pcamax = 4.3179

let max = 0,
  min = 9999

function normalize(pca) {
  if (pca < pcamin || pca > pcamax)
    throw new Error("Value " + pca + " out of range.")
  const rval = ((pca - pcamin) / (pcamax - pcamin)) * 255
  max = Math.max(rval, max)
  min = Math.min(rval, min)
  return Math.round(rval)
}

const json = convert(sourceFile)
console.log("Output range: ", min, "-", max)

function convert(sourceFile) {
  console.log("Reading ", sourceFile)
  const json = JSON.parse(fs.readFileSync(sourceFile))
  const features = json.features
  const newFeatures = []
  features.forEach(f => {
    const props = f.properties
    const value = normalize(props[inputVariable])
    f.properties = {
      value: value
    }
    newFeatures.push(f)
  })

  return {
    type: "FeatureCollection",
    name: json.name,
    crs: json.crs,
    features: newFeatures
  }
}

fs.writeFileSync(kode + "/polygon.geojson", JSON.stringify(json))
