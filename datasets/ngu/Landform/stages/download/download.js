const { log, wfs } = require("lastejobb");

async function mirror(layerNumber) {
    log.info('Mirror wfs layer ' + layerNumber)
    await wfs.mirror(
        `https://arcgis.ngu.no/arcgis/rest/services/NiN_leveranse/LandformerNGU_NiN_Artsdatabanken/MapServer/${layerNumber}/query?where=1=1&outfields=*&f=geojson`,
        `temp/layer${layerNumber}.geojsonl`)
}

var layerNumber = 3
mirrorOne(layerNumber)

async function mirrorOne() {
    mirror(layerNumber).then(() => {
        if (layerNumber <= 0) return
        layerNumber--
        mirrorOne(layerNumber)
    })
}


