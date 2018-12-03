@echo off
set out=D:\out\
cd %out%

set gdaldockerfolder=/home/gdaldatafolder

set gdaldatafolder=-v %CD%:%gdaldockerfolder%

set dsco=-dsco TILING_SCHEME="EPSG:25833,-640820,9117235,3000000" -dsco FORMAT=DIRECTORY -dsco MAXZOOM=10

set ogrcommand=ogr2ogr -t_srs epsg:25833 -f MVT %gdaldockerfolder%/25833/%%~ni %gdaldockerfolder%/%%~ni.geojson %dsco%

set gdaldocker=docker run %gdaldatafolder% --name gdal2 -it --rm geographica/gdal2 %ogrcommand%

call :treeProcess
goto :eof

:treeProcess
for %%i in (*.geojson) do (
    echo Creating utm33 mbtile for %%~ni.geojson
    %gdaldocker% 
)
for /D %%d in (*) do (
    cd %%d
    call :treeProcess
    cd ..
)
exit /b
