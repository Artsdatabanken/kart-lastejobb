@echo off
set out=D:\out\
set geojson=%out%geojson\codes

for %%i in (%geojson%*) do (
    docker run -it --rm -v %geojson%:/data tippecanoe:latest tippecanoe -b 0 -zg -ab --drop-densest-as-needed -pS -S 10 -l %%~ni -o /data/%%~ni.mbtiles /data/%%~ni.geojson
)
move %geojson%*.mbtiles %out%codes