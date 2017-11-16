## Connecting to database
1. Open Power Shell terminal
2. Using CD command go to folder where psql.exe is istalled. For example: ```cd C:\Program Files\pgAdmin III\1.22>``` To get help ```.\psql.exe --help```
3. Connect database: ```.\psql.exe -U myusername -d mydatabase -h mydbserver```

## Looking database parameters

Look database version
```sql
SELECT version(); --Database version
SELECT pg_postmaster_start_time(); --Server starttime
SELECT * FROM pg_stat_activity; -- Users activity statistics
```

## Executing file trough commandline

In some cases we need to execute sql file directly in command line. For such cases you need  program called ```psql``` that for Windows machines is available trough pgAdmin III client.

- If the file you want to execute is in the same folder, then the syntax in Windows is: ``` C:\Program Files\pgAdmin III\1.22> .\psql.exe -U "my.username" -d mydatabase -h myserver -f hello_terminal.sql ```

- If the file is somewhere else, then you have to insert full path ```C:\Program Files\pgAdmin III\1.22> .\psql.exe -U myusername -d mydatabase -h myserver -f "C:\Users\my.user\Documents\hello_terminal.sql" ```

## Show active processes
```sql
SELECT
  client_port,
  datid,
  datname,
  pid,
  usesysid,
  usename,
  application_name,
  client_addr,
  client_hostname,
  state,
  query
FROM pg_stat_activity
WHERE state = 'active';
```

## Show conflict locks
```sql
SELECT blocked_locks.pid     AS blocked_pid,
         blocked_activity.usename  AS blocked_user,
         blocking_locks.pid     AS blocking_pid,
         blocking_activity.usename AS blocking_user,
         blocked_activity.query    AS blocked_statement,
         blocking_activity.query   AS current_statement_in_blocking_process,
         blocked_activity.application_name AS blocked_application,
         blocking_activity.application_name AS blocking_application
   FROM  pg_catalog.pg_locks         blocked_locks
    JOIN pg_catalog.pg_stat_activity blocked_activity  ON blocked_activity.pid = blocked_locks.pid
    JOIN pg_catalog.pg_locks         blocking_locks
        ON blocking_locks.locktype = blocked_locks.locktype
        AND blocking_locks.DATABASE IS NOT DISTINCT FROM blocked_locks.DATABASE
        AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
        AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
        AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
        AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
        AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
        AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
        AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
        AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
        AND blocking_locks.pid != blocked_locks.pid
     JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
   WHERE NOT blocked_locks.GRANTED;
```


## Kill stuck process
```sql
SELECT pg_cancel_backend(<pid>) -- Tries to cancel first the process
SELECT pg_terminate_backend(<pid>); -- Terminate
```

## Lookup of some specific table (currently foreign table)
```sql
SELECT *
FROM information_schema.tables
WHERE table_type = 'FOREIGN TABLE'
```

## Look column description of a table

```sql
SELECT
 relname as table,
 attname as column,
 description
FROM pg_description
 JOIN pg_attribute t1 ON t1.attrelid = pg_description.objoid AND pg_description.objsubid = t1.attnum
 JOIN pg_class ON pg_class.oid = t1.attrelid;
 ```

 ## Look function description and code
```sql
SELECT
  r0.OID,
  proname,
  description,
  prosrc
FROM pg_proc r0
  LEFT JOIN pg_description r1 ON r1.objoid = r0.oid
WHERE proname = 'my_function'
ORDER BY proname;
```

## Look column data type and parameters
```sql
SELECT *
FROM information_schema.columns
WHERE table_name = 'my_table';
```

## Look user groups and roles
```sql
SELECT
  r.rolname,
  r.rolsuper,
  r.rolinherit,
  r.rolcreaterole,
  r.rolcreatedb,
  r.rolcanlogin,
  r.rolconnlimit,
  r.rolvaliduntil,
  ARRAY(SELECT b.rolname
        FROM pg_catalog.pg_auth_members m
          JOIN pg_catalog.pg_roles b ON (m.roleid = b.oid)
        WHERE m.member = r.oid)                    AS memberof,
  pg_catalog.shobj_description(r.oid, 'pg_authid') AS description,
  r.rolreplication,
  r.rolbypassrls
FROM pg_catalog.pg_roles r
WHERE r.rolname !~ '^pg_'
ORDER BY 1;
```

## Creating and maintaining user
Remove certain role from a user
```sql
REVOKE myRole FROM myUser
```

```sql
DROP OWNED BY myUser
```

```sql
ALTER USER myUser NO LOGIN
```

```sql
GRANT myRole TO myUser
```

Create new user with login option
```sql
CREATE USER myUser WITH LOGIN
```

Create schema for a user
```sql
CREATE SCHEMA "my.username"  AUTHORIZATION "my.surname";
```
