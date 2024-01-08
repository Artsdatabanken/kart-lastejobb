# run.bat
* Runs import and export
# geojsonPropertiesTagger.py
* Moves all codes from arrays to tags in geojson
## Usage
```python .\geojsonPropertiesTagger.py $input $output```
# pgSqlExecutor.py
* Runs sql on postgresql-database
## Usage
```python .\pgSqlExecutor.py $sql-file $config-file```
## Config
The config is a json-file following this structure:
```
{
    "db": "databaseName",
    "host": "hostName",
    "port": "portNumber",
    "pass": "password",
    "user": "userName"
}
```
