-- terminate all connections from current database
SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'my_current_database' AND pid <> pg_backend_pid();

CREATE DATABASE my_new_db WITH TEMPLATE my_current_database [OWNER myUser];