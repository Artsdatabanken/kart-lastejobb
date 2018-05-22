cd ..\fme\out

for %%f in (*.fmw) do fme.exe %%f

cd ..\..\bin

set out=D:\out\
set geojson=%out%geojson\

for /D %%i in (%geojson%*) do (
    python .\geojsonPropertiesTagger.py %%i\%%~ni.geojson %%i\%%~ni.geojson.tagged
    if not errorlevel 1 move %%i\%%~ni.geojson %%i\%%~ni.geojson.orig
    if not errorlevel 1 move %%i\%%~ni.geojson.tagged %%i\%%~ni.geojson
    if not errorlevel 1 docker run -it --rm -v %%i:/data tippecanoe:latest tippecanoe -pk -P -zg -pS -o /data/%%~ni.mbtiles /data/%%~ni.geojson
    if not errorlevel 1 del %%i\%%~ni.geojson.orig
    if not errorlevel 1 move %%i\%%~ni.mbtiles %out%mbtiles\
)