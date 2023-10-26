-- from https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-recursive-query/
CREATE TABLE "kaido.kariste".employees (
	employee_id serial PRIMARY KEY,
	full_name VARCHAR NOT NULL,
	manager_id INT
);

-- The table where we start to use recursion should be "self-join" type table.
-- Here is good example about manager and subordinates
INSERT INTO "kaido.kariste".employees (
	employee_id,
	full_name,
	manager_id
)
VALUES
	(1, 'Michael North', NULL),
	(2, 'Megan Berry', 1),
	(3, 'Sarah Berry', 1),
	(4, 'Zoe Black', 1),
	(5, 'Tim James', 1),
	(6, 'Bella Tucker', 2),
	(7, 'Ryan Metcalfe', 2),
	(8, 'Max Mills', 2),
	(9, 'Benjamin Glover', 2),
	(10, 'Carolyn Henderson', 3),
	(11, 'Nicola Kelly', 3),
	(12, 'Alexandra Climo', 3),
	(13, 'Dominic King', 3),
	(14, 'Leonard Gray', 4),
	(15, 'Eric Rampling', 4),
	(16, 'Piers Paige', 7),
	(17, 'Ryan Henderson', 7),
	(18, 'Frank Tucker', 8),
	(19, 'Nathan Ferguson', 8),
	(20, 'Kevin Rampling', 8);

/*
General syntax
WITH RECURSIVE cte_name AS(
    CTE_query_definition -- non-recursive term
    UNION [ALL]
    CTE_query definion  -- recursive term
) SELECT * FROM cte_name;
*/

WITH RECURSIVE subordinates AS (
-- Non-recursive term: the non-recursive term is a CTE query definition that forms the base result set of the CTE structure.
SELECT employee_id,
       manager_id,
       full_name
FROM "kaido.kariste".employees
WHERE employee_id = 2
--Recursive term: the recursive term is one or more CTE query definitions
-- joined with the non-recursive term using the UNION or UNION ALL operator.
-- The recursive term references the CTE name itself.
UNION
SELECT e.employee_id,
       e.manager_id,
       e.full_name
FROM "kaido.kariste".employees e
         -- 'subordinates' table references the result of Non-recursive term hence here .. the manager
         INNER JOIN subordinates s ON s.employee_id = e.manager_id
)
SELECT *
FROM subordinates;

-- Result
/*
+-----------+----------+---------------+
|employee_id|manager_id|full_name      |
+-----------+----------+---------------+
|2          |1         |Megan Berry    | Non-recursive term
|6          |2         |Bella Tucker   | Recursive term
|7          |2         |Ryan Metcalfe  | Recursive term
|8          |2         |Max Mills      | Recursive term
|9          |2         |Benjamin Glover| Recursive term
|16         |7         |Piers Paige    | Recursive term 2nd iteration
|17         |7         |Ryan Henderson | Recursive term 2nd iteration
|18         |8         |Frank Tucker   | Recursive term 2nd iteration
|19         |8         |Nathan Ferguson| Recursive term 2nd iteration
|20         |8         |Kevin Rampling | Recursive term 2nd iteration
+-----------+----------+---------------+
*/