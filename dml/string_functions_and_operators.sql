-- String functions and operators
SELECT 'I am official mascot of' || concat('The ', 'Walt ', 'Disney ', 'Company') AS mickey_mouse;
SELECT 'My ' || 'friends ' || 'are ' || concat_ws(',', 'Donald Duck', 'Goofy') AS my_friends;
SELECT format('My girlfriend name is %s', 'Minnie Mouse') AS girlfriend;
SELECT 'My first name is ' || length('Mickey') || ' letters long.' AS length_first_name;
SELECT format('My second name is %s letters long.', char_length('Mouse'));
SELECT 'My first appearance was in movie ' || quote_ident('Steamboat Willie') || ' on year 1928';
SELECT 'This means that I am ' || age(TIMESTAMP '1928-11-21') || ' old' AS my_age;