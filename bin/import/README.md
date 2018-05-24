# run.bat

Runs all batch-files

* Drops database
* Creates database
* Runs all fme-jobs for import
* Runs post-processing of database
  * Populates web-mercator geometry
  * Clusters database
  * Vacuums and analyzes database