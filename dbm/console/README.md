## Connecting to database
1. Open Power Shell terminal
2. Using CD command go to folder where psql.exe is istalled. For example: ```cd C:\Program Files (x86)\pgAdmin III\1.22>``` To get help ```.\psql.exe --help```
3. Connect database: ```.\psql.exe -U myusername -d mydatabase -h mydbserver```

## Executing file trough commandline

In some cases we need to execute sql file directly in command line. For such cases you need  program called ```psql``` that for Windows machines is available trough pgAdmin III client.

- If the file you want to execute is in the same folder, then the syntax in Windows is:
``` C:\Program Files\pgAdmin III\1.22> .\psql.exe -U "my.username" -d mydatabase -h myserver -f hello_terminal.sql ```

- If the file is somewhere else, then you have to insert full path
```PS C:\Program Files\pgAdmin III\1.22> .\psql.exe -U myusername -d mydatabase -h myserver -f "C:\Users\my.user\Documents\hello_terminal.sql"```
