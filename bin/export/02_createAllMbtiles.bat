@echo off
set out=D:\out\
set datafolder=/data

REM	--------------------------------------------------------------------------------------
REM     Main logic
REM	--------------------------------------------------------------------------------------

echo Creating vector mbtiles for geojson
set tippecanoe=sh -c "find %datafolder% -name '*.geojson' -exec bash /app/tippecanoe.sh {} %datafolder% \;"
docker run -v %out%:%datafolder% -v %CD%:/app -it --rm tippecanoe %tippecanoe%

echo Creating raster mbtiles for png
set gdal=sh -c "find %datafolder% -name '*.png' -exec bash /app/gdal.near.sh {} \;"
docker run -v %out%:%datafolder% -v %CD%:/app -it --rm geographica/gdal2 %gdal%

exit

echo Creating raster mbtiles for bil
set gdal=sh -c "find %datafolder% -name '*.bil' -exec bash /app/gdal.sh {} \;"
docker run -v %out%:%datafolder% -v %CD%:/app -it --rm geographica/gdal2 %gdal%

exit

REM	--------------------------------------------------------------------------------------



REM	--------------------------------------------------------------------------------------
REM     Options for gdal (windows, deprecated)
REM	--------------------------------------------------------------------------------------
set pngname=%datafolder%/%%~ni

set gdal_translate=gdal_translate -ot Byte -r nearest -of MBTILES -co RESAMPLING=NEAREST %pngname%.png %pngname%.mbtiles
set gdaladdo=gdaladdo -r average %pngname%.mbtiles 2 4 8 16 32 64 128 256 512 1024
REM set gdalcommand="%gdal_translate% && %gdaladdo%""

set gdaldocker=docker run %gdaldatafolder% -it --rm geographica/gdal2 
REM	--------------------------------------------------------------------------------------

REM	--------------------------------------------------------------------------------------
REM     Options for tippecanoe (windows, deprecated) (see further down for explanations)
REM	--------------------------------------------------------------------------------------
set default=-ab -b 0 -zg -pS -S 10 -l %%~ni -o /data/%%~ni.mbtiles /data/%%~ni.geojson
set tippecanoe=--increase-gamma-as-needed %default%
REM	--------------------------------------------------------------------------------------


REM	--------------------------------------------------------------------------------------
REM     Running in windows (windows, deprecated)
REM	--------------------------------------------------------------------------------------

cd %out%
call :treeProcess
goto :eof

:treeProcess
echo Working on %CD%
for %%i in (*.geojson) do (
    echo Creating vector mbtile
    docker run -v %CD%:/data -it --rm tippecanoe:latest tippecanoe %tippecanoe%
)
for %%i in (*.png) do (
    echo Creating raster mbtile
    docker run -v %CD%:%datafolder% -it --rm geographica/gdal2 %gdal_translate%
    echo Creating overviews for raster mbtile
    docker run -v %CD%:%datafolder% -it --rm geographica/gdal2 %gdaladdo%
)

for /D %%d in (*) do (
    cd %%d
    call :treeProcess
    cd ..
)
exit /b
REM	--------------------------------------------------------------------------------------



REM	--------------------------------------------------------------------------------------
REM 	Used tippecanoe options
REM	--------------------------------------------------------------------------------------
REM 	-b				buffer in pixels for tile
REM 	-zg				automatically finds best max zoomlevel
REM 	-ab				detect shared borders and simplify them in the same way
REM 	-S				simplification tolerance in tile units
REM 	--drop-densest-as-needed	drops small features
REM	--increase-gamma-as-needed	increases gamma (-g)
REM	-g				rate at which especially dense dots are dropped (default 0, for no effect). A gamma of 2 reduces the number of dots less than a pixel apart to the square root of their original number.
REM	-pS				Don't simplify lines and polygons at maxzoom (but do simplify at lower zooms)
REM	-l				include layer name in output
REM	-o				Name the output file
REM	-r				rate at which dots are dropped at zoom levels below basezoom (default 2.5). If you use -rg, it will guess a drop rate that will keep at most 50,000 features in the densest tile
REM	-pf				no feature-limit (>200k)
REM	-pk				no size-limit (>500k)
REM	--------------------------------------------------------------------------------------

REM	--------------------------------------------------------------------------------------
REM     Some variations for tippecanoe worth remembering
REM	--------------------------------------------------------------------------------------
REM set tippecanoe=--drop-densest-as-needed --increase-gamma-as-needed %default%
REM More aggressive simplification with -r and -g
REM set tippecanoe=-rg --increase-gamma-as-needed %default%
REM Only drop densest
REM set tippecanoe=--drop-densest-as-needed %default%
REM	--------------------------------------------------------------------------------------

REM	--------------------------------------------------------------------------------------
REM     Settings for ogr2ogr
REM	--------------------------------------------------------------------------------------
REM set dsco=-dsco TILING_SCHEME="EPSG:25833,-640820,9117235,3000000" -dsco FORMAT=DIRECTORY -dsco MAXZOOM=10
REM set ogrcommand=ogr2ogr -t_srs epsg:25833 -f MVT %datafolder%/25833/%%~ni %datafolder%/%%~ni.geojson %dsco%
REM	--------------------------------------------------------------------------------------

REM	--------------------------------------------------------------------------------------
REM     Some helpful stuff that could be useful down the line
REM	--------------------------------------------------------------------------------------
REM for-loop:
REM for i in *.bil; do echo ${i/\.*/}.raster.mbtiles; done;
REM retile:
REM gdal_retile.py -ps 256 256 -of png -ot Byte -s_srs epsg:25833 -pyramidOnly -levels 5 -r bilinear -targetDir AO-18 AO-18.bil
REM	--------------------------------------------------------------------------------------