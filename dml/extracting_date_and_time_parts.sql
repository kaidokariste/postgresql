SELECT format('Current date is %s and current time is %s', current_date, current_time) AS what_is_time;
SELECT format('This makes me %s old', age(TIMESTAMP '1990-01-01'));

-- But what to do then when there is no such table like dwh_date

SELECT
  date_part('century', '2017-03-23 17:42:35' :: TIMESTAMP) AS century,
  date_part('decade', '2017-03-23 17:42:35' :: TIMESTAMP)  AS decade,
  date_part('year', '2017-03-23 17:42:35' :: TIMESTAMP)    AS year,
  date_part('dow', '2017-03-23 17:42:35' :: TIMESTAMP)     AS day,
  date_part('doy', '2017-03-23 17:42:35' :: TIMESTAMP)     AS day_of_year;

-- Cutting the date
SELECT
  date_trunc('century', '2017-03-23 17:42:35' :: TIMESTAMP) AS century,
  date_trunc('decade', '2017-03-23 17:42:35' :: TIMESTAMP)  AS decade,
  date_trunc('year', '2017-03-23 17:42:35' :: TIMESTAMP)    AS year,
  date_trunc('month', '2017-03-23 17:42:35' :: TIMESTAMP)   AS month,
  date_trunc('week', '2017-03-23 17:42:35' :: TIMESTAMP)    AS week,
  date_trunc('day', '2017-03-23 17:42:35' :: TIMESTAMP)     AS day;

-- epoch - the number of seconds from 1970-01-01 00:00:00

SELECT EXTRACT(EPOCH FROM TIMESTAMP WITHOUT TIME ZONE '1970-01-01 00:00:00.00');
SELECT EXTRACT(EPOCH FROM TIMESTAMP WITHOUT TIME ZONE '1970-01-01 00:02:0.00');
SELECT EXTRACT(EPOCH FROM TIMESTAMP WITH TIME ZONE '1970-01-01 00:00:00.00');