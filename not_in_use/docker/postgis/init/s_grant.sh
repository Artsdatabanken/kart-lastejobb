echo "GRANT USAGE ON SCHEMA data TO reader;
GRANT USAGE ON SCHEMA public TO reader;

GRANT SELECT ON ALL TABLES IN SCHEMA data TO reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO reader;

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO reader;"|psql -U postgres -d bigbadabom