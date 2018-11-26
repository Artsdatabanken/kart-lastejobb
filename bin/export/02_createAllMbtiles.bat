rem @echo off
set out=D:\out\
set geojson=%out%geojson\


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

REM Settings we will use in any case
set default=-ab -b 0 -zg -pS -S 10 -l %%~ni -o /dataout/%%~ni.mbtiles /data/%%~ni.geojson

set tippecanoe=--increase-gamma-as-needed %default%

REM set tippecanoe=--drop-densest-as-needed --increase-gamma-as-needed %default%
REM More aggressive simplification with -r and -g
REM set tippecanoe=-rg --increase-gamma-as-needed %default%
REM Only drop densest
REM set tippecanoe=--drop-densest-as-needed %default%

mkdir %out%\polygon\
cd %geojson%
call :treeProcess
goto :eof

:treeProcess
for %%i in (*) do (
    echo Creating mbtile for %%~ni.geojson
    docker run -it --rm -v %CD%:/data -v %out%\polygon:/dataout tippecanoe:latest tippecanoe %tippecanoe%
)
for /D %%d in (*) do (
    cd %%d
    call :treeProcess
    cd ..
)
exit /b


REM move %geojson%*.mbtiles %out%\polygon\
