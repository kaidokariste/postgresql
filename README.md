# Structure and content description

| Folder        | Subfolders | Description  |
| ------------- |:-------:| -------------------------|
| DML           | -       | SELECT, UPDATE, INSERT, DELETE, MERGE |
| DDL           | -       | CREATE, ALTER, DROP. RENAME, TRUNCATE, COMMENT |
| DCL           | -       | GRANT, REVOKE |
| TCL           | -       | COMMIT, ROLLBACK, SAVEPOINT |
| FUNC          | -       | Functions and anonymous blocks |


# Definitions
**User** - A database user is a person who can log on to the database.

**Schema** - A database schema is all the objects in the database owned by one user.

**Data Manipulation Language (DML)** -used for selecting, inserting, deleting and updating data in a database

**Data Definition Language (DDL)** - used for defining data structures, especially database schemas

**Data Control Language (DCL)** - used to control access to data stored in a database.

**Transaction Control Language (TCL)** - used to control transaction behaviour in database.

**Index** - schema object that contains an entry for each value that appears in the indexed column(s) of the table or cluster and provides direct, fast access to rows.

# Database handling

## PSQL
`\l+` - list databases  
`\c cycling` - connect database "cycling"  
`\dn+` - list schemas  
`\dt uci.*` - list all tables under schema UCI  
`systemctl start|stop|restart|status postgresql-14.service` - Systemctl status.

## Connecting to database
1. Open Power Shell terminal
2. Using CD command go to folder where psql.exe is istalled. For example: ```cd C:\Program Files\pgAdmin III\1.22>``` To get help ```.\psql.exe --help```
3. Connect database: ```.\psql.exe -U myusername -d mydatabase -h mydbserver```  
Example call for procedure  
```psql -U myusername -d mydatabase -h myserver -c "CALL \"kaido.kariste\".insert_something(table:='public.some_table', chunk_size := 250000, collection_time := '1440 minutes');"```



## Connect database inside docker container
```bash
$ docker run -i -t <docker-image-code> /bin/bash
$ service postgresql status
$ service postgresql start
$ ps aux
$ su - postgres
$ psql
    postgres# \connect MyDatabase

```

# Handling Postgres logs

Log into the server where postgres is running

**Get the latest log filename**
```
sudo ls -lah /var/lib/postgresql/14/data/pg_log
```
**Get last 200 rows from the latest log**
-n - number of rows at the end
-f - "follow", continues to add lines into printout
```
sudo tail -n 200 /var/lib/postgresql/9.6/main/pg_log/postgresql-2018-08-14_000000.log 
sudo tail -f 100 /var/lib/postgresql/9.6/main/pg_log/postgresql-2019-09-06_000000.log
```

```
/var/lib/postgresql/14/data/pg_log
# Grep specific string
-bash-4.2$ grep "2023-02-10 10:59:*" postgresql-2023-02-10_000000.log
```

**Search specific words from postgres file**
```
sudo grep 'starting\|finished' /var/lib/postgresql/9.6/main/pg_log/postgresql-2019-09-05_100807.log
```

## Looking database parameters

Look database version
```sql
SELECT version(); --Database version
SELECT pg_postmaster_start_time(); --Server starttime
SELECT * FROM pg_stat_activity; -- Users activity statistics
```

Find top 20 largest databases in your cluster
```sql
SELECT d.datname as Name,  pg_catalog.pg_get_userbyid(d.datdba) as Owner,
    CASE WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT')
        THEN pg_catalog.pg_size_pretty(pg_catalog.pg_database_size(d.datname))
        ELSE 'No Access'
    END as Size
FROM pg_catalog.pg_database d
    order by
    CASE WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT')
        THEN pg_catalog.pg_database_size(d.datname)
        ELSE NULL
    END desc -- nulls first
    LIMIT 20
```

## Executing file trough commandline

In some cases we need to execute sql file directly in command line. For such cases you need  program called ```psql``` that for Windows machines is available trough pgAdmin III client.

- If the file you want to execute is in the same folder, then the syntax in Windows is: ``` C:\Program Files\pgAdmin III\1.22> .\psql.exe -U "my.username" -d mydatabase -h myserver -f hello_terminal.sql ```

- If the file is somewhere else, then you have to insert full path ```C:\Program Files\pgAdmin III\1.22> .\psql.exe -U myusername -d mydatabase -h myserver -f "C:\Users\my.user\Documents\hello_terminal.sql" ```

