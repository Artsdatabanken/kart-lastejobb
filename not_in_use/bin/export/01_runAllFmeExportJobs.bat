cd ..\..\fme\out

for %%f in (*.fmw) do fme.exe %%f
REM fme.exe 0_masterExport.fmw

cd ..\..\bin\export