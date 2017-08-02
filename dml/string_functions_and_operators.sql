-- String functions and operators
SELECT 'I am official mascot of' || concat('The ', 'Walt ', 'Disney ', 'Company') AS mickey_mouse;
SELECT 'My ' || 'friends ' || 'are ' || concat_ws(',', 'Donald Duck', 'Goofy') AS my_friends;
SELECT format('My girlfriend name is %s', 'Minnie Mouse') AS girlfriend;
SELECT 'My first name is ' || length('Mickey') || ' letters long.' AS length_first_name;
SELECT format('My second name is %s letters long.', char_length('Mouse'));
SELECT 'My first appearance was in movie ' || quote_ident('Steamboat Willie') || ' on year 1928';
SELECT 'This means that I am ' || age(TIMESTAMP '1928-11-21') || ' old' AS my_age;
SELECT 'Value: ' || 42 / 2; -- concating the number

-- Attention: concating NULL will result NULL
SELECT 'One Flew Over ' || NULL || ' the Cuckoo Nest';

/*
Concatenate all but first arguments with separators.
The first parameter is used as a separator. NULL arguments are ignored.
*/

SELECT concat_ws(';', 'One', 'Flew', 'Over', NULL, 'Cuckoo Nest');

-- String conversion functions
SELECT
  lower('HI TOM'),
  upper('hi tom'),
  initcap('hi tom');
-- Result:  "hi tom";"HI TOM";"Hi Tom"

/*String calculation*/
SELECT char_length('Waterloo'); --8
SELECT length(1800 + 15 || 'Kaido'); -- 9
SELECT bit_length('Waterloo'); -- 64
SELECT strpos('Waterloo', 'er'); --4
SELECT substr('KaidoKariste', 7, 4); -- aris

-- Padding and trimming

SELECT lpad('PASSW', 11, '#'); --  "######PASSW"
SELECT rpad('PASSW', 11, '#'); -- "PASSW######"
SELECT trim('#' FROM '###PASSWORD###') -- PASSWORD
SELECT trim(TRAILING 'e' FROM 1 + 2.14 || ' is pie') -- Result: "3.14 is pi"
SELECT trim(BOTH '*' FROM '*******Hidden*******') -- Result: Hidden
SELECT TRIM('son' FROM 'Andrerson'); -- Result: Ander
SELECT replace('#PASSWORD#', 'WORD', 'PORT'); --result: "#PASSPORT#"
SELECT replace('1#3#5#7#9#', '#', '->'); -- Result: "1->3->5->7->9->"
