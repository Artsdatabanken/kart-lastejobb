set out=D:\out\
set geojson=%out%geojson\

for /D %%i in (%geojson%*) do (
    python ..\geojsonPropertiesTagger.py %%i\%%~ni.geojson %%i\%%~ni.geojson.tagged
    if not errorlevel 1 move %%i\%%~ni.geojson %%i\%%~ni.orig.geojson
    if not errorlevel 1 move %%i\%%~ni.geojson.tagged %%i\%%~ni.geojson
    if not errorlevel 1 docker run -it --rm -v %%i:/data tippecanoe:latest tippecanoe -pk -P -zg -pS -o /data/%%~ni.mbtiles /data/%%~ni.geojson
    REM if not errorlevel 1 del %%i\%%~ni.orig.geojson
    if not errorlevel 1 move %%i\%%~ni.mbtiles %out%mbtiles\
)