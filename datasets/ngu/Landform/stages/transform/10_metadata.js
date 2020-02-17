const { io, processes } = require("lastejobb");
var fs = require('fs')
const path = require('path')

function jsonLinesMap(inputfile, outputfile, mapper) {
    io.mkdir(path.dirname(outputfile))
    var reader = require('readline').createInterface({
        input: require('fs').createReadStream(inputfile)
    });

    var writer = fs.createWriteStream(outputfile)
    reader.on('line', function (line) {
        const json = JSON.parse(line)
        const out = mapper(json)
        writer.write(JSON.stringify(out))
        writer.write('\n')
    });
}

function map(feature) {
    const id = feature.properties.GLOBALID.replace(/[\{\}]/g, '')
    //    return { type: "Feature", geometry: feature.geometry, properties: { kode: 'NN-NA-BS-3EL-BK', id } }
    return { type: "Feature", geometry: feature.geometry, properties: { kode: 'BK', id } }
}

jsonLinesMap('temp/landform.geojsonl', 'build/polygon.4326.geojsonl', map)
