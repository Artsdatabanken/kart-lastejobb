# run.bat
* Runs import and export

# geojsonPropertiesTagger.py
* Moves all codes from arrays to tags in geojson
## Usage
```python .\geojsonPropertiesTagger.py $input $output```
# import.bat
* Drops database
* Creates database
* Runs all fme-jobs for import
* Runs post-processing of database
  * Populates web-mercator geometry
  * Clusters database
  * Vacuums and analyzes database
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
