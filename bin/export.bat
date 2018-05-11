set out=D:\out\
set geojson=%out%geojson\sqrt42\

cd ..\fme\out

for %%f in (*.fmw) do fme.exe %%f

cd ..\..\bin

python .\geojsonPropertiesTagger.py %geojson%sqrt42.geojson %geojson%sqrt42tagged.geojson

move %geojson%sqrt42.geojson %geojson%sqrt42.geojson.orig

move %geojson%sqrt42tagged.geojson %geojson%sqrt42.geojson

docker run -it --rm -v %geojson%:/data tippecanoe:latest tippecanoe -pk -P -zg -pS -o /data/sqrt42.mbtiles /data/sqrt42.geojson

move %geojson%sqrt42.mbtiles %out%mbtiles\

del %geojson%sqrt42.geojson.orig