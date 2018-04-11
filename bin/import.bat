python pgSqlExecutor.py ..\sql\drop.sql ..\config\postgis.json

python pgSqlExecutor.py ..\sql\schema.sql ..\config\postgis.json

cd ..\fme\in

for %%f in (*.fmw) do fme.exe %%f

cd ..\..\bin

python pgSqlExecutor.py ..\sql\post-process.sql ..\config\postgis.json

python pgSqlExecutor.py ..\sql\vacuum.sql ..\config\postgis.json