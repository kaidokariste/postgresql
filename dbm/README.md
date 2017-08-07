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

## Kill stuck process
```sql
SELECT pg_cancel_backend(<pid>) -- Tries to cancel first the process
SELECT pg_terminate_backend(<pid>); -- Terminate
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
