-- Second part in data formatinc functions are called as "format mask"
SELECT to_char(current_timestamp, 'HH12:MI:SS');

-- What does D mean in format mask
SELECT to_number('12.34', '9999D99');
-- Why does next query give an error?
SELECT to_number('12.34', '9D9999');
SELECT to_number('1 990.25', '9G999D99');
SELECT to_number('-1 990,885.25', 'MI9G999,999D99');
SELECT to_number('-1 990,885.25', 'LMI9G999,999D99');

-- What do zeros do and can we put other numbers than 9 or 0?
SELECT to_char(12.34, '00099D99');
SELECT to_char(45.56, 'L99D99');
SELECT to_char(45.56, 'PL99D99');
SELECT to_char(3999, 'RN');
SELECT to_char(485, 'FMRN');

SELECT to_date('11/09/2017 22:40:15', 'DD/MM/YYYY HH24:MI:SS');
SELECT to_timestamp('11/09/2017 22:40:15', 'DD/MM/YYYY HH24:MI:SS');
