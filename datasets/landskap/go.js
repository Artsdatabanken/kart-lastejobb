const fs = require('fs')

const keys = {}
let watermark = 1

const json = JSON.parse(fs.readFileSync('marint.geojson'))
json.features.forEach(f => {
   const kode = f.properties['NiN-kode']
   if(!keys[kode]) {
	keys[kode] = watermark
	watermark++
   }
   f.properties = {kode: kode, farge: keys[kode]}
})
console.log(keys)

fs.writeFileSync('marintO.colors.json', JSON.stringify(keys))
fs.writeFileSync('marintO.geojson', JSON.stringify(json))

