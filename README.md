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

# Handling Postgres logs

Log into the server where postgres is running

**Get the latest log filename**
```
sudo ls -lah /var/lib/postgresql/9.6/main/pg_log
```
**Get last 200 rows from the latest log**
-n - number of rows at the end
-f - "follow", continues to add lines into printout
```
sudo tail -n 200 /var/lib/postgresql/9.6/main/pg_log/postgresql-2018-08-14_000000.log 
sudo tail -f 100 /var/lib/postgresql/9.6/main/pg_log/postgresql-2019-09-06_000000.log
```

**Search specific words from postgres file**
```
sudo grep 'starting\|finished' /var/lib/postgresql/9.6/main/pg_log/postgresql-2019-09-05_100807.log
```

# Database handling
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

## Look access right to view/table
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
```

## Creating and maintaining user
Remove certain role from a user
```sql
REVOKE myRole FROM myUser
```

Removing user from database
```sql
DROP OWNED BY myUser;
DROP USER myUser;
```

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

Create schema for a user
```sql
CREATE SCHEMA "my.username"  AUTHORIZATION "my.surname";
```

Grant usage for a schema. This grants rights to see tables under that schema.
```sql
GRANT USAGE ON SCHEMA someSchema TO myUser;
```

Grant select on all tables
```sql
GRANT SELECT ON ALL TABLES IN SCHEMA mySchema TO myRole/myUser ;
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
