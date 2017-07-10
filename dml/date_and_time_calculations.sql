SELECT 'Very exact time currently is ' || localtimestamp;
SELECT 'Not so accurate time is ' || localtimestamp(2);
SELECT 'After twelve hours the clock shows ' || current_timestamp + INTERVAL '12 hour';
SELECT 'The date a year and ten days ago was' || current_timestamp - INTERVAL '1 year 10 day';
SELECT concat('Days till summer: ', '2017-06-22' - current_date);
SELECT ('2017-01-01' :: DATE, '2017-03-30' :: DATE) OVERLAPS ('2017-02-15' :: DATE, '2017-06-18' :: DATE);
SELECT ('2017-01-01' :: DATE, INTERVAL '10 days') OVERLAPS ('2017-02-15' :: DATE, '2017-06-18' :: DATE);
