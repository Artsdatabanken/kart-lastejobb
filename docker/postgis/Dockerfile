FROM mdillon/postgis
RUN echo 'pg_restore -C /data/bigbadabom.backup' > /docker-entrypoint-initdb.d/restore.sh \
 && chmod +x /docker-entrypoint-initdb.d/restore.sh