const Jimp = require("jimp")
const fs = require("fs")

const farger = JSON.parse(fs.readFileSync("farger.json"))
const koder = JSON.parse(fs.readFileSync("LA_farge.json"))

new Jimp(512, 1, 0xffffffff, (err, image) => {
  Object.keys(koder).forEach(kode => {
    const index = koder[kode]
    const color = finnFarge(kode)
    image.setPixelColor(color, index, 0)
  })
  for (let x = 0; x < 512; x++) {}
  image.write("LA.palette.png")
})

function finnFarge(kode) {
  while (true) {
    if (farger[kode]) return Jimp.cssColorToHex(farger[kode])
    kode = kode.substring(0, kode.length - 1)
  }
}

function grad(index) {
  const dx = index % 256
  return Jimp.rgbaToInt(dx, 255 - dx, dx, 200)
}
