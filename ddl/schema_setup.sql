-- Creating schema with default privileges
DROP SCHEMA IF EXISTS MySchema CASCADE;
CREATE SCHEMA MySchema AUTHORIZATION postgres;
ALTER DEFAULT PRIVILEGES IN SCHEMA MySchema GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO MyUser/MyRole;
GRANT USAGE ON SCHEMA MySchema TO MyUser/MyRole;
