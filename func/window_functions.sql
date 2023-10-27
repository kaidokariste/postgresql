-- Cumulative sum
drop table kummulatiivne_summa;
create temporary table kummulatiivne_summa(id INT, jarjestus int,suurus int);
INSERT into kummulatiivne_summa(id, jarjestus, suurus)
values
    (1,1,1),(1,2,2),(1,3,3),(1,4,4),(1,5,5),(1,6,6),(2,1,1),(2,2,2);

SELECT *,
       SUM(suurus)
       OVER (PARTITION BY id ORDER BY id,jarjestus ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)     AS sum_app_previous_rows,
       SUM(suurus)
       OVER (PARTITION BY id ORDER BY id,jarjestus ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)             AS sum_two_previous_rows,
       SUM(suurus)
       OVER (PARTITION BY id ORDER BY id,jarjestus ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)             AS sum_two_following_rows
FROM kummulatiivne_summa;

--Produces
/*
+--+---------+------+---------------------+---------------------+----------------------+
|id|jarjestus|suurus|sum_app_previous_rows|sum_two_previous_rows|sum_two_following_rows|
+--+---------+------+---------------------+---------------------+----------------------+
|1 |1        |1     |1                    |1                    |6                     |
|1 |2        |2     |3                    |3                    |9                     |
|1 |3        |3     |6                    |6                    |12                    |
|1 |4        |4     |10                   |9                    |15                    |
|1 |5        |5     |15                   |12                   |11                    |
|1 |6        |6     |21                   |15                   |6                     |
|2 |1        |1     |1                    |1                    |3                     |
|2 |2        |2     |3                    |3                    |2                     |
+--+---------+------+---------------------+---------------------+----------------------+


*/