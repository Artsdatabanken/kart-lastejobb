python ..\sql\pgSqlExecutor.py ..\sql\bigbadabom.sql ..\config\postgis.json

for %%f in (..\fme\*.fmw) do fme.exe %%f

python ..\sql\pgSqlExecutor.py ..\sql\post-process.sql ..\config\postgis.json