## Show hba, configuration and data directory path
```sql
SHOW hba_file;
-- Reload configuration file after changes
SELECT pg_reload_conf();

SHOW config_file;
SHOW data_directory;
```

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

## Lookup trigger status
```sql
SELECT pg_namespace.nspname, pg_class.relname, pg_trigger.tgname, pg_trigger.tgenabled
FROM pg_trigger
JOIN pg_class ON pg_trigger.tgrelid = pg_class.oid
JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace;
```

## Lookup of some specific table (currently foreign table)
```sql
SELECT *
FROM information_schema.tables
WHERE table_type = 'FOREIGN TABLE'
```

## Foreign table owners
```sql
SELECT
  oid::regclass,
  pg_get_userbyid(relowner)
FROM pg_class
WHERE relkind = 'f';
```

## Foreign server information lookup  
```sql
SELECT srvname, srvoptions, um.*,rolname
  FROM pg_user_mapping um
  JOIN pg_roles r ON r.oid = umuser
  JOIN pg_foreign_server fs ON fs.oid = umserver;
```

## Lookup of specific column
```sql
SELECT c.relname, a.attname
FROM pg_class AS c
INNER JOIN pg_attribute AS a ON a.attrelid = c.oid
WHERE a.attname LIKE 'myColumnThatIsearch'
AND c.relkind = 'r';
```

## Look up size of database, grouped by schemas
```sql
SELECT table_schema,
     pg_size_pretty(sum(total_bytes)) AS total
    , pg_size_pretty(sum(index_bytes)) AS INDEX
    , pg_size_pretty(sum(toast_bytes)) AS toast
    , pg_size_pretty(sum(table_bytes)) AS TABLE
  FROM (
  SELECT *, total_bytes-index_bytes-COALESCE(toast_bytes,0) AS table_bytes FROM (
      SELECT c.oid,nspname AS table_schema, relname AS TABLE_NAME
              , c.reltuples AS row_estimate
              , pg_total_relation_size(c.oid) AS total_bytes
              , pg_indexes_size(c.oid) AS index_bytes
              , pg_total_relation_size(reltoastrelid) AS toast_bytes
          FROM pg_class c
          LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
          WHERE relkind = 'r'
  ) a
) a
where table_schema in ('MySchema')
group by table_schema
having sum(total_bytes) > 1000000
order by sum(total_bytes) desc;
```

## Lookup size of table
```sql
SELECT nspname || '.' || relname               AS "relation",
       pg_size_pretty(pg_relation_size(C.oid)) AS "size"
FROM pg_class C
LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
WHERE nspname NOT IN ('pg_catalog', 'information_schema')
  AND relname LIKE '%table%'
ORDER BY pg_relation_size(C.oid) DESC
```

## Top 10 largest tables
```sql
select schemaname as table_schema,
    relname as table_name,
    pg_size_pretty(pg_total_relation_size(relid)) as total_size,
    pg_size_pretty(pg_relation_size(relid)) as data_size,
    pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid))
      as external_size
from pg_catalog.pg_statio_user_tables
order by pg_total_relation_size(relid) desc,
         pg_relation_size(relid) desc
limit 10;
```

## List materialized views
```sql
select schemaname as schema_name,
       matviewname as view_name,
       matviewowner as owner,
       ispopulated as is_populated,
       definition
from pg_matviews
order by schema_name,
         view_name;
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

## Look inheritance and partitions of the tables
```sql
SELECT nmsp_parent.nspname AS parent_schema,
       parent.relname      AS parent,
       nmsp_child.nspname  AS child_schema,
       child.relname       AS child
FROM pg_inherits
JOIN pg_class parent
  ON pg_inherits.inhparent = parent.oid
JOIN pg_class child
  ON pg_inherits.inhrelid   = child.oid
JOIN pg_namespace nmsp_parent
  ON nmsp_parent.oid  = parent.relnamespace
JOIN pg_namespace nmsp_child
  ON nmsp_child.oid   = child.relnamespace
WHERE parent.relname ilike '%my_table%';
```

```sql
SELECT c.relname AS child, p.relname AS parent
FROM
    pg_inherits JOIN pg_class AS c ON (inhrelid=c.oid)
    JOIN pg_class as p ON (inhparent=p.oid)
