set out=D:\out\
set web=\\IT-WEBADBTEST01\data\

for /D %%i in (%out%*) do (
    mkdir %web%%%~ni\
    copy %%i\*.* %web%%%~ni\
    for /D %%y in (%%i\*) do (
        mkdir %web%%%~ni\%%~ny\
        copy %%y\*.* %web%%%~ni\%%~ny\
    )
)

C:\Program Files (x86)\pgAdmin 4\v3\runtime\pg_dump.exe --file "\\\\IT-WEBADBTEST01\\data\\db\\bigbadabom.backup" --host "localhost" --port "5432" --username "postgres" --no-password --verbose --format=c --blobs --encoding "UTF8" "bigbadabom"