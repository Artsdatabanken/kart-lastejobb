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