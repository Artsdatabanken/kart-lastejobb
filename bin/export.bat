cd ..\fme\out

for %%f in (*.fmw) do fme.exe %%f

cd ..\..\bin

set out=D:\out\
set geojson=%out%geojson\
cd %geojson%

for /D %%i in (%geojson%*) do (
    python D:\git\grunnkart-dataflyt\bin\geojsonPropertiesTagger.py %%~ni\%%~ni.geojson %%~ni\%%~ni.geojson.tagged
    move %%~ni\%%~ni.geojson %%~ni\%%~ni.geojson.orig 
    move %%~ni\%%~ni.geojson.tagged %%~ni\%%~ni.geojson 
    docker run -it --rm -v %%i:/data tippecanoe:latest tippecanoe -pk -P -zg -pS -o /data/%%~ni.mbtiles /data/%%~ni.geojson
    move %%i\%%~ni.mbtiles %out%mbtiles\
    del %%~ni\%%~ni.geojson.orig
)