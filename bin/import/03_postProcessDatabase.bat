python ..\pgSqlExecutor.py ..\..\sql\post-process.sql ..\..\config\postgis.json

python ..\pgSqlExecutor.py ..\..\sql\vacuum.sql ..\..\config\postgis.json

python ..\pgSqlExecutor.py ..\..\docker\postgis\init\3_reader.sql ..\..\config\postgis.json

python ..\pgSqlExecutor.py ..\..\docker\postgis\init\grant.txt ..\..\config\postgis.json

python ..\pgSqlExecutor.py ..\..\sql\geometry_view.sql ..\..\config\postgis.json