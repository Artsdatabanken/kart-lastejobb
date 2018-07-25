FROM mdillon/postgis
RUN echo 'echo CREATE DATABASE bigbadabom | psql postgres;' > /docker-entrypoint-initdb.d/restore.sh \
 && echo 'pg_restore -d bigbadabom /data/bigbadabom.backup' >> /docker-entrypoint-initdb.d/restore.sh \
 && chmod +x /docker-entrypoint-initdb.d/restore.sh