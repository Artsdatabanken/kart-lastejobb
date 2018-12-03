ALTER SYSTEM SET work_mem = '2097151';
ALTER SYSTEM SET maintenance_work_mem = '2097151';
ALTER SYSTEM SET max_worker_processes = 8;
ALTER SYSTEM SET max_parallel_workers_per_gather = 8;
SELECT pg_reload_conf();
