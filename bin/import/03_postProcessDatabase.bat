python ..\pgSqlExecutor.py ..\..\sql\post-process.sql ..\..\config\postgis.json

python ..\pgSqlExecutor.py ..\..\sql\vacuum.sql ..\..\config\postgis.json

python ..\pgSqlExecutor.py ..\..\sql\reader.sql ..\..\config\postgis.json

python ..\pgSqlExecutor.py ..\..\sql\geometry_view.sql ..\..\config\postgis.json