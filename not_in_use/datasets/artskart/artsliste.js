const fs = require("fs");
const path = require("path");
const execSync = require("child_process").execSync;
const fetch = require("node-fetch");
const quantizePointSamples = require("./quantizePointSamples");

const grid_resolution = 250; // meter
const bitmap_resolution = 100; // meter

let data = JSON.parse(fs.readFileSync("artsliste.json")).data;

//downloadOne("AR-XX", 975).then(r => {});
downThemAll().then(r => {});

async function downloadOne(targetUrl, kode, taxonId) {
  const dataDir = path.join("data", targetUrl);
  fs.mkdirSync(dataDir, { recursive: true });
  const obsPath = path.join(dataDir, "observasjoner.32633.geojson");
  const ruter1kmPath = path.join(
    dataDir,
    `raster_ruter.${grid_resolution}m.32633.geojson`
  );
  //if (fs.existsSync(ruter1kmPath)) return;
  const url = `https://artskart.artsdatabanken.no/appapi/api/data/SearchLocations?&TaxonIds%5B%5D=${taxonId}&TaxonGroupIds%5B%5D=&IncludeSubTaxonIds=true&Months%5B%5D=&Categories%5B%5D=&BasisOfRecords%5B%5D=&Behaviors%5B%5D=&InstitutionIds%5B%5D=&CollectionIds%5B%5D=&Img%5B%5D=&Found%5B%5D=&NotRecovered%5B%5D=&Valid%5B%5D=&UnsureId%5B%5D=&Spontan%5B%5D=&CenterPoints=false&EpsgCode=32633&LocationId=0&GroupBy=0&Style=1&YearFrom=2000&YearTo=0&CoordinatePrecisionFrom=0&CoordinatePrecisionTo=200&BoundingBox=`;
  const response = await fetch(url);
  const str = await response.json();
  fs.writeFileSync(obsPath, JSON.stringify(str));
  const json = JSON.parse(str);
  const q = quantizePointSamples(json, grid_resolution);
  fs.writeFileSync(ruter1kmPath, JSON.stringify(q));
  convert(ruter1kmPath, bitmap_resolution);
}

async function downThemAll() {
  for (const node of data) {
    const { taxonId, kode, url } = node;
    //if (kode === "AR-101825")
    await downloadOne(url, kode, taxonId);
  }
}

function convert(sourcePath, resolution) {
  const geojson3857Path = sourcePath.replace("32633", "3857");
  const tifPath = sourcePath.replace(".geojson", ".tif");
  const mbtilesPath = sourcePath.replace("32633.geojson", "3857.mbtiles");
  //  ogr2ogr -t_srs EPSG:3857 ${geojson3857Path} ${sourcePath}

  exec(
    `gdal_rasterize -co COMPRESS=LZW -co alpha=no -a_nodata 0 -ot Byte -burn 255 -tr ${resolution} ${resolution} -te -119000 6473000 1158000 8000000 ${sourcePath} ${tifPath}`
  );
  exec(
    `gdal_translate ${tifPath} ${mbtilesPath} -of MBTILES` // -co ZOOM_LEVEL_STRATEGY=LOWER` // -r average
  );
  exec(`gdaladdo -r average ${mbtilesPath}`);
}

function exec(cmd) {
  console.log(cmd);
  execSync(cmd);
}
// gdal_rasterize -ot Byte -burn 255 -tr 1000 1000 -te -119000 6473000 1158000 8000000 AR-101825.geojson AR-101825.tif
// gdal_translate AR-101825.tif AR-101825.mbtiles -of MBTILES
// sqlite3 AR-101825.mbtiles "SELECT * from metadata;"
// gdaladdo -r average AR-101825.mbtiles 2 4 8 16 32 64 128 256 512 1024 2048 4096
