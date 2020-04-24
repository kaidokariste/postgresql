-- Postgres foreign data wrapper
-- Check installed extencions
SELECT * FROM pg_extension;

-- Check out existing foreign servers
SELECT * FROM pg_foreign_server;

-- Setting up postgres_fdw
DROP EXTENSION IF EXISTS postgres_fdw CASCADE;
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- Create server definition
DROP SERVER IF EXISTS pam_db CASCADE;

CREATE SERVER pam_db
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS ( host 'myHost', dbname 'myDb', port '5432' );

-- Drop also removes the foreign table. If you want to update server definiton then
ALTER SERVER pam_db OPTIONS (SET address 'new-pamdb-host-address');

DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER pam_db;
CREATE USER MAPPING FOR CURRENT_USER
    SERVER pam_db
    OPTIONS (USER :'user', PASSWORD :'password');

-- Look over mappings and servers
SELECT srvname, um.*,rolname
  FROM pg_user_mapping um
  JOIN pg_roles r ON r.oid = umuser
  JOIN pg_foreign_server fs ON fs.oid = umserver;


-- MySQL Foreign data wrapper

-- Prerequsite is that mysql_fdw has been installed in server side
-- In case of debian:
-- > sudo apt install postgresql-9.6-mysql-fdw
DROP EXTENSION IF EXISTS mysql_fdw CASCADE;
CREATE EXTENSION IF NOT EXISTS mysql_fdw;

-- Mysql server connection in migration postgresql server to retrive stage1 data
DROP SERVER IF EXISTS mysql_server CASCADE;

CREATE SERVER mysql_server
    FOREIGN DATA WRAPPER mysql_fdw
    OPTIONS (host 'hostInMySQL',port '3306',secure_auth 'true');

-- User who reads data from foreign tables needs mapping between postgresql and mysql user
CREATE USER MAPPING FOR "myUserInPostgres"
    SERVER mysql_server
    OPTIONS (username 'myUserInMySql', PASSWORD '<secret>');

-- import whole schema from mysql to determined schema in postgres
IMPORT FOREIGN SCHEMA mySqlDatabaseName
    FROM SERVER mysql_server INTO public;