where p.relname like 'customer%';
```

```sql
with recursive inhh(poid, seqn, ordn) as (
    select cl.oid as poid, 0 as seqn, 0 as ordn
      from pg_class cl, pg_namespace n
     where cl.relnamespace = n.oid
       and n.nspname = '<schemaname>'
       and cl.relname = '<tablename>'
     union all
    SELECT pi.inhrelid, pi.inhseqno, ordn + 1 as orderno
      FROM pg_inherits pi, inhh where pi.inhparent = inhh.poid
) SELECT n.nspname, cl.relname, inhh.seqn, inhh.ordn
    from inhh, pg_class cl, pg_namespace n
   where cl.oid = inhh.poid and n.oid = cl.relnamespace;
```

```sql
SELECT inhparent::regclass::TEXT, COUNT(*) AS partitions
FROM pg_catalog.pg_inherits
WHERE inhparent::REGCLASS::TEXT NOT LIKE '%idx%'
  AND inhparent::REGCLASS::TEXT NOT LIKE '%pkey%'
  AND inhparent::REGCLASS::TEXT NOT LIKE '%index%'
GROUP BY inhparent
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

## Change timezone
```sql
SHOW TIMEZONE;
SET TIME ZONE 'Europe/Tallinn';
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

## Look access right to view/table and table owner
```
select
    coalesce(nullif(s[1], ''), 'public') as grantee,
    s[2] as privileges
from
    pg_class c
    join pg_namespace n on n.oid = relnamespace
    join pg_roles r on r.oid = relowner,
    unnest(coalesce(relacl::text[], format('{%s=arwdDxt/%s}', rolname, rolname)::text[])) acl,
    regexp_split_to_array(acl, '=|/') s
where relname = 'myView';

select * from pg_tables
where tablename = 'tablename'
```

## Creating and maintaining user
Create user with password or alter password
```sql
CREATE USER <username> WITH ENCRYPTED PASSWORD '<password>';
ALTER USER <username> WITH encrypted PASSWORD '<password>';
```

Remove certain role from a user
```sql
REVOKE myRole FROM myUser
```

Removing user from database
```sql
DROP OWNED BY myUser;
DROP USER myUser;
```

Remove login right from user
```sql
ALTER USER myUser NO LOGIN
```

Grant some specific role to a user
```sql
GRANT myRole TO myUser
```

Create new user with login option
```sql
CREATE USER myUser WITH LOGIN
```

List all schemas and owners
```sql
SELECT
  n.nspname AS schema_name,
  pg_catalog.PG_GET_USERBYID(n.nspowner) AS schema_owner
FROM pg_catalog.pg_namespace n
WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
and nspname not ilike 'pg%'
ORDER BY schema_name;
```

Create schema for a user
```sql
CREATE SCHEMA "my.username"  AUTHORIZATION "my.surname";
```

Grant usage for a schema. This grants rights to see tables under that schema.
```sql
GRANT USAGE ON SCHEMA someSchema TO myUser;
```

Grant select on all tables or reassign ownership
```sql
GRANT SELECT ON ALL TABLES IN SCHEMA mySchema TO myRole/myUser ;
REASSIGN OWNED BY oldUser TO newUser;
```

Find and modify hba conf file
```sql
SHOW hba_file; -- shows path of hba file
SELECT pg_reload_conf(); -- reload conf file after changes
```

```sql
-- replica identity
-- https://www.postgresql.org/docs/current/sql-altertable.html#SQL-ALTERTABLE-REPLICA-IDENTITY
create temporary table rep as
SELECT oid::regclass::text,
      CASE relreplident
          WHEN 'd' THEN 'default'
          WHEN 'n' THEN 'nothing'
          WHEN 'f' THEN 'full'
          WHEN 'i' THEN 'index'
       END AS replica_identity
FROM pg_class;
```

Look tables in replication set  
```sql
select *
from pglogical.replication_set rs
join pglogical.replication_set_table rst using (set_id)
where set_name like '%myset%'
```
# Logging levels
Possible levels with RAISE are **DEBUG, LOG, NOTICE, WARNING, INFO and EXCEPTION**. EXCEPTION raises an error (which normally aborts the current transaction). INFO is passed always to STDOUT, despite the level. The other levels only generate messages of different priority levels. The higher the level, the less it shows. Example if you set log level WARNING, then DEBUG, LOG and NOTICE levels are not shown in console (STDOUT). 

client_min_messages(string): Controls which message levels are sent to the client STDOUT.
```sql
show client_min_messages;

client_min_messages
------------------------------
notice
(1 row)
```

log_min_messages(string): Controls which message levels are written to the server log.
```sql
show log_min_messages;

