python .\codes.py ..\..\config\postgis.json

python ..\pgSqlExecutor.py ..\..\sql\post-process.sql ..\..\config\postgis.json

python ..\pgSqlExecutor.py ..\..\sql\reader.sql ..\..\config\postgis.json

python ..\pgSqlExecutor.py ..\..\sql\vacuum.sql ..\..\config\postgis.json

"C:\Program Files\PostgreSQL\10\bin\pg_dump.exe" -U postgres --no-password --format=c --file=d:\out\db\bigbadabom.backup bigbadabom

python ..\pgSqlExecutor.py ..\..\sql\geometry_view.sql ..\..\config\postgis.json

python ..\pgSqlExecutor.py ..\..\sql\vacuum.sql ..\..\config\postgis.json

REM D:\install\redList\Redlist.exe ..\..\config\postgis.json

