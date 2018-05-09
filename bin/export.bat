cd ..\fme\out

REM for %%f in (*.fmw) do fme.exe %%f

cd ..\..\bin

REM python .\geojsonPropertiesTagger.py D:\out\geojson\sqrt42\sqrt42.geojson D:\out\geojson\sqrt42\sqrt42tagged.geojson

move D:\out\geojson\sqrt42\sqrt42.geojson D:\out\geojson\sqrt42\sqrt42.geojson.orig

move D:\out\geojson\sqrt42\sqrt42tagged.geojson D:\out\geojson\sqrt42\sqrt42.geojson

docker run -it --rm -v D:\out\geojson\sqrt42\:/data tippecanoe:latest tippecanoe -pk -P -zg -pS -o /data/sqrt42.mbtiles /data/sqrt42.geojson