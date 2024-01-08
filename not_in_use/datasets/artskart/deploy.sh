ls -lr data
#sqlite3 ruter.25m.3857.mbtilesx "SELECT zoom_level, count(*) from tiles group by zoom_level;"
scp -r data/* grunnkart@hydra:~/tilesdata/
