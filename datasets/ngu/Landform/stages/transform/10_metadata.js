const { processes } = require("lastejobb");
var fs = require('fs')


function geojsonlMap(inputfile, outputfile, mapper) {
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

geojsonlMap('temp/landform.geojsonl', 'build/polygon.4326.geojsonl', map)
