# Data Warehouse Beginners course

## Study Drills

### Exercise 1 - Character types
1. Above each line write out in English what that line does.
2. Put every statement a column alias
3. Read trough small paragraph about ["dollar quoting"](https://www.postgresql.org/docs/9.4/static/sql-syntax-lexical.html)

### Exercise 2 - String functions and operators
1. Above each line write out in English what that line does.
2. Make sure every statement has column aliases.
3. Look over other [string functions and operators](https://www.postgresql.org/docs/9.4/static/functions-string.html). Choose **5** that seems to be more interesting and try to use them.

### Exercise 3 - Date/Time functions and operators
1. Above each line write out in English what that line does.
2. Make sure every statement has column aliases.
3. Try to extract also day, hour, minute, month, quarter, second, week,
3. Find out what is _epoch_ and what does the number show? How can it be useful?
4. How are _dow_ and _isodow_ different?
5. Try to use millennium as extract string. What are the results?
6. Try to truncate also date for hours, minutes? Explain when could it be useful?

### Exercise 4 - Date and time calculations
1. Above each line write out in English what that line does.
2. Make sure every statement has column aliases.
3. Look over other [date and time functions and operators](https://www.postgresql.org/docs/9.1/static/functions-datetime.html). Choose *2* from Table 9-27. and add to your exercise file.
4. Think how to calculate time difference in seconds. 

### Exercise 5 - Formatting functions
1. Execute following script : ```select to_char(current_timestamp, 'Y Day BC IDD RM Q WW CC') ``` and try to find from [official documentation](https://www.postgresql.org/docs/9.5/static/functions-formatting.html) what every part in conversion mask means.
 2. Using only this number: 1000 form this string **0010,00.0mM**. Using only data type formatting functions.
 
 ### Exercise 6 - Data Definition Language
 > DDL (Data Definition Language) is for defining data stuctures (tables, schemas etc.) DDL statements are CREATE, DROP, ALTER, RENAME, TRUNCATE.
 
 1. If you have table containing 100 000 rows and you would like to clean it up? Which one will is better to use - DELETE or TRUNCATE
 
 2. Can you DROP a table if it contains a data? 
 
 ### Exercise 7 - More about data types
 1. Look over possible [numeric types](https://www.postgresql.org/docs/9.1/static/datatype-numeric.html) in Postgres. Why is the range of ```smallint``` between -32768 to +32767.
 
2. How much do you choose for *precision* and for *scale* so number **12345,67** could fit to column?
 
 
 