log_min_messages
------------------------------
warning
(1 row)
```
## Changing for session
```sql
show client_min_messages;
set client_min_messages = debug;
```


# Optimization

You can use the **EXPLAIN** command to see what query plan the planner creates for any query. Plan-reading is an art that 
requires some experience to master, but this section attempts to cover the basics.

For the sake of demo, let's execute simplest query we can think
```sql
EXPLAIN SELECT 1;
```
The result would be
```
Result  (cost=0.00..0.01 rows=1 width=4)
```
The numbers that are quoted in parentheses are (left to right):
- ***Estimated start-up cost*** - This is the time expended before the output phase can begin, e.g., time to do the sorting in a sort node.
- ***Estimated total cost*** - This is stated on the assumption that the plan node is run to completion, i.e., all available rows are retrieved. In practice a node's parent node might stop short of reading all available rows (see the LIMIT example below).
- ***Estimated number of rows output by this plan node*** Again, the node is assumed to be run to completion.
- ***Estimated average width of rows*** output by this plan node (in bytes).
Often cost is thought as milliseconds. *The costs are measured in arbitrary units determined by the planner's cost parameters.*
You can take this query as base that basically doesn't cost anything to computer.
Now, let's query something from a table.
```sql
EXPLAIN SELECT * FROM customer;
```
The result is 
```
Seq Scan on customer  (cost=0.00..137165.23 rows=2200423 width=1599)
```
Since this query has no WHERE clause, it must scan all the rows of the table, so the planner has chosen to use a simple sequential scan plan. 

***[Full Table Scan](https://en.wikipedia.org/wiki/Full_table_scan)*** (also known as ***Sequential Scan***) is a scan made on a database where each row of the table under scan is read in a sequential (serial) order and the columns encountered are checked for the validity of a condition. 
Full table scans are usually the slowest method of scanning a table due to the heavy amount of I/O reads required from the disk which consists of multiple seeks as well as costly disk to memory transfers.

**Pros:**
- The cost is constant, as every time database system needs to scan full table row by row.
- When table is less than 2 percent of database block buffer, the full scan table is quicker.

**Cons:**
- Full table scan occurs when there is no index or index is not being used by SQL. And the result of full scan table is usually slower that index table scan. The situation is that: the larger the table, the slower of the data returns.
- Unnecessary full-table scan will lead to a huge amount of unnecessary I/O with a process burden on the entire database.

Total cost is calculated as:
```
SELECT relpages, reltuples FROM pg_class WHERE relname = 'customer';
```
According to this *customer* has 115161 disk pages and 2200423 rows (*tuples*). By default *seq_page_cost* is 1.0 and 
*cpu_tuple_cost* 0.1, so estimated cost is (115161x1,0)+(2200423x0,01) = 137165.23

To analyze time, we should use key word ANALYZE
```sql
EXPLAIN ANALYZE SELECT * FROM customer;
```
The result would be
```
Seq Scan on customer  (cost=0.00..137165.23 rows=2200423 width=1599) (actual time=0.011..2168.645 rows=2204137 loops=1)
Planning time: 0.151 ms
Execution time: 2245.405 ms
```
Total expected time would be 2.2 seconds

## Terms we may see in queryplanner
### Join Operations
Generally join operations process only two tables at a time. In case a query has more joins, they are executed sequentially: first two tables, then the intermediate result with the next table. In the context of joins, the term “table” could therefore also mean “intermediate result”.

**Nested Loops**
Joins two tables by fetching the result from one table and querying the other table for each row from the first. 

**[Hash Join / Hash](https://use-the-index-luke.com/sql/join/hash-join-partial-objects)**
The hash join loads the candidate records from one side of the join into a hash table (marked with Hash in the plan) which is then probed for each record from the other side of the join.

**[Merge Join](https://use-the-index-luke.com/sql/join/sort-merge-join)**
The (sort) merge join combines two sorted lists like a zipper. Both sides of the join must be presorted. 

## Index and table access
**Seq Scan**
The Seq Scan operation scans the entire relation (table) as stored on disk (like TABLE ACCESS FULL).

**Bitmap Index Scan / Bitmap Heap Scan / Recheck Cond**

A plain Index Scan fetches one tuple-pointer at a time from the index, and immediately visits that tuple in the table. A bitmap scan fetches all the tuple-pointers from the index in one go, sorts them using an in-memory "bitmap" data structure, and then visits the table tuples in physical tuple-location order.
