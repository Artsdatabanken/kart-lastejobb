set -e
PREFIX=NN-NA-BS-8

scp build/${PREFIX}ER.mbtiles grunnkart@hydra:~/tilesdata/Natur_i_Norge/Natursystem/Beskrivelsessystem/Terrengformvariabler/Eksponeringsretning/raster_gradient.3857.mbtiles
scp build/${PREFIX}RR.mbtiles grunnkart@hydra:~/tilesdata/Natur_i_Norge/Natursystem/Beskrivelsessystem/Terrengformvariabler/Relativt_relieff/raster_gradient.3857.mbtiles
scp build/${PREFIX}TH.mbtiles grunnkart@hydra:~/tilesdata/Natur_i_Norge/Natursystem/Beskrivelsessystem/Terrengformvariabler/Terrenghelning/raster_gradient.3857.mbtiles
scp build/${PREFIX}TP.mbtiles grunnkart@hydra:~/tilesdata/Natur_i_Norge/Natursystem/Beskrivelsessystem/Terrengformvariabler/Terrengposisjon/raster_gradient.3857.mbtiles
scp build/${PREFIX}TU.mbtiles grunnkart@hydra:~/tilesdata/Natur_i_Norge/Natursystem/Beskrivelsessystem/Terrengformvariabler/Terrenguro/raster_gradient.3857.mbtiles

scp build/${PREFIX}ER.tif grunnkart@hydra:~/tilesdata/Natur_i_Norge/Natursystem/Beskrivelsessystem/Terrengformvariabler/Eksponeringsretning/raster.32633.tif
scp build/${PREFIX}RR.tif grunnkart@hydra:~/tilesdata/Natur_i_Norge/Natursystem/Beskrivelsessystem/Terrengformvariabler/Relativt_relieff/raster.32633.tif
scp build/${PREFIX}TH.tif grunnkart@hydra:~/tilesdata/Natur_i_Norge/Natursystem/Beskrivelsessystem/Terrengformvariabler/Terrenghelning/raster.32633.tif
scp build/${PREFIX}TP.tif grunnkart@hydra:~/tilesdata/Natur_i_Norge/Natursystem/Beskrivelsessystem/Terrengformvariabler/Terrengposisjon/raster.32633.tif
scp build/${PREFIX}TU.tif grunnkart@hydra:~/tilesdata/Natur_i_Norge/Natursystem/Beskrivelsessystem/Terrengformvariabler/Terrenguro/raster.32633.tif
