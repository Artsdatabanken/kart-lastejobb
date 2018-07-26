# Qué es?
Docker container for bigbadabom-database
* Gets database from host folder and restores it in container on startup
* Exposes port 5432
* Adds reader-user for database

# Uso
```
docker build postgis
docker run -p 5432:5432 -v ${hostFolderContainingBackupFile}:/data ${image}
```
