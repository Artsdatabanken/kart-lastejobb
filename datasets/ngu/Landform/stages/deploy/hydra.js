const { processes } = require("lastejobb");

const exec = processes.exec

exec('rsync -zarv build/ grunnkart@hydra:~/tilesdata/Natur_i_Norge/Natursystem/Beskrivelsessystem/Landform/Elveløpsformer/Bekkekløft/')
exec('rsync -zarv build/ grunnkart@hydra:~/tilesdata/Natur_i_Norge/Natursystem/Beskrivelsessystem/Landform/Elveløpsformer/')
