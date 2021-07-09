/*
HOST_SERVER - where the original data is, where we wnat to connect
MY_SERVER - where we create mapping and connection

1. You need database user in HOST_SERVER database against what you will do the mapping
*/

-- Postgres foreign data wrapper
-- Check installed extencions in HOST_SERVER. It should have extension postgres_fdw
SELECT * FROM pg_extension;

-- Check out existing foreign servers in MY_SERVER
SELECT * FROM pg_foreign_server;

-- Setting up postgres_fdw
DROP EXTENSION IF EXISTS postgres_fdw CASCADE;
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- Create server definition in MY_SERVER called "connect_to_host_db"
DROP SERVER IF EXISTS connect_to_host_db CASCADE;

CREATE SERVER connect_to_host_db
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS ( host 'HOST_SERVER_ADDRESS', dbname 'HOST_DB', port '5432' );

-- Drop also removes the foreign table. If you want to update server definiton then
ALTER SERVER connect_to_host_db OPTIONS (SET address 'new-pamdb-host-address');

-- User mapping works so that you map user in MY_SERVER database against created user HOST_SERVER database
-- https://www.postgresql.org/docs/12/sql-createusermapping.html
DROP USER MAPPING IF EXISTS FOR {user_name| CURRENT_USER } SERVER connect_to_host_db;

CREATE USER MAPPING FOR {user_name | CURRENT_USER }
    SERVER connect_to_host_db
    OPTIONS (USER 'HOST_SERVER_USER', PASSWORD 'password');

